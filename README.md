# Ruby App

Simple OO based ruby script!!!

# Files

**generator** responsible to receive rules, products dataset and test dataset files and initiate the checkout process.

**lib/check_out** responsible to handle all processing of the Checkout and Promotions.

**lib/order** responsible to validate the test dataset file and handle different operations on the test sample.

**lib/product** responsible to validate the product dataset file and handle different operations on the products dataset.

**lib/promotion/rule** responsible to validate the rules file and handle different operations on the rules set.

**Gemfile** contains ***rspec*** for testing specs.

# Usage

    chmod +x generator.rb
    ./generator.rb rules.json products.json test.txt

To test specs, run the following:

    gem install bundler -v '2.1.4'
    bundle install
    bundle exec rspec
