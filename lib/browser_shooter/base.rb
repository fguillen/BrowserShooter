module BrowserShooter
  class Base
    attr_reader :opts

    def initialize( opts )
      @opts = opts
    end

    def run
      BrowserShooter::Logger.log "Starting script running with version #{BrowserShooter::VERSION}..."

      config = BrowserShooter::Configurator.new( opts )
      suites = config.suites

      suites.each do |suite|
        suite.tests.each do |test|
          suite.browsers.each do |browser|
            output_path = "#{config["output_path"]}/#{suite.name}/#{test.name}/#{browser.name}"

            logs =
              BrowserShooter::Driver.run_script(
                test.commands,
                browser,
                output_path
              )

            BrowserShooter::LogExporter.export(
              logs,
              "#{output_path}/logs",
              config["logs_format"]
            )
          end
        end
      end

      BrowserShooter::Logger.log "... script running ended."
      BrowserShooter::Logger.log "shots are in: #{config["output_path"]}/shots"
      BrowserShooter::Logger.log "logs are in: #{config["output_path"]}/logs"
      BrowserShooter::Logger.log "BYE!"
    end
  end
end