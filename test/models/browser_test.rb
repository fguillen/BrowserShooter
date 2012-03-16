require_relative "../test_helper"

class BrowserTest < Test::Unit::TestCase
  def test_initialize
    browser = BrowserShooter::Models::Browser.new( "name", "url", "type")
    assert_equal( "name", browser.name )
    assert_equal( "url", browser.url )
    assert_equal( "type", browser.type )
  end
end