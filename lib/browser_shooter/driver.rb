module BrowserShooter
  module Driver
    def self.run_script(commands, browser, output_path)
      client = nil

      begin
        BrowserShooter::Logger.log "Runing commands in browser '#{browser["name"]}'"

        client =
          Selenium::WebDriver.for(
            :remote,
            :url => browser.url,
            :desired_capabilities => browser.type.to_sym
          )

        logs =
          commands.map do |command|
            BrowserShooter::Commander.wrapper_execute(
              command.strip,
              client,
              output_path
            )
          end

        logs

      ensure
        client.quit if client

      end
    end
  end
end