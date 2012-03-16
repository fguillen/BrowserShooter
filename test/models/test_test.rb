require_relative "../test_helper"

class TestTest < Test::Unit::TestCase
  def test_initialize
    test = BrowserShooter::Models::Test.new( "name", "commands" )
    assert_equal( "name", test.name )
    assert_equal( "commands", test.commands )
  end
end