# BrowserShooter

Combined with Selenium RC this gem allows to program Selenium scripts combined with screenshots.

## Use it

### Setup the servers

#### Starting the Selenium RC server

1. Set up your VirtualMachines with your target SO and browsers installed. Java SE is also needed.
2. Download the last version of [Selenium Server](http://seleniumhq.org/download/) (AKA Selenium Remote Control).
3. Go to the console and start the Selenium Server:

    java -jar <your selenium server file>.jar


#### Pluging for IE screenshots

[Spnapsie](http://snapsie.sourceforge.net/)

Repeat this steps in every VM.

### Setup the client

#### Install the gem

    gem install "browsers_shooter"

#### Config your BrowserShooter script

Create a YAML file like this:

    # myconfig.yml
    output_path: "/tmp/shoots"

    scripts:
      google:
        name: "google"
        url: "http://www.google.de"
        # commands are Selenium commands
        # except 'shot' command which receive an optional param with the 'sufix' of the page screenshot png
        # except 'shot_system' command which receive an optional param with the 'sufix' of the system screenshot png
        # except 'pause' command which use a Ruby 'sleep' command to pause
        commands: |
          open "/"
          window_maximize
          shot before
          type "id=lst-ib", "fernando guillen"
          click "name=btnG", wait_for :page
          pause 3
          shot after

    browsers:
      windows-firefox:
        name: "windows-firefox"
        host: 10.211.55.4
        port: 4444
        browser: "*firefox"

      windows-iexplore:
        name: "windows-iexploreproxy"
        host: 10.211.55.4
        port: 4444
        browser: "*iexploreproxy"

Look in the `examples` folder for more complete examples.


#### Run the BrowserShooter script

    $ browser_shooter ./my/config.yml

The screenshots will be stored in:

    /<output_path>/<time_stamp>/<script_name>_<browser_name>[_<sufix>].png

## Status

Still in a _discovery_ state.. but is already **functional**.