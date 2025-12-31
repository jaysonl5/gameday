module Api
  module V1
    class PatientCallsController < ApplicationController
      before_action :set_patient
      before_action :set_patient_call, only: [:show, :update, :destroy, :complete]

      # GET /api/v1/patients/:patient_id/calls
      def index
        @calls = @patient.patient_calls
        @calls = @calls.where(call_type: params[:call_type]) if params[:call_type].present?
        @calls = @calls.pending if params[:pending] == 'true'
        @calls = @calls.completed if params[:completed] == 'true'
        @calls = @calls.order(scheduled_date: :asc)

        render json: {
          calls: @calls.map { |c| call_json(c) }
        }
      end

      # GET /api/v1/patients/:patient_id/calls/:id
      def show
        render json: call_json(@call, include_details: true)
      end

      # POST /api/v1/patients/:patient_id/calls
      def create
        @call = @patient.patient_calls.new(call_params)

        if @call.save
          render json: call_json(@call, include_details: true), status: :created
        else
          render json: { errors: @call.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/patients/:patient_id/calls/:id
      def update
        if @call.update(call_params)
          render json: call_json(@call, include_details: true)
        else
          render json: { errors: @call.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/patients/:patient_id/calls/:id/complete
      def complete
        outcome = params[:outcome]
        notes = params[:notes]

        if @call.mark_completed!(outcome, notes)
          render json: call_json(@call, include_details: true)
        else
          render json: { errors: @call.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/patients/:patient_id/calls/:id
      def destroy
        @call.destroy
        head :no_content
      end

      private

      def set_patient
        @patient = Patient.find(params[:patient_id])
      end

      def set_patient_call
        @call = @patient.patient_calls.find(params[:id])
      end

      def call_params
        params.require(:patient_call).permit(
          :call_type,
          :scheduled_date,
          :callable_type,
          :callable_id,
          :outcome,
          :notes
        )
      end

      def call_json(call, include_details: false)
        base = {
          id: call.id,
          call_type: call.call_type,
          call_type_display: call.call_type_display,
          scheduled_date: call.scheduled_date,
          completed_at: call.completed_at,
          outcome: call.outcome,
          pending: call.pending?,
          overdue: call.overdue?,
          days_until_scheduled: call.days_until_scheduled
        }

        if include_details
          base.merge!(
            notes: call.notes,
            callable_type: call.callable_type,
            callable_id: call.callable_id,
            created_at: call.created_at,
            updated_at: call.updated_at
          )
        end

        base
      end
    end
  end
end
