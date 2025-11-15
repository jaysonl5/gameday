class Api::V1::PatientCensusEntriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_patient_census_entry, only: [:show, :update, :destroy]

  def index
    @entries = PatientCensusEntry.all.order(date: :desc)
    
    if params[:patient_result].present?
      @entries = @entries.where(patient_result: params[:patient_result])
    end
    
    render json: @entries
  end

  def show
    render json: @entry
  end

  def create
    @entry = PatientCensusEntry.new(patient_census_entry_params)
    
    if @entry.save
      # Sync to Google Sheets asynchronously
      sync_to_google_sheets(@entry)
      render json: @entry, status: :created
    else
      render json: { errors: @entry.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(patient_census_entry_params)
      render json: @entry
    else
      render json: { errors: @entry.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    head :no_content
  end

  private

  def set_patient_census_entry
    @entry = PatientCensusEntry.find(params[:id])
  end

  def sync_to_google_sheets(entry)
    begin
      GoogleSheetsService.new.sync_patient_census_entry(entry)
    rescue StandardError => e
      Rails.logger.error "Failed to sync patient census entry #{entry.id} to Google Sheets: #{e.message}"
      # Continue without raising - the entry was still saved to the database
    end
  end

  def patient_census_entry_params
    params.require(:patient_census_entry).permit(
      :date, :patient_name, :patient_result, :mail_out_in_clinic, :in_clinic_dose_ml,
      :med_order_made, :lab_call_scheduled, :monthly_contract_made, :annual_lab_contract,
      :consents_signed, :in_clinic_appt_made, :mail_out_appt_made, :notes, :lead_source,
      :plan_notes, :rate, :extra_info, :p_or_other, :phone_number, :why_a_loss,
      plan: []
    )
  end
end