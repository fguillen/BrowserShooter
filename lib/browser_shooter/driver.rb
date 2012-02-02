class BrowserShooter
  module Driver
    def self.run_script_on_browser(script, browser, output_path)
      client = nil

      begin
        BrowserShooter::Logger.log "Runing script '#{script["name"]}' with url '#{script["url"]}' in browser '#{browser["name"]}'"

        client =
          Selenium::Client::Driver.new(
            :host     => browser["host"],
            :port     => browser["port"],
            :browser  => browser["browser"],
            :url      => script["url"],
            :timeout_in_seconds => 40
          )

        client.start_new_browser_session

        logs =
          script["commands"].lines.map do |command|
            BrowserShooter::Commander.wrapper_execute(
              command.strip,
              client,
              "#{output_path}/#{script["name"]}_#{browser["name"]}"
            )
          end

        logs

      ensure
        client.close_current_browser_session if client

      end
    end
  end
end