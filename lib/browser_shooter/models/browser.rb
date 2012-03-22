module BrowserShooter
  module Models
    class Browser < Struct.new( :name, :url, :type, :vm )
    end
  end
end