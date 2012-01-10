require "test/unit"
require "mocha"
require_relative "../lib/browser_shooter"

module TestHelper
  FIXTURES = File.expand_path( "#{File.dirname(__FILE__)}/fixtures" )

  def read_fixture( fixture_name )
    File.read( "#{FIXTURES}/#{fixture_name}" )
  end

  def in_tmpdir
    path = File.expand_path "#{Dir.tmpdir}/#{Time.now.to_i}_#{rand(1000)}/"
    FileUtils.mkdir_p( path )

    yield( path )

  ensure
    FileUtils.rm_rf( path ) if File.exists?( path )
  end
end

class Test::Unit::TestCase
  include TestHelper

  def setup
    BrowserShooter::Logger.stubs( :log )
  end
end

