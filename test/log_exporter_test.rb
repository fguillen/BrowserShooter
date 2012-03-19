require_relative "test_helper"

class LogExporterTest < Test::Unit::TestCase
  def setup
    super

    @logs = [
      {
        :time     => "the time 1",
        :success  => true,
        :command  => "the command 1",
        :message  => "the message 1"
      },
      {
        :time     => "the time 2",
        :success  => false,
        :command  => "the command 2",
        :message  => "the message 2"
      }
    ]
  end

  def test_export_should_call_sub_methods
    BrowserShooter::LogExporter.expects( :export_to_format ).with( "logs", File.expand_path( "path/log.format" ) )
    BrowserShooter::LogExporter.export( "logs", "path", "format" )
  end

  def the_export_should_create_dir
    BrowserShooter::LogExporter.stubs( :export_to_format )
    FileUtils.expects( :mkdir_p ).with( File.expand_path( "output_path/log.format" ) )
    BrowserShooter::LogExporter.export( "logs", "output_path", "format" )
  end

  def test_export_to_csv
    in_tmpdir do |path|
      BrowserShooter::LogExporter.export_to_csv( @logs, "#{path}/log.csv" )
      result = File.read( "#{path}/log.csv" )

      # File.open( "#{FIXTURES}/logs/log.csv", "w" ) { |f| f.write result }

      assert_equal( read_fixture( "logs/log.csv" ), result )
    end
  end
end