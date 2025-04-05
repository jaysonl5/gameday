import dayjs from "dayjs";
import useSWR from "swr";
import { PaymentReportResponse } from "../../types";
import { swrFetcher } from "../../../utils/swr-fetcher";

type useSyncPaymentsProps = {
  shouldFetch: boolean;
};

export const useSyncPayments = ({ shouldFetch }: useSyncPaymentsProps) => {
  const apiUrl = `/api/v1/payments/sync`;

  const { mutate, data, error, isLoading } = useSWR<PaymentReportResponse>(
    shouldFetch ? apiUrl : null,
    swrFetcher
  );

  return { mutate, data, error, isLoading };
};
