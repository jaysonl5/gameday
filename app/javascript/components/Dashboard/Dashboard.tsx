import React from "react";
import useSWR from "swr";
import { swrFetcher } from "../../utils/swr-fetcher";
import dayjs from "dayjs";
import { Text, Container, Grid } from "@mantine/core";

import { PaymentReportResponse } from "../types";
import { RevenueCard } from "./RevenueCards";

export const Dashboard = () => {
  const { data, error, isLoading } = useSWR<PaymentReportResponse>(
    "/api/v1/payments/report",
    swrFetcher
  );

  const salesByType = data?.payment_breakdown.by_type
    ? Object.entries(data.payment_breakdown.by_type).map(([key, value]) => ({
        label: key,
        value: value,
      }))
    : [];

  const salesBySource = data?.payment_breakdown.by_source
    ? Object.entries(data.payment_breakdown.by_source).map(([key, value]) => ({
        label: key,
        value: value,
      }))
    : [];

  return (
    <Container>
      <Text size="xl">
        {dayjs(data?.date_range.start_date).format("MM/DD/YYYY")} -{" "}
        {dayjs(data?.date_range.end_date).format("MM/DD/YYYY")}
      </Text>
      <Grid>
        <Grid.Col span={{ base: 12, md: 6, lg: 3 }}>
          <RevenueCard label={"Total"} value={data?.total_revenue ?? "0"} />
        </Grid.Col>

        {salesBySource
          .filter(
            (item) => item.label === "Recurring" || item.label === "Invoice"
          )
          .map((item) => (
            <Grid.Col span={{ base: 12, md: 6, lg: 3 }}>
              <RevenueCard label={item.label} value={item.value} />
            </Grid.Col>
          ))}
      </Grid>
      {isLoading && <p>Loading...</p>}
      {error && <p>Error loading report</p>}
    </Container>
  );
};
