require_relative "../test_helper"

class SuiteTest < Test::Unit::TestCase
  def test_initialize
    suite = BrowserShooter::Models::Suite.new( "name", "tests", "browsers" )
    assert_equal( "name", suite.name )
    assert_equal( "tests", suite.tests )
    assert_equal( "browsers", suite.browsers )
  end
end