require 'rspec'
require 'stripe'

class Aggregate
  def initialize
    Stripe.api_key = "sk_test_WyerhLf8XJtJKKtFxbnHCGWf"
  end

  def average(options = {})
    charges = self.charges(options)
    total = charges.inject(0) do |r, charge|
      r += charge.amount
    end

    (1.0 * total) / charges.count
  end

  def charges(options = {})
    limit         = options.fetch(:limit, 5)
    created_after = options[:created_after]

    response = Stripe::Charge.all
    all_charges = response.data
    starting_after = (last = all_charges.last) && last["id"]

    count = 1
    while count < limit && (response && response.has_more)
      params = { starting_after: starting_after }
      params.merge(created: { gte: created_after.to_i }) if created_after

      response = Stripe::Charge.all(params)
      all_charges = all_charges + response.data

      starting_after = response.data.last && response.data.last["id"]
      count += 1
    end

    all_charges
  end
end
