require_relative "test_helper"

class ARGVParserTest < Test::Unit::TestCase
  def test_parse_options
    argvs = "-c my/file/path.yml -v -s my_suite -t my_test -b browser1,browser2"
    argv_parser = BrowserShooter::ARGVParsers.new
    argv_parser.parse_options( argvs.split )

    assert_equal( "my/file/path.yml", argv_parser.config[:config_file] )
    assert_equal( "my_suite", argv_parser.config[:suite] )
    assert_equal( "my_test", argv_parser.config[:test] )
    assert_equal( ["browser1", "browser2"], argv_parser.config[:browsers] )
    assert_equal( true, argv_parser.config[:verbose] )
  end
end