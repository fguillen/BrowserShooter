require_relative "test_helper"

class LogExporterTest < Test::Unit::TestCase
  def setup
    super

    @logs = {
      "script1" => [
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
      ],
      "script2" => [
        {
          :time     => "the time 3",
          :success  => true,
          :command  => "the command 3",
          :message  => "the message 3"
        }
      ]
    }
  end

  def test_export_should_call_sub_methods
    BrowserShooter::LogExporter.expects( :"export_to_format" ).with( "logs", "path" )
    BrowserShooter::LogExporter.export( "logs", "path", "format" )
  end

  def test_export_to_json
    in_tmpdir do |path|
      BrowserShooter::LogExporter.export_to_json( @logs, path )
      result = File.read( "#{path}/logs.json" )

      # File.open( "#{FIXTURES}/logs/logs.json", "w" ) { |f| f.write result }

      assert_equal( read_fixture( "logs/logs.json" ), result )
    end
  end

  def test_export_to_csv
    in_tmpdir do |path|
      BrowserShooter::LogExporter.export_to_csv( @logs, path )
      result1 = File.read( "#{path}/script1.csv" )
      result2 = File.read( "#{path}/script2.csv" )

      # File.open( "#{FIXTURES}/logs/script1.csv", "w" ) { |f| f.write result1 }
      # File.open( "#{FIXTURES}/logs/script2.csv", "w" ) { |f| f.write result2 }

      assert_equal( read_fixture( "logs/script1.csv" ), result1 )
      assert_equal( read_fixture( "logs/script2.csv" ), result2 )
    end
  end
end