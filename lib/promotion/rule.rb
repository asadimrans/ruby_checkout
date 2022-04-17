module Promotion
  class Rule
    attr_reader :file, :data

    include Validator

    ALLOWED_FILE_TYPES = %w[.json]
    OPERATORS_GREATER_OR_EQUAL = 'gte'.freeze
    OPERATORS_BUY_ONE_GET_ONE_FREE = 'bogo'.freeze

    ALL_OPERATORS = [OPERATORS_GREATER_OR_EQUAL, OPERATORS_BUY_ONE_GET_ONE_FREE].freeze

    CONVERSION_AS_WHOLE = 'number'.freeze
    CONVERSION_AS_PERCENTAGE = 'percentage'.freeze

    def initialize(file)
      @file = file
      
      validates_presence file
      validates_content_type file, ALLOWED_FILE_TYPES

      @data = JSON.parse(File.read(file))
    end

    # Find all rules that are applicable to the identifiers in test data
    def applicable_rules_on_order(order_identifiers)
      order_identifiers.uniq.each_with_object([]) do |order_identifier, order_with_applicable_rule|
        rule = find_rule(order_identifier)

        total_items = order_identifiers.count{ |i| i == order_identifier}
        is_valid_bogo?(rule, total_items)
        next unless ALL_OPERATORS.include?(rule.dig('operator'))

        order_with_applicable_rule << { order_identifier: order_identifier, product_count: total_items,
                                      operator: rule['operator'], discount: rule['discount'],
                                      conversion: rule['conversion'] } if total_items >= rule['range']

      end
    end

    def is_valid_bogo?(rule, total_items)
      if rule.dig('operator') == OPERATORS_BUY_ONE_GET_ONE_FREE && (total_items % 2) !=0 && total_items >= rule['range']
        raise "We offer Buy one Get one free on #{rule.dig('applicable_products_identifier')}. Please adjust your order"
      end
    end

    def find_rule(order_identifier)
      data.dig('rules').find { |rule| rule.dig('applicable_products_identifier').include?(order_identifier) }
    end
  end
end
