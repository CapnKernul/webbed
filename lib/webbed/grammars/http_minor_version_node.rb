module Webbed
  module Grammars
    module HTTPMinorVersionNode
      def value
        text_value.to_i
      end
    end
  end
end