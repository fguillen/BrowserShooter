# BrowserShooter

Combined with Selenium RC this gem allows to program Selenium scripts combined with screenshots.

## Use it

### Setup the servers

#### Starting the Selenium RC server

1. Set up your VirtualMachines with your target SO and browsers installed. Java SE is also needed.
2. Download the last version of [Selenium Server](http://seleniumhq.org/download/) (AKA Selenium Remote Control).
3. Go to the console and start the Selenium Server:

    java -jar &lt;your selenium server file&gt;.jar


#### Pluging for IE screenshots

[Spnapsie](http://snapsie.sourceforge.net/)


#### Chrome WebDriver

In the servers that are gonna execute Chrome you have to install the [ChromeDriver](http://code.google.com/p/selenium/wiki/ChromeDriver).

Repeat these steps in every VM.

### Setup the driver

#### Install the gem

    gem install "browser_shooter"

#### Config your BrowserShooter script

Create a YAML file like this:

    # myconfig.yml
    output_path: "/tmp/shoots"
    logs_format: "csv"

    scripts:
      google:
        name: "google"
        # commands are WebDriver commands
        # except 'shot' command which receive an optional param with the 'sufix' of the page screenshot png
        # except 'pause' command which use a Ruby 'sleep' command to pause
        # except 'click' command whith receive a 'css_selector' as a param, find the element and click on it
        # except 'type' command whith receive two params: 'css_selector' ana a 'message', find the element and type the message on it
        # except 'wait_for_element' command whith receive two params: 'css_selector', and a 'timeout' in seconds
        commands: |
          navigate.to "http://www.google.de"
          shot before
          type "input[name='q']", "beautiful houses"
          click "input[name='btnG']"
          pause 3
          click "a.kls"
          pause 3
          shot after

    browsers:
      windows-firefox:
        name: "windows-firefox"
        url: "http://127.0.0.1:4444/wd/hub"
        browser: "firefox"

      windows-iexplore:
        name: "windows-iexploreproxy"
        url: "http://127.0.0.1:4444/wd/hub"
        browser: "*iexploreproxy"

Look in the [examples folder](https://github.com/fguillen/BrowserShooter/tree/master/examples) for more complete examples.


#### Run the BrowserShooter script

    $ browser_shooter ./my/config.yml

The screenshots will be stored in:

    /<output_path>/<time_stamp>/shots

The logs will be stored in:

    /<output_path>/<time_stamp>/logs

## Status

Still in a _discovery_ state.. but is already **functional**.