module StripeWrapper
  class Charge
    attr_reader :response, :error_message
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description])
        new(response: response)
      rescue Stripe::CardError => e
        new(response: nil, error_message: e.message)
      end
    end

    def successful?
      response
    end

    def amount
      response.amount
    end
  end

  def self.set_api_key
    Stripe.api_key = Rails.env.production? ? ENV['STRIPE_LIVE_API_KEY'] : "sk_test_7Ct0DIec7KS2N5A6V8fS42OT"
  end
end