module BrowserShooter
  module Utils
    def self.timestamp
      Time.now.strftime( "%Y%m%d%H%M%S" )
    end

    def self.find_by_name( array, name )
      element = array.select{ |e| e.name == name }.first
      raise ArgumentError, "Not element found '#{name}'" if element.nil?

      element
    end

    def self.find_by_names( array, names )
      names.map { |name| find_by_name( array, name ) }
    end
  end
end