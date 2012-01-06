class BrowserShooter
  module Driver
    def self.run_script_on_browser(script, browser, shoots_path)
      BrowserShooter::Logger.log "Runing script '#{script["name"]}' with url '#{script["url"]}' in browser '#{browser["name"]}'"

      client = nil

      begin
        client =
          Selenium::Client::Driver.new(
            :host     => browser["host"],
            :port     => browser["port"],
            :browser  => browser["browser"],
            :url      => script["url"],
            :timeout_in_seconds => 40
          )

        client.start_new_browser_session

        script["commands"].lines.each do |command|
          BrowserShooter::Commander.execute(
            command,
            client,
            "#{shoots_path}/#{script["name"]}_#{browser["name"]}"
          )
        end

      rescue Exception => e
        BrowserShooter::Logger.log "ERROR: #{e.message}"
        # puts e.backtrace

      ensure
        client.close_current_browser_session if client

      end
    end
  end
end