# frozen_string_literal: true

class PatientCensusEntryPolicy < ApplicationPolicy
  def index?
    true
  end

  def stats?
    true
  end

  def create?
    can_write?
  end

  def update?
    can_write?
  end

  def destroy?
    can_write?
  end

  def mark_called?
    can_write?
  end
end
