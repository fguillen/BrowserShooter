require "selenium-webdriver"
require "mixlib/cli"
require "yaml"
require "json"

require_relative "./browser_shooter/models/suite"
require_relative "./browser_shooter/models/test"
require_relative "./browser_shooter/models/browser"
require_relative "./browser_shooter/version"
require_relative "./browser_shooter/configurator"
require_relative "./browser_shooter/logger"
require_relative "./browser_shooter/driver"
require_relative "./browser_shooter/commander"
require_relative "./browser_shooter/log_exporter"
require_relative "./browser_shooter/argv_parser"


class BrowserShooter
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

