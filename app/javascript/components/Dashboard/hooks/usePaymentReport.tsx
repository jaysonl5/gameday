import dayjs from "dayjs";
import useSWR from "swr";
import { PaymentReportResponse } from "../../types";
import { swrFetcher } from "../../../utils/swr-fetcher";

type usePaymentReportProps = {
  dateRange: [Date | null, Date | null];
};

export const usePaymentReport = ({ dateRange }: usePaymentReportProps) => {
  const [start, end] = dateRange;

  const queryParams = new URLSearchParams();
  if (start) {
    queryParams.append("start_date", dayjs(start).format("YYYY-MM-DD"));
  }
  if (end) {
    queryParams.append("end_date", dayjs(end).format("YYYY-MM-DD"));
  }

  const apiUrl = `/api/v1/payments/report?${queryParams.toString()}`;
  const shouldFetch = dateRange[0] && dateRange[1];

  const { data, error, isLoading } = useSWR<PaymentReportResponse>(
    shouldFetch ? apiUrl : null,
    swrFetcher
  );

  return { data, error, isLoading };
};
