module BrowserShooter
  class Base
    attr_reader :opts

    def initialize( opts )
      @opts = opts
    end

    # Main method. Loads the configuration, filter the suites, runs the tests and exports the logs.
    def run
      BrowserShooter::Logger.verbose = opts[:verbose]
      BrowserShooter::Logger.log( "Starting script running with version #{BrowserShooter::VERSION}..." )

      config = BrowserShooter::Configurator.new( opts )
      suites = config.suites

      suites.each do |suite|
        suite.tests.each do |test|
          suite.browsers.each do |browser|
            BrowserShooter::Base.run_test(
              suite,
              test,
              browser,
              config
            )
          end
        end
      end

      BrowserShooter::Logger.log( "... script running ended." )
      BrowserShooter::Logger.log( "Logs and Shots are in: #{config["output_path"]}", true )
      BrowserShooter::Logger.log( "BYE!" )
    end

    # Runs a single test with all its _commands_ in an specific _browser_
    def self.run_test( suite, test, browser, config )
      BrowserShooter::Logger.log( "Executing #{suite.name} | #{test.name} | #{browser.name}", true )
      output_path = "#{config["output_path"]}/#{suite.name}/#{test.name}/#{browser.name}"

      driver = nil

      begin
        driver =
          Selenium::WebDriver.for(
            :remote,
            :url => browser.url,
            :desired_capabilities => browser.type.to_sym
          )

        driver.manage.timeouts.implicit_wait = config["timeout"]

        logs =
          BrowserShooter::Commander.script(
            test.commands,
            driver,
            browser,
            output_path
          )

        BrowserShooter::LogExporter.export(
          logs,
          "#{output_path}/logs"
        )

      ensure
        driver.quit if driver
      end
    end
  end
end