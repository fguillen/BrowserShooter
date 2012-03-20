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

### Setup the client

#### Install the gem

    gem install "browser_shooter"

#### Config your BrowserShooter script

Create a YAML file like this:

    # myconfig.yml
    output_path: "/tmp/shoots"

    tests:
      google: |
        navigate.to "http://www.google.de"
        shot before
        type "input[name='q']", "beautiful houses"
        click "input[name='btnG']"
        pause 3
        click "a.kls"
        pause 3
        shot after

      miniclip: |
        navigate.to "http://www.miniclip.com/games/de/"
        shot

    browsers:
      windows-firefox:
        url: "http://127.0.0.1:4444/wd/hub"
        type: "firefox"

      windows-iexplore:
        url: "http://127.0.0.1:4444/wd/hub"
        type: "ie"

    suites:
      suite1:
        tests:
          - google
          - miniclip
        browsers:
          - ios-firefox
          - ios-chrome

      suite2:
        tests:
          - google
        browsers:
          - ios-chrome


Look in the [examples folder](https://github.com/fguillen/BrowserShooter/tree/master/examples) for more complete examples.

##### Tests section

Commands are WebDriver commands, except:

* **shot** command which receive an optional param with the 'sufix' of the page screenshot png
* **pause** command which use a Ruby 'sleep' command to pause
* **click** command which receive a 'css_selector' as a param, find the element and click on it
* **type** command which receive two params: 'css_selector' ana a 'message', find the element and type the message on it
* **wait_for_element** command which receive two params: 'css_selector', and a 'timeout' in seconds

You can define as much tests as you want. Every test is composed by a list of **one line** commands.

##### Browsers section

All the available browsers with the **selenium server url** and the **selenium browser type**.

##### Suites section

Groups of **tests** and **browsers** to be executed as one.


#### Run the BrowserShooter script

##### The simple way

    $ browser_shooter --config ./my/config.yml

##### Choosing a suite

    $ browser_shooter --config ./my/config.yml -s --suite suite1

##### Choosing a test

    $ browser_shooter --config ./my/config.yml -s --test google

##### Choosing a test an a list of browsers

    $ browser_shooter --config ./my/config.yml -s --test google --browsers windows-firefox,windows-iexplore

##### Check all the options

    $ browser_shooter --help


#### The output paths

The screenshots will be stored in:

    /<output_path>/<time_stamp>/<suite_name>/<test_name>/<browser_name>/shots

The logs will be stored in:

    /<output_path>/<time_stamp>/<suite_name>/<test_name>/<browser_name>/logs

## Status

Still in a _development_ state.. but is already **functional**.