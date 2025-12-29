import dayjs from "dayjs";
import useSWR from "swr";
import { PaginatedPaymentsResponse, PaymentsListParams } from "../../types";
import { swrFetcher } from "../../../utils/swr-fetcher";

type UsePaymentsListProps = {
  dateRange: [Date | null, Date | null];
  page?: number;
  perPage?: number;
  sortBy?: string;
  sortDirection?: 'asc' | 'desc';
  paymentType?: string;
};

export const usePaymentsList = ({ 
  dateRange, 
  page = 1, 
  perPage = 20,
  sortBy = 'created_at_api',
  sortDirection = 'desc',
  paymentType = 'all'
}: UsePaymentsListProps) => {
  const [start, end] = dateRange;

  const queryParams = new URLSearchParams();
  
  if (start) {
    queryParams.append("start_date", dayjs(start).format("YYYY-MM-DD"));
  }
  if (end) {
    queryParams.append("end_date", dayjs(end).format("YYYY-MM-DD"));
  }
  
  queryParams.append("page", page.toString());
  queryParams.append("per_page", perPage.toString());
  queryParams.append("sort_by", sortBy);
  queryParams.append("sort_direction", sortDirection);
  
  if (paymentType !== 'all') {
    queryParams.append("payment_type", paymentType);
  }

  const apiUrl = `/api/v1/payments?${queryParams.toString()}`;
  const shouldFetch = dateRange[0] && dateRange[1];

  const { data, error, isLoading, mutate } = useSWR<PaginatedPaymentsResponse>(
    shouldFetch ? apiUrl : null,
    swrFetcher
  );

  return { data, error, isLoading, mutate };
};