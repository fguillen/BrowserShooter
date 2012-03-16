class BrowserShooter
  module Models
    class Suite < Struct.new( :name, :tests, :browsers )
    end
  end
end