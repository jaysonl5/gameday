module Api
  module V1
    class DashboardController < ApplicationController
      # GET /api/v1/dashboard
      def index
        service = DashboardStatsService.new
        render json: service.stats
      end

      # GET /api/v1/dashboard/patient/:patient_id
      def patient
        service = DashboardStatsService.new(patient_id: params[:patient_id])
        render json: service.stats
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Patient not found' }, status: :not_found
      end

      # GET /api/v1/dashboard/alerts
      def alerts
        render json: {
          overdue_medications: overdue_medications_list,
          overdue_labs: overdue_labs_list,
          overdue_calls: overdue_calls_list,
          due_today_calls: due_today_calls_list
        }
      end

      private

      def overdue_medications_list
        PatientMedication.overdue
          .includes(:patient, :medication)
          .limit(20)
          .map do |pm|
            {
              id: pm.id,
              patient_id: pm.patient_id,
              patient_name: pm.patient.display_name,
              medication_name: pm.medication.name,
              next_order_due: pm.next_order_due,
              days_overdue: (Date.current - pm.next_order_due).to_i
            }
          end
      end

      def overdue_labs_list
        PatientLab.overdue
          .includes(:patient)
          .limit(20)
          .map do |lab|
            {
              id: lab.id,
              patient_id: lab.patient_id,
              patient_name: lab.patient.display_name,
              lab_type: lab.lab_type,
              next_lab_due: lab.next_lab_due,
              days_overdue: (Date.current - lab.next_lab_due).to_i
            }
          end
      end

      def overdue_calls_list
        PatientCall.overdue
          .includes(:patient)
          .limit(20)
          .map do |call|
            {
              id: call.id,
              patient_id: call.patient_id,
              patient_name: call.patient.display_name,
              call_type: call.call_type_display,
              scheduled_date: call.scheduled_date,
              days_overdue: (Date.current - call.scheduled_date).to_i
            }
          end
      end

      def due_today_calls_list
        PatientCall.due_today
          .includes(:patient)
          .limit(20)
          .map do |call|
            {
              id: call.id,
              patient_id: call.patient_id,
              patient_name: call.patient.display_name,
              call_type: call.call_type_display,
              scheduled_date: call.scheduled_date
            }
          end
      end
    end
  end
end
