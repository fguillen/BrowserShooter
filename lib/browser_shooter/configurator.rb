module BrowserShooter
  class Configurator
    attr_reader :suites

    def initialize( opts )
      @config = BrowserShooter::Configurator.load_config( opts[:config_file] )
      models = BrowserShooter::Configurator.build_models( @config )
      @suites = BrowserShooter::Configurator.filter_suites( models, opts )
    end

    def [](value)
      @config[value]
    end

    def self.filter_suites( models, opts )
      suites = []

      if( opts[:suite] )
        suite  = models[:suites].select{ |e| e.name == opts[:suite] }.first
        raise ArgumentError, "Not suite found '#{opts[:suite]}'" if suite.nil?

        suites = [suite]

      elsif( opts[:test] && opts[:browsers] )
        test      = models[:tests].select{ |e| e.name == opts[:test] }.first
        raise ArgumentError, "Not test found '#{opts[:test]}'" if test.nil?

        browsers  = models[:browsers].select{ |e| opts[:browsers].include? e.name }
        raise ArgumentError, "Not browsers found '#{opts[:browsers].join( "," )}'" if browsers.empty?

        suite     = BrowserShooter::Models::Suite.new( "anonymous", [test], browsers )
        suites    = [suite]

      elsif( opts[:test] )
        test      = models[:tests].select{ |e| e.name == opts[:test] }.first
        raise ArgumentError, "Not test found '#{opts[:test]}'" if test.nil?

        browsers  = models[:browsers]
        suite     = BrowserShooter::Models::Suite.new( "anonymous", [test], browsers )
        suites    = [suite]

      else
        suites    = models[:suites]

      end

      suites
    end

    def self.build_models( config )
      tests =
        config["tests"].map do |name, commands|
          test_commands = commands.split( "\n" )

          BrowserShooter::Models::Test.new( name, test_commands )
        end

      browsers =
        config["browsers"].map do |name, opts|
          BrowserShooter::Models::Browser.new( name, opts["url"], opts["type"] )
        end

      suites =
        config["suites"].map do |name, opts|
          suite_tests    = tests.select{ |e| opts["tests"].include? e.name }
          suite_browsers = browsers.select{ |e| opts["browsers"].include? e.name }

          BrowserShooter::Models::Suite.new( name, suite_tests, suite_browsers )
        end

      {
        :tests    => tests,
        :browsers => browsers,
        :suites   => suites
      }
    end

    def self.load_config( config_file_path )
      config = {
        "output_path" => "~/browser_shooter",
        "logs_format" => "csv"
      }

      config.merge! YAML.load_file( config_file_path )

      config["output_path"] = set_up_output_path( config["output_path"] )

      config
    end

    def self.set_up_output_path( output_path )
      output_path = File.expand_path( "#{output_path}/#{timestamp}" )
      BrowserShooter::Logger.log( "output_path: #{output_path}" )

      output_path
    end

    def self.timestamp
      Time.now.strftime("%Y%m%d%H%M%S")
    end
  end
end