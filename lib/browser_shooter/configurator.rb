module BrowserShooter
  class Configurator
    attr_reader :suites

    # Takes the digested command options and create and filter the models
    def initialize( opts )
      @config = BrowserShooter::Configurator.load_config( opts[:config_file] )
      models  = BrowserShooter::Configurator.build_models( @config )
      @suites = BrowserShooter::Configurator.filter_suites( models, opts )

      BrowserShooter::Configurator.load_extensions( @config["extensions"] ) if @config["extensions"]
    end

    # The hash version of the _config.yml_ is available here
    def [](value)
      @config[value]
    end

    # Load the _config.yml_ file and return it in a Hash format
    def self.load_config( config_file_path )
      config = {
        "output_path" => "~/browser_shooter",
        "timeout"    => 40
      }

      config.merge! YAML.load_file( config_file_path )

      config["output_path"]       = setup_output_path( config["output_path"] )
      config["config_root_path"]  = File.dirname( config_file_path )

      # _tests_ key is a folder path for external test files
      if( config["tests"].is_a?( String ) )
        config["tests"] = BrowserShooter::Configurator.load_external_tests( config )
      end

      config
    end

    # If the _tests_ key in the _config.yml_ is an string
    # we load of the files in this path as _tests_ and add
    # them to the original config.
    def self.load_external_tests( config )
      tests_path = File.join( config["config_root_path"], config["tests"] )

      BrowserShooter::Logger.log( "Loading external tests: #{tests_path}" )

      raise ArgumentError, "External tests dir path doesn't exist: 'tests_path'" if !File.exists?( tests_path )

      tests = {}

      Dir.glob( "#{tests_path}/*.test" ).each do |test_path|
        test_name = File.basename( test_path, ".test" )
        tests[ test_name ] = File.read( test_path )
      end

      return tests
    end

    # Creates the _tests_, _browsers_ and _suites_ arrays.
    def self.build_models( config )
      tests =
        config["tests"].map do |name, commands|
          test_commands = commands.split( "\n" )

          BrowserShooter::Models::Test.new( name, test_commands )
        end

      browsers =
        config["browsers"].map do |name, opts|
          BrowserShooter::Models::Browser.new( name, opts["url"], opts["type"], opts["vm"] )
        end

      suites =
        config["suites"].map do |name, opts|
          suite_tests    = BrowserShooter::Utils.find_by_names( tests, opts["tests"] )
          suite_browsers = BrowserShooter::Utils.find_by_names( browsers, opts["browsers"] )

          BrowserShooter::Models::Suite.new( name, suite_tests, suite_browsers )
        end

      {
        :tests    => tests,
        :browsers => browsers,
        :suites   => suites
      }
    end

    # If special _filter_ options has been defined in the _command options_ the _suites_ are filtered
    # to only play with the filtered ones.
    def self.filter_suites( models, opts )
      suites = []

      if( opts[:suite] )
        suite = BrowserShooter::Utils.find_by_name( models[:suites], opts[:suite] )

        suites = [suite]

      elsif( opts[:test] && opts[:browsers] )
        test      = BrowserShooter::Utils.find_by_name( models[:tests], opts[:test] )
        browsers  = BrowserShooter::Utils.find_by_names( models[:browsers], opts[:browsers] )
        suite     = BrowserShooter::Models::Suite.new( "anonymous", [test], browsers )

        suites = [suite]

      elsif( opts[:test] )
        test      = BrowserShooter::Utils.find_by_name( models[:tests], opts[:test] )
        browsers  = models[:browsers]
        suite     = BrowserShooter::Models::Suite.new( "anonymous", [test], browsers )

        suites = [suite]

      else
        suites = models[:suites]

      end

      suites
    end

    def self.setup_output_path( output_path )
      output_path = File.expand_path( "#{output_path}/#{BrowserShooter::Utils.timestamp}" )
      BrowserShooter::Logger.log( "output_path: #{output_path}" )

      output_path
    end

    def self.load_extensions( extensions_paths )
      extensions_paths.each do |extension_path|
        extension_path = File.expand_path( extension_path )
        BrowserShooter::Logger.log( "Loading extension: #{extension_path}" )
        Kernel.require( extension_path )
      end
    end

  end
end