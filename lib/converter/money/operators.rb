module Converter
  module Operators
    [:+, :-, :*, :/].each do |operator|
      define_method operator do |operand|
        format_result(amount.send(operator, parse_operand(operand)))
      end
    end

  private
    def parse_operand(operand)
      operand.is_a?(Money) ? operand.convert_to(currency).amount : operand
    end

    def format_result(result)
      "#{ result.is_a?(Integer) ? result : ("%.2f" % result.round(2)) } #{ currency }"
    end
  end
end
