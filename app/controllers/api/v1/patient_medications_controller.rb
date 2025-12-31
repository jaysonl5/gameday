module Api
  module V1
    class PatientMedicationsController < ApplicationController
      before_action :set_patient
      before_action :set_patient_medication, only: [:show, :update, :destroy]

      # GET /api/v1/patients/:patient_id/medications
      def index
        @medications = @patient.patient_medications.includes(:medication, :discount)
        @medications = @medications.where(status: params[:status]) if params[:status].present?
        @medications = @medications.order(next_order_due: :asc)

        render json: {
          medications: @medications.map { |m| medication_json(m) }
        }
      end

      # GET /api/v1/patients/:patient_id/medications/:id
      def show
        render json: medication_json(@medication, include_details: true)
      end

      # POST /api/v1/patients/:patient_id/medications
      def create
        @medication = @patient.patient_medications.new(medication_params)

        if @medication.save
          render json: medication_json(@medication, include_details: true), status: :created
        else
          render json: { errors: @medication.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/patients/:patient_id/medications/:id
      def update
        if @medication.update(medication_params)
          render json: medication_json(@medication, include_details: true)
        else
          render json: { errors: @medication.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/patients/:patient_id/medications/:id
      def destroy
        @medication.destroy
        head :no_content
      end

      private

      def set_patient
        @patient = Patient.find(params[:patient_id])
      end

      def set_patient_medication
        @medication = @patient.patient_medications.find(params[:id])
      end

      def medication_params
        params.require(:patient_medication).permit(
          :medication_id,
          :discount_id,
          :prepped,
          :dose_per_week,
          :vial_size,
          :rate,
          :dispensing_method,
          :in_clinic_dose,
          :last_order_date,
          :order_buffer_days,
          :declined,
          :notes
        )
      end

      def medication_json(med, include_details: false)
        base = {
          id: med.id,
          medication_id: med.medication_id,
          medication_name: med.medication.name,
          dose_per_week: med.dose_per_week,
          vial_size: med.vial_size,
          days_supply: med.days_supply,
          next_order_due: med.next_order_due,
          order_by_date: med.order_by_date,
          status: med.status,
          dispensing_method: med.dispensing_method,
          prepped: med.prepped,
          declined: med.declined
        }

        if include_details
          base.merge!(
            notes: med.notes,
            last_order_date: med.last_order_date,
            order_buffer_days: med.order_buffer_days,
            rate: med.rate,
            in_clinic_dose: med.in_clinic_dose,
            discount_id: med.discount_id,
            discount_name: med.discount&.name,
            final_rate: med.final_rate_cents,
            created_at: med.created_at,
            updated_at: med.updated_at
          )
        end

        base
      end
    end
  end
end
