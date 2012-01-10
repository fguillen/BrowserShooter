require_relative "./browser_shooter/version"
require_relative "./browser_shooter/configurator"
require_relative "./browser_shooter/logger"
require_relative "./browser_shooter/driver"
require_relative "./browser_shooter/commander"

require "selenium-webdriver"
require "selenium-client"
require "yaml"

class BrowserShooter
  attr_reader :config_file_path

  def initialize( config_file_path )
    @config_file_path = config_file_path
  end

  def run
    BrowserShooter::Logger.log "Starting script running with version #{BrowserShooter::VERSION}..."

    config = BrowserShooter::Configurator.load_config( config_file_path )

    config["scripts"].each_value do |script|
      config["browsers"].each_value do |browser|
        BrowserShooter::Driver.run_script_on_browser(script, browser, config["shoots_path"])
      end
    end

    BrowserShooter::Logger.log "... script running ended."
  end
end

