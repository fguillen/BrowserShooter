module BrowserShooter
  class ARGVParsers
    include Mixlib::CLI

    option(
      :config_file,
      :short        => "-c CONFIG",
      :long         => "--config CONFIG",
      :required     => true,
      :description  => "The configuration file to use"
    )

    option(
      :suite,
      :short        => "-s SUITE",
      :long         => "--suite SUITE",
      :description  => "The name of the suite to execute",
    )

    option(
      :test,
      :short        => "-t TEST",
      :long         => "--test TEST",
      :description  => "The name of the test to execute",
    )

    option(
      :browsers,
      :short        => "-b BROWSERS",
      :long         => "--browsers BROWSERS",
      :description  => "The name of the browsers to execute, separated by comas",
      :proc         => Proc.new { |browsers| browsers.split(",") }
    )

    option(
      :verbose,
      :short        => "-v",
      :long         => "--verbose",
      :description  => "More verbose output",
      :boolean      => true
    )

    option(
      :help,
      :short        => "-h",
      :long         => "--help",
      :description  => "Show this message",
      :on           => :tail,
      :boolean      => true,
      :show_options => true,
      :exit         => 0
    )
  end
end