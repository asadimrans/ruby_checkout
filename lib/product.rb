class Product
  attr_reader :file, :data, :amount

  include Validator

  ALLOWED_FILE_TYPES = %w[.json]

  def initialize(file)
    @file = file
    
    validates_presence file
    validates_content_type file, ALLOWED_FILE_TYPES

    @data = JSON.parse(File.read(file))
  end

  def product_exists?(identifier)
    find_product(identifier)&.any?
  end

  def find_product(identifier)
    data.dig('products').find { |product| product.dig('identifier') == identifier }
  end

  def get_price(product)
    product.dig('price').to_f
  end

  # Get total amount of products
  def get_total(identifiers)
    identifiers.sum { |i| find_product(i).dig('price').to_f }
  end
end
