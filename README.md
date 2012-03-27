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
    extensions:
      - ~/browser_shooter/my_extension_1.rb
      - ~/browser_shooter/my_extension_2.rb

    tests:
      google: |
        navigate.to "http://www.google.de"
        shot "before"
        type "input[name='q']", "beautiful houses"
        click "input[name='btnG']"
        pause 3
        click "a.kls"
        pause 3
        shot "after"
        shot_system "final_shot"

      miniclip: |
        navigate.to "http://www.miniclip.com/games/de/"
        shot

    browsers:
      windows-firefox:
        url: "http://127.0.0.1:4444/wd/hub"
        type: "firefox"
        vm: "VirtualBox name"

      windows-iexplore:
        url: "http://127.0.0.1:4444/wd/hub"
        type: "ie"
        vm: "VirtualBox name"

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

###### WebDriver commands

You can use any command from the [WebDriver API](http://selenium.googlecode.com/svn/trunk/docs/api/rb/index.html).

Any command you can call from a `driver` instance like:

    driver.navigate.to "http://google.com"

You can use in the _test section_ just removing the `driver` word:

    navigate.to "http://google.com"

###### Extended Commands

Also you can use this list of _extended commands_:

* **shot**              receives an optional param with the 'sufix' of the page screenshot png
* **shot_system**       equal to 'shot' but uses the "VirtualBox" system command "VBoxManage" to make an screenshot of the OS screen.
* **pause**             uses a Ruby 'sleep' command to pause
* **click**             receives a 'css_selector' as a param, find the element and click on it
* **type**              receives two params: 'css_selector' ana a 'message', find the element and type the message on it
* **wait_for_element**  receives two params: 'css_selector', and a 'timeout' in seconds
* **try**               receives an string wich is Ruby code, you have access here to variables like `driver`, `browser` and `output_path`.
* **debug**             receives no argument. When the test arrives to this command a Ruby console will be open and you will be able to write Ruby commands on the air. Until you write `exit`.

You can define as much tests as you want. Every test is composed by a list of **one line** commands.

###### Custom Extended Commands

If you need to add new commands to the _test section_ you can implement your own ones.

Write a file like this:

    # my_extension.rb
    module MyExtension
      def log( arg1, arg2 )
        puts "This is the log extension method"
        puts "arg1: #{arg1}"
        puts "arg2: #{arg2}"
        puts "driver: #{driver}"
        puts "browser: #{browser}"
        puts "output_path: #{output_path}"
      end
    end
    BrowserShooter::Commands::Base.plug( MyExtension )

Declare this extension file in the _extensions section_:

    # config.yml
    extensions:
      - path/to/my_extension.rb

Then you will be able to use this new command into the _test section_ like this:

    log "myarg1", "myarg2"

You can check the [custom extensions](https://github.com/fguillen/BrowserShooter/tree/master/lib/browser_shooter/commands) that are already integrated in BrowserShooter.


##### Browsers section

All the available browsers with the **selenium server url** and the **selenium browser type**.

Also if you are gonna use the _shot_system_ command you have to indicate the name of the VirtualBox machine in the **vm** attribute.

##### Suites section

Groups of **tests** and **browsers** to be executed as one.


#### Run the BrowserShooter script

##### The simple way

    $ browser_shooter --config ./my/config.yml

##### Choosing a suite

    $ browser_shooter --config ./my/config.yml --suite suite1

##### Choosing a test

    $ browser_shooter --config ./my/config.yml --test google

##### Choosing a test an a list of browsers

    $ browser_shooter --config ./my/config.yml --test google --browsers windows-firefox,windows-iexplore

##### Verbose

    $ browser_shooter --config ./my/config.yml --verbose

##### Check all the options

    $ browser_shooter --help


#### The output paths

The screenshots will be stored in:

    /<output_path>/<time_stamp>/<suite_name>/<test_name>/<browser_name>/shots

The logs will be stored in:

    /<output_path>/<time_stamp>/<suite_name>/<test_name>/<browser_name>/logs

## Status

Still in a _development_ state.. but is already **functional**.

## TODO

Support _Parallels_ screenshots with `$ prlctl capture`.
