require_relative "./browser_shooter/version"
require_relative "./browser_shooter/configurator"
require_relative "./browser_shooter/logger"
require_relative "./browser_shooter/driver"
require_relative "./browser_shooter/commander"
require_relative "./browser_shooter/log_exporter"

require "selenium-webdriver"
require "selenium-client"
require "yaml"
require "json"

class BrowserShooter
  attr_reader :config_file_path

  def initialize( config_file_path )
    @config_file_path = config_file_path
  end

  def run
    BrowserShooter::Logger.log "Starting script running with version #{BrowserShooter::VERSION}..."

    config  = BrowserShooter::Configurator.load_config( config_file_path )
    logs    = {}

    config["scripts"].each_value do |script|
      config["browsers"].each_value do |browser|
        logs["#{script["name"]}_#{browser["name"]}"] =
          BrowserShooter::Driver.run_script_on_browser(script, browser, "#{config["output_path"]}/shots")
      end
    end

    BrowserShooter::LogExporter.export( logs, "#{config["output_path"]}/logs", config["logs_format"] )

    BrowserShooter::Logger.log "... script running ended."
    BrowserShooter::Logger.log "shots are in: #{config["output_path"]}/shots"
    BrowserShooter::Logger.log "logs are in: #{config["output_path"]}/logs"
    BrowserShooter::Logger.log "BYE!"
  end
end

