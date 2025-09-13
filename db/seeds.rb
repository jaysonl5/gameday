# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
Payment.destroy_all

# Create sample payments for testing revenue report
puts "Creating sample payments..."

# Helper method to create payments with unique api_id
def create_payment(overrides = {})
  defaults = {
    created_at_api: Time.current,
    creator_name: "Test User",
    is_duplicate: false,
    merchant_id: 12345,
    tender_type: ["Card", "Card", "Card", "Cash", "Cash", "Check", "ACH"].sample,
    currency: "USD",
    card_type: "Visa",
    card_last4: "1234",
    customer_id: rand(1000..9999),
    auth_only: false,
    auth_code: "ABC123",
    status: "Settled",
    settled_currency: "USD",
    auth_message: "Approved",
    available_auth_amount: 0.0,
    reference: "REF#{rand(1000..9999)}",
    tax: 0.0,
    surcharge_amount: 0.0,
    surcharge_rate: 0.0,
    surcharge_label: "",
    client_reference: "CLIENT#{rand(1000..9999)}",
    payment_type: "Sale",
    review_indicator: 0,
    should_get_credit_card_level: false,
    response_code: 0,
    issuer_response_code: "00"
  }
  
  # Generate truly unique api_id (integer)
  api_id = overrides[:api_id] || rand(100000000..999999999)
  while Payment.exists?(api_id: api_id)
    api_id = rand(100000000..999999999)
  end
  
  Payment.create!(defaults.merge(overrides).merge(api_id: api_id))
end

# Create recurring payments (30 payments over last 3 months)
30.times do |i|
  create_payment(
    amount: [50.0, 75.0, 100.0, 125.0, 150.0].sample,
    settled_amount: [50.0, 75.0, 100.0, 125.0, 150.0].sample,
    created_at_api: rand(3.months.ago..Time.current),
    source: "Recurring",
    recurring: true,
    invoice: "INV-REC-#{i + 1}",
    payment_type: "Sale"
  )
end

# Create single payments (50 payments over last 3 months)
50.times do |i|
  create_payment(
    amount: [25.0, 50.0, 75.0, 100.0, 150.0, 200.0, 300.0].sample,
    settled_amount: [25.0, 50.0, 75.0, 100.0, 150.0, 200.0, 300.0].sample,
    created_at_api: rand(3.months.ago..Time.current),
    source: "Invoice",
    recurring: false,
    invoice: "INV-SNG-#{i + 1}",
    payment_type: "Sale"
  )
end

# Create some return payments (10 returns)
10.times do |i|
  create_payment(
    amount: [25.0, 50.0, 75.0, 100.0].sample,
    settled_amount: [25.0, 50.0, 75.0, 100.0].sample,
    created_at_api: rand(2.months.ago..Time.current),
    source: ["Invoice", "Recurring"].sample,
    recurring: [true, false].sample,
    invoice: "INV-RET-#{i + 1}",
    payment_type: "Return"
  )
end

# Create some declined payments (should not appear in revenue report)
5.times do |i|
  create_payment(
    amount: [50.0, 100.0, 150.0].sample,
    settled_amount: 0.0,
    created_at_api: rand(1.month.ago..Time.current),
    source: "Invoice",
    recurring: false,
    invoice: "INV-DEC-#{i + 1}",
    payment_type: "Sale",
    status: "Declined"
  )
end

# Create some recent payments for current month testing
10.times do |i|
  create_payment(
    amount: [75.0, 100.0, 125.0, 150.0, 200.0].sample,
    settled_amount: [75.0, 100.0, 125.0, 150.0, 200.0].sample,
    created_at_api: rand(1.week.ago..Time.current),
    source: ["Invoice", "Recurring"].sample,
    recurring: [true, false].sample,
    invoice: "INV-CUR-#{i + 1}",
    payment_type: "Sale"
  )
end

puts "✅ Created #{Payment.count} sample payments:"
puts "   - #{Payment.where(recurring: true).count} recurring payments"
puts "   - #{Payment.where(recurring: false).count} single payments"
puts "   - #{Payment.where(payment_type: 'Sale').count} sales"
puts "   - #{Payment.where(payment_type: 'Return').count} returns"
puts "   - #{Payment.where(status: 'Settled').count} settled payments"
puts "   - #{Payment.where(status: 'Declined').count} declined payments"

puts "\nRevenue summary:"
puts "   - Total settled sales: $#{Payment.where(status: 'Settled', payment_type: 'Sale').sum(:amount)}"
puts "   - Total returns: $#{Payment.where(status: 'Settled', payment_type: 'Return').sum(:amount)}"
puts "   - Net revenue: $#{Payment.where(status: 'Settled', payment_type: 'Sale').sum(:amount) - Payment.where(status: 'Settled', payment_type: 'Return').sum(:amount)}"
