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
  
  