# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :require_admin, only: [:index, :update_role]

      def index
        users = User.where(approved: true).order(created_at: :desc)

        users_with_roles = users.map do |user|
          {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user_primary_role(user),
            approved: user.approved
          }
        end

        render json: users_with_roles
      end

      def update_role
        user = User.find(params[:id])
        new_role = params[:role]

        # Remove all existing roles
        user.roles.each { |role| user.remove_role(role.name.to_sym) }

        # Add new role
        user.add_role(new_role.to_sym) if new_role.present?

        render json: {
          id: user.id,
          email: user.email,
          role: new_role,
          message: 'Role updated successfully'
        }
      end

      private

      def require_admin
        unless current_user&.has_role?(:admin)
          render json: { error: 'Unauthorized - Admin access required' }, status: :forbidden
        end
      end

      def user_primary_role(user)
        return 'admin' if user.has_role?(:admin)
        return 'full' if user.has_role?(:full)
        return 'limited' if user.has_role?(:limited)
        return 'read_only' if user.has_role?(:read_only)
        'full' # default
      end
    end
  end
end
