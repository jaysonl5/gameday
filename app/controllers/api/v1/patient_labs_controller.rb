module Api
  module V1
    class PatientLabsController < ApplicationController
      before_action :set_patient
      before_action :set_patient_lab, only: [:show, :update, :destroy]

      # GET /api/v1/patients/:patient_id/labs
      def index
        @labs = @patient.patient_labs
        @labs = @labs.where(status: params[:status]) if params[:status].present?
        @labs = @labs.order(next_lab_due: :asc)

        render json: {
          labs: @labs.map { |l| lab_json(l) }
        }
      end

      # GET /api/v1/patients/:patient_id/labs/:id
      def show
        render json: lab_json(@lab, include_details: true)
      end

      # POST /api/v1/patients/:patient_id/labs
      def create
        @lab = @patient.patient_labs.new(lab_params)

        if @lab.save
          render json: lab_json(@lab, include_details: true), status: :created
        else
          render json: { errors: @lab.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/patients/:patient_id/labs/:id
      def update
        if @lab.update(lab_params)
          render json: lab_json(@lab, include_details: true)
        else
          render json: { errors: @lab.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/patients/:patient_id/labs/:id
      def destroy
        @lab.destroy
        head :no_content
      end

      private

      def set_patient
        @patient = Patient.find(params[:patient_id])
      end

      def set_patient_lab
        @lab = @patient.patient_labs.find(params[:id])
      end

      def lab_params
        params.require(:patient_lab).permit(
          :patient_medication_id,
          :lab_type,
          :last_lab_date,
          :frequency_value,
          :frequency_unit,
          :notes
        )
      end

      def lab_json(lab, include_details: false)
        base = {
          id: lab.id,
          lab_type: lab.lab_type,
          last_lab_date: lab.last_lab_date,
          next_lab_due: lab.next_lab_due,
          frequency: lab.frequency_description,
          status: lab.status,
          days_until_due: lab.days_until_due
        }

        if include_details
          base.merge!(
            notes: lab.notes,
            patient_medication_id: lab.patient_medication_id,
            frequency_value: lab.frequency_value,
            frequency_unit: lab.frequency_unit,
            created_at: lab.created_at,
            updated_at: lab.updated_at
          )
        end

        base
      end
    end
  end
end
