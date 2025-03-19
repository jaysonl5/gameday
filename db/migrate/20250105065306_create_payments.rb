# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|

      t.datetime :created_at_api              # Timestamp from the API
      t.bigint :api_id, null: false, index: true # Unique identifier from the API
      t.string :creator_name                  # Name of the person who created the payment
      t.boolean :is_duplicate                 # Flag for duplicate payment
      t.bigint :merchant_id                   # Merchant identifier
      t.string :tender_type                   # Type of payment tender
      t.string :currency                      # Currency of the payment
      t.decimal :amount, precision: 15, scale: 2 # Payment amount

      # Card Account Details
      t.string :card_type                     # Type of card (e.g., Visa, MasterCard)
      t.string :card_last4                    # Last 4 digits of the card

      # Customer Data
      t.integer :customer_id                  # Customer Id


      # Payment Status
      t.boolean :auth_only                    # Indicates if it is an auth-only transaction
      t.string :auth_code                     # Authorization code
      t.string :status                        # Payment status

      # Risk Assessment
      t.boolean :avs_account_name_match_performed # AVS name match flag

      # Settled Details
      t.decimal :settled_amount, precision: 15, scale: 2 # Settled amount
      t.string :settled_currency              # Currency used for settlement

      # Additional Details
      t.string :auth_message                  # Authorization message
      t.decimal :available_auth_amount, precision: 15, scale: 2 # Available authorization amount
      t.string :reference                     # Reference identifier
      t.decimal :tax, precision: 15, scale: 2 # Tax amount
      t.decimal :surcharge_amount, precision: 15, scale: 2 # Surcharge amount
      t.decimal :surcharge_rate, precision: 5, scale: 2 # Surcharge rate
      t.string :surcharge_label               # Surcharge label
      t.string :invoice                       # Invoice number
      t.string :client_reference              # Client reference
      t.string :payment_type                  # Payment type
      t.integer :review_indicator             # Review indicator
      t.string :source                        # Payment source
      t.boolean :should_get_credit_card_level # Flag for getting credit card level
      t.integer :response_code                # Response code
      t.string :issuer_response_code          # Issuer's response code

      t.timestamps
    end
  end
end
