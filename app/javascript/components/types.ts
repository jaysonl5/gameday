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
  
  