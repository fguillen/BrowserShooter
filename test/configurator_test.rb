require_relative "test_helper"

class ConfiguratorTest < Test::Unit::TestCase
  def test_initialize
    opts = {
      :config_file  => "config_file",
    }

    config = {
      "key1"         => "value1",
      "extensions"   => [ "extension1.rb", "extension2.rb" ]
    }

    BrowserShooter::Configurator.expects( :load_config ).with( "config_file" ).returns( config )
    BrowserShooter::Configurator.expects( :build_models ).with( config ).returns( "models" )
    BrowserShooter::Configurator.expects( :filter_suites ).with( "models", opts ).returns( "suites" )
    BrowserShooter::Configurator.expects( :load_extensions ).with( ["extension1.rb", "extension2.rb"] )

    configurator = BrowserShooter::Configurator.new( opts )

    assert_equal( "value1", configurator["key1"] )
    assert_equal( "suites", configurator.suites )
  end

  def test_build_models
    BrowserShooter::Configurator.stubs( :setup_output_path )
    config = BrowserShooter::Configurator.load_config( "#{FIXTURES}/config.yml" )
    models = BrowserShooter::Configurator.build_models( config )

    assert_equal( 2, models[:tests].size )
    assert_equal( "google", models[:tests].first.name )
    assert_equal( 6, models[:tests].first.commands.size )
    assert_equal( "navigate.to \"http://www.google.de\"", models[:tests].first.commands.first )

    assert_equal( 3, models[:browsers].size )
    assert_equal( "windows-firefox", models[:browsers].first.name )
    assert_equal( "http://10.211.55.4:4444/wd/hub", models[:browsers].first.url )
    assert_equal( "firefox", models[:browsers].first.type )
    assert_equal( "vmName1", models[:browsers].first.vm )

    assert_equal( 2, models[:suites].size )
    assert_equal( "suite1", models[:suites].first.name )
    assert_equal( 2, models[:suites].first.tests.size )
    assert_equal( models[:tests].first, models[:suites].first.tests.first )
    assert_equal( 2, models[:suites].first.browsers.size )
    assert_equal( models[:browsers].first, models[:suites].first.browsers.first )
  end

  def test_filter_suites
    BrowserShooter::Configurator.stubs( :setup_output_path )
    config = BrowserShooter::Configurator.load_config( "#{FIXTURES}/config.yml" )
    models = BrowserShooter::Configurator.build_models( config )

    opts = {}
    suites = BrowserShooter::Configurator.filter_suites( models, opts )
    assert_equal( 2, suites.size )

    opts = { :suite => "suite1" }
    suites = BrowserShooter::Configurator.filter_suites( models, opts )
    assert_equal( 1, suites.size )
    assert_equal( 2, suites.first.tests.size )
    assert_equal( "google", suites.first.tests.first.name )
    assert_equal( "miniclip", suites.first.tests.last.name )

    opts = { :suite => "suite2" }
    suites = BrowserShooter::Configurator.filter_suites( models, opts )
    assert_equal( 1, suites.size )
    assert_equal( "suite2", suites.first.name )

    opts = { :test => "google" }
    suites = BrowserShooter::Configurator.filter_suites( models, opts )
    assert_equal( 1, suites.size )
    assert_equal( "anonymous", suites.first.name )
    assert_equal( 1, suites.first.tests.size )
    assert_equal( "google", suites.first.tests.first.name )
    assert_equal( 3, suites.first.browsers.size )

    opts = { :test => "google", :browsers => ["windows-firefox", "windows-iexplore"] }
    suites = BrowserShooter::Configurator.filter_suites( models, opts )
    assert_equal( 1, suites.size )
    assert_equal( "anonymous", suites.first.name )
    assert_equal( 1, suites.first.tests.size )
    assert_equal( "google", suites.first.tests.first.name )
    assert_equal( 2, suites.first.browsers.size )
    assert_equal( "windows-firefox", suites.first.browsers.first.name )
  end

  def test_load_config
    BrowserShooter::Configurator.expects( :timestamp ).returns( "timestamp" )

    config = BrowserShooter::Configurator.load_config( "#{FIXTURES}/config_simple.yml" )

    assert_equal( "/output_path/timestamp", config["output_path"] )
    assert_equal( 20, config["timeout"] )
    assert_equal( "script-one", config["tests"]["script-one"] )
    assert_equal( "browser-one", config["browsers"]["browser-one"] )
  end

  def test_load_config_with_defaults
    BrowserShooter::Configurator.expects( :timestamp ).returns( "timestamp" )

    config = BrowserShooter::Configurator.load_config( "#{FIXTURES}/config_empty.yml" )

    assert_equal( File.expand_path( "~/browser_shooter/timestamp" ), config["output_path"] )
    assert_equal( 40, config["timeout"] )
  end

  def test_load_extensions
    Kernel.expects( :require ).with( File.expand_path( "extension1.rb" ) )
    Kernel.expects( :require ).with( File.expand_path( "extension2.rb" ) )
    BrowserShooter::Configurator.load_extensions( ["extension1.rb", "extension2.rb"] )
  end
end