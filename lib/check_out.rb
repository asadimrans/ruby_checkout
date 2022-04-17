class CheckOut
  attr_reader :rule, :product

  def initialize(rule_file_path = nil, product_file_path = nil, order_file_path = nil)
    @rule_file_path    = rule_file_path
    @product_file_path = product_file_path
    @order_file_path   = order_file_path
  end

  def process
    @rule = Promotion::Rule.new(@rule_file_path)
    @product = Product.new(@product_file_path)
    @order = Order.new(@order_file_path)

    available_products_identifiers = @order.available_orders_in_store(@product)

    rules = @rule.applicable_rules_on_order(available_products_identifiers)

    no_promotion_products = @order.no_promotion_orders(available_products_identifiers, rules)

    no_promotion_products_amount = @product.get_total(no_promotion_products)

    display_result(rules, @product, no_promotion_products_amount, available_products_identifiers)
  end

  private

  def display_result(rules, product, no_promotion_products_amount, available_products_identifiers, total_amount=0)
    rules.each do |data|
      single_product = product.find_product(data[:order_identifier])
      product_price = product.get_price(single_product)
      unit = single_product.dig('unit')


      total_amount += if data[:conversion] == Promotion::Rule::CONVERSION_AS_WHOLE
                        (product_price - data[:discount].to_f) * data[:product_count].to_i
                      elsif data[:conversion] == Promotion::Rule::CONVERSION_AS_PERCENTAGE
                        (product_price - percentage(product_price, data[:discount]))  * data[:product_count].to_i
                      else
                        return puts "Promotion doesn't exist"
                      end

    end
    puts "#{(total_amount + no_promotion_products_amount).round(2)}€"
  end

  def percentage(total, of)
    (of.to_f / 100) * total
  end
end
