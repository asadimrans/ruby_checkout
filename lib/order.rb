class Order
  attr_reader :file, :test_data

  include Validator

  ALLOWED_FILE_TYPES = %w[.txt]

  def initialize(file)
    @file = file
    
    validates_presence file
    validates_content_type file, ALLOWED_FILE_TYPES

    @test_data = File.read(file).split(',').map(&:strip)
  end

  # Filter out only those products that exists in the store
  def available_orders_in_store(product)
    test_data.select{ |d| product.product_exists?(d) }
  end

  # Filter out products on which there is no rule applicable
  def no_promotion_orders(products, rules)
    products - rules.map{|o| o[:order_identifier]}
  end
end
