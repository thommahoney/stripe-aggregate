require 'rspec'
require './aggregate.rb'

RSpec.describe Aggregate do
  let(:aggregate) { Aggregate.new }

  describe "average" do
    it "returns the average customer spend" do
      expect(aggregate.average).to be > 0
    end

    it "accepts a limit" do
      expect(Stripe::Charge).to receive(:all).twice.and_call_original

      aggregate.average(limit: 2)
    end

    it "accepts created_after" do
      date = Time.parse("1 Jan 2014")
      expect(aggregate.average(created_after: date)).to be > 0

      expect {
        aggreate.charges(created_after: date).all? do |charge|
          charge.created >= date.to_i
        end
      }.to be_true
    end
  end
end
