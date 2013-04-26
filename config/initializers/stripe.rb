Stripe.api_key = Rails.env.production? ? ENV['STRIPE_LIVE_API_KEY'] : "sk_test_7Ct0DIec7KS2N5A6V8fS42OT"

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
    user = User.where(stripe_id: event.data.object.customer).first
    user.payments.create(amount: event.data.object.amount, transaction_id:event.data.object.id)
  end

  subscribe 'charge.failed' do |event|
    user = User.where(stripe_id: event.data.object.customer).first
    user.active = false
    user.save
  end
end