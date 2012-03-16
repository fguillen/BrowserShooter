class BrowserShooter
  module Models
    class Browser < Struct.new( :name, :url, :type )
    end
  end
end