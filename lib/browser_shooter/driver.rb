class BrowserShooter
  module Driver
    def self.run_script_on_browser(script, browser, shots_path)
      client = nil

      begin
        BrowserShooter::Logger.log "Runing script '#{script["name"]}' in browser '#{browser["name"]}'"

        client =
          Selenium::WebDriver.for(
            :remote,
            :url => browser["url"],
            :desired_capabilities => browser["browser"].to_sym
          )

        logs =
          script["commands"].lines.map do |command|
            BrowserShooter::Commander.wrapper_execute(
              command.strip,
              client,
              "#{shots_path}/#{script["name"]}_#{browser["name"]}"
            )
          end

        logs

      ensure
        client.quit if client

      end
    end
  end
end