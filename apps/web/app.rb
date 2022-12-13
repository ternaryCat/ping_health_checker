require 'roda'

class App < Roda
  route do |r|
    r.root do
      r.get do
        'hello'
      end
    end
  end
end
