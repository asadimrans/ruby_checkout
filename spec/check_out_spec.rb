require 'pry'
require_relative '../lib/validator'
require_relative '../lib/check_out'
require_relative '../lib/promotion/rule'
require_relative '../lib/order'
require_relative '../lib/product'

require 'json'

describe CheckOut do
  let(:rule) { Promotion::Rule.new('./spec/fixtures/rules.json') }
  let(:product) { Product.new('./spec/fixtures/products.json') }

  context 'when rules file is not passed or it does not exist.' do
    let(:message) { 'Please, provide a valid path of the file!!!' }

    it 'throws an error' do
      expect { described_class.new('non-existent-file.json').process }.to raise_error(RuntimeError, message)
    end
  end

  context 'when product file is not passed or it does not exist.' do
    let(:message) { 'Please, provide a valid path of the file!!!' }

    it 'throws an error' do
      expect { described_class.new('./spec/fixtures/rules.json', 'non-existent-file.json').process }.to raise_error(RuntimeError, message)
    end
  end

  context 'when test file is not passed or it does not exist.' do
    let(:message) { 'Please, provide a valid path of the file!!!' }

    it 'throws an error' do
      expect { described_class.new('./spec/fixtures/rules.json', './spec/fixtures/products.json', 'non-existent-file.json').process }.to raise_error(RuntimeError, message)
    end
  end

  context 'when order is applicable for buy one get one promotion' do
    let (:order) { Order.new('./spec/fixtures/test_bogo.txt') }
    let (:data) { order.available_orders_in_store(product) }

    it 'matches rules for bogo operator' do
      expect(rule.applicable_rules_on_order(data).map{|s| s[:operator]}).to include 'bogo' 
    end
  end

  context 'when order is applicable for whole amount discount' do
    let (:order) { Order.new('./spec/fixtures/test_gte2.txt') }
    let (:data) { order.available_orders_in_store(product) }

    it 'matches rules for gte operator' do
      expect(rule.applicable_rules_on_order(data).map{|s| s[:operator]}).to include 'gte' 
    end

    it 'matches rules for number conversion' do
      expect(rule.applicable_rules_on_order(data).map{|s| s[:conversion]}).to include 'number' 
    end
  end

  context 'when order is applicable for percentage discount' do
    let (:order) { Order.new('./spec/fixtures/test_gte.txt') }
    let (:data) { order.available_orders_in_store(product) }

    it 'matches rules for gte operator' do
      expect(rule.applicable_rules_on_order(data).map{|s| s[:operator]}).to include 'gte' 
    end

    it 'matches rules for percentage conversion' do
      expect(rule.applicable_rules_on_order(data).map{|s| s[:conversion]}).to include 'percentage' 
    end
  end

  context 'when order is made for payment' do
    # result for test data for comparison GR1,CF1,SR1,CF1,CF1 30.35
    let(:result) { "30.35€\n" }

    it 'matches rules for gte operator' do
      expect { described_class.new('./spec/fixtures/rules.json', './spec/fixtures/products.json', './spec/fixtures/sample_test.txt').process }.to output(result).to_stdout 
    end
  end
end
