require 'roda'

module Web
  class App < Roda
    plugin :all_verbs

    route do |r|
      r.root do
        r.get do
          'hello'
        end
      end

      r.on 'api' do
        r.on 'v1' do
          r.on 'ip' do
            r.is do
              r.post do
                Container['web.actions.ip.create'].call(r)
              end

              r.delete do
              end
            end

            r.on String do |address|
              r.get 'analytics' do
                "hello world #{address}"
              end
            end
          end
        end
      end

      r.on 'sidekiq' do
        r.run Sidekiq::Web
      end
    end
  end
end
