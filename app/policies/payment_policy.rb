# frozen_string_literal: true

class PaymentPolicy < ApplicationPolicy
  def index?
    can_see_payments?
  end

  def sync?
    can_see_payments? && can_write?
  end

  def report?
    can_see_payments?
  end
end
