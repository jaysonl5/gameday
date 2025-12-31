module Api
  module V1
    class PatientsController < ApplicationController
      before_action :set_patient, only: [:show, :update, :destroy]

      # GET /api/v1/patients
      def index
        @patients = Patient.all
        @patients = @patients.by_status(params[:status]) if params[:status].present?
        @patients = @patients.order(created_at: :desc)
        @patients = @patients.page(params[:page]).per(params[:per_page] || 25)

        render json: {
          patients: @patients.map { |p| patient_json(p) },
          meta: pagination_meta(@patients)
        }
      end

      # GET /api/v1/patients/:id
      def show
        render json: patient_json(@patient, include_details: true)
      end

      # POST /api/v1/patients
      def create
        @patient = Patient.new(patient_params)

        if @patient.save
          render json: patient_json(@patient, include_details: true), status: :created
        else
          render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/patients/:id
      def update
        if @patient.update(patient_params)
          render json: patient_json(@patient, include_details: true)
        else
          render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/patients/:id
      def destroy
        @patient.destroy
        head :no_content
      end

      # GET /api/v1/patients/search
      def search
        query = params[:q]

        if query.blank?
          return render json: { patients: [] }
        end

        # Search by name or email using blind indexes
        @patients = Patient.where(name: query)
                          .or(Patient.where(email: query))
                          .limit(20)

        render json: {
          patients: @patients.map { |p| patient_json(p) }
        }
      end

      private

      def set_patient
        @patient = Patient.find(params[:id])
      end

      def patient_params
        params.require(:patient).permit(
          :name,
          :email,
          :phone,
          :notes,
          :status,
          :ghl_contact_id
        )
      end

      def patient_json(patient, include_details: false)
        base = {
          id: patient.id,
          name: patient.name,
          email: patient.email,
          phone: patient.phone,
          status: patient.status,
          status_changed_at: patient.status_changed_at,
          ghl_contact_id: patient.ghl_contact_id,
          created_at: patient.created_at,
          updated_at: patient.updated_at
        }

        if include_details
          base.merge!(
            notes: patient.notes,
            profile: patient.patient_profile ? profile_json(patient.patient_profile) : nil,
            medications_count: patient.patient_medications.active.count,
            labs_count: patient.patient_labs.count,
            pending_calls_count: patient.pending_calls.count
          )
        end

        base
      end

      def profile_json(profile)
        {
          id: profile.id,
          lead_source: profile.lead_source,
          patient_result: profile.patient_result,
          consult_date: profile.consult_date,
          rate: profile.rate,
          monthly_contract_made: profile.monthly_contract_made,
          annual_contract_made: profile.annual_contract_made
        }
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count,
          per_page: collection.limit_value
        }
      end
    end
  end
end
