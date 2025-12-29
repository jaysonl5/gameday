# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_admin

    def index
      @pending_users = User.where(approved: false).order(created_at: :desc)
      @approved_users = User.where(approved: true).order(created_at: :desc)

      render json: {
        pending: @pending_users.as_json(only: [:id, :email, :name, :provider, :created_at]),
        approved: @approved_users.as_json(only: [:id, :email, :name, :provider, :created_at])
      }
    end

    def approve
      @user = User.find(params[:id])
      if @user.update(approved: true)
        # TODO: Send approval email to user
        render json: { message: 'User approved successfully', user: @user }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def reject
      @user = User.find(params[:id])
      @user.destroy
      render json: { message: 'User rejected and removed' }, status: :ok
    end

    private

    def require_admin
      unless current_user&.has_role?(:admin)
        render json: { error: 'Unauthorized - Admin access required' }, status: :forbidden
      end
    end
  end
end
