export type PaymentReport = {
    total_revenue: number;
    payment_breakdown: {
      by_type: {
        [key: string]: number;
      };
      by_month: {
        [key: string]: number;
      };
      total_count: number;
    };
    date_range: {
      start_date: string;
      end_date: string;
    };
  };

  export type PaymentReportResponse = {
    total_revenue: string;
    payment_breakdown: {
      by_day: {
        [key: string]: {
          [key: string]: number;
        };
      }
      by_source: {
        [key: string]: string;
      }
      by_type: {
        [key: string]: string;
      };
      by_month: {
        [key: string]: string;
      };
      total_count: number;
    };
    date_range: {
      start_date: string;
      end_date: string;
    };
  };
  export type PaymentReportRequest = {
    start_date: string;
    end_date: string;
  };

  export type Payment = {
    id: number;
    api_id: string;
    amount: number;
    status: string;
    payment_type: string;
    source: string;
    recurring: boolean;
    tender_type: string;
    created_at_api: string;
    updated_at: string;
    created_at: string;
  };

  export type PaginationMetadata = {
    current_page: number;
    per_page: number;
    total_pages: number;
    total_count: number;
  };

  export type PaginatedPaymentsResponse = {
    data: Payment[];
    pagination: PaginationMetadata;
  };

  export type PaymentsListParams = {
    page?: number;
    per_page?: number;
    start_date?: string;
    end_date?: string;
    payment_type?: string;
    sort_by?: string;
    sort_direction?: 'asc' | 'desc';
  };

  export type SortField = 'created_at_api' | 'amount' | 'tender_type' | 'payment_type' | 'source';

export type PatientCensusEntry = {
  id: number;
  date: string;
  patient_name: string;
  patient_result: 'Win' | 'Thinker' | 'Loss';
  
  // WIN fields
  mail_out_in_clinic?: 'In Clinic' | 'Mail out';
  in_clinic_dose_ml?: number;
  med_order_made?: 'Yes' | 'No' | 'NA';
  lab_call_scheduled?: 'Yes' | 'No' | 'NA';
  monthly_contract_made?: 'Yes' | 'No' | 'OTHER-check Chrono' | 'Contract made on PP';
  annual_lab_contract?: 'Yes' | 'No' | 'OTHER-check Chrono';
  consents_signed?: 'Yes' | 'No';
  in_clinic_appt_made?: 'Yes' | 'No' | 'OTHER-check Chrono';
  mail_out_appt_made?: 'Yes' | 'No' | 'NA';
  notes?: string;
  lead_source?: 'Paradigm' | 'Google' | 'Referral' | 'GD Web' | 'FB/Insta' | 'Other See Notes' | 'Clinic Transfer' | 'Ground Marketing' | 'No Answer' | 'Staff Referrals' | 'TiffOKC' | 'BigTre';
  plan_notes?: string;
  rate?: number;
  extra_info?: string;
  
  // THINKER/LOSS fields
  p_or_other?: string;
  phone_number?: string;
  
  // LOSS fields
  why_a_loss?: string;
  
  // Shared fields
  plan?: string[];
  
  created_at: string;
  updated_at: string;
};

export type PatientCensusFormData = {
  date: string;
  patient_name: string;
  patient_result: 'Win' | 'Thinker' | 'Loss';
  
  // WIN fields
  mail_out_in_clinic?: 'In Clinic' | 'Mail Out';
  in_clinic_dose_ml?: number;
  med_order_made?: 'Yes' | 'No' | 'NA';
  lab_call_scheduled?: 'Yes' | 'No' | 'NA';
  monthly_contract_made?: 'NA' | 'Yes' | 'No' | 'OTHER-check Chrono' | 'Contract made on PP';
  annual_lab_contract?: 'Yes' | 'No' | 'OTHER-check Chrono';
  consents_signed?: 'NA' | 'Yes' | 'No' | 'OTHER-check Chrono' | 'Sent Consent';
  in_clinic_appt_made?: 'NA' | 'Yes' | 'No' | 'OTHER-check Chrono';
  mail_out_appt_made?: 'Yes' | 'No' | 'NA';
  notes?: string;
  lead_source?: 'Paradigm' | 'Google' | 'Referral' | 'GD Web' | 'FB/Insta' | 'Other See Notes' | 'Clinic Transfer' | 'Ground Marketing' | 'No Answer' | 'Staff Referrals' | 'TiffOKC' | 'BigTre';
  plan_notes?: string;
  rate?: number;
  extra_info?: string;
  
  // THINKER/LOSS fields
  p_or_other?: string;
  phone_number?: string;
  
  // LOSS fields
  why_a_loss?: string;
  
  // Shared fields
  plan?: string[];
};