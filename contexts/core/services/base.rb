module Core
  module Services
    class Base
      include Dry::Monads[:result, :try, :do]

      def call(*)
        raise NotImplementedError
      end
    end
  end
end
