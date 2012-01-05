require_relative "test_helper"

class BrowserScreenshotTest < Test::Unit::TestCase
  def test_run
    BrowserShooter.new( "#{FIXTURES}/config.yml" ).run
  end
end