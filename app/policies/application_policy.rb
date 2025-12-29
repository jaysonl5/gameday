# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    can_write?
  end

  def new?
    create?
  end

  def update?
    can_write?
  end

  def edit?
    update?
  end

  def destroy?
    can_write?
  end

  private

  def admin?
    user&.has_role?(:admin)
  end

  def full_access?
    admin? || user&.has_role?(:full)
  end

  def can_write?
    return false if user&.has_role?(:read_only)
    true
  end

  def can_see_payments?
    return false if user&.has_role?(:limited)
    true
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
