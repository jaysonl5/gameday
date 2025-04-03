import React, { useEffect, useState } from "react";
import useSWR from "swr";
import { swrFetcher } from "../../utils/swr-fetcher";
import dayjs from "dayjs";
import { Container, Grid, Loader, Flex } from "@mantine/core";

import { PaymentReportResponse } from "../types";
import { RevenueCard } from "./RevenueCards";
import { DateSelector } from "./DateSelector";

export const Dashboard = () => {
  const [dateRange, setDateRange] = useState<[Date | null, Date | null]>([
    null,
    null,
  ]);

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

  const defaultStartDate = dayjs(data?.date_range.start_date);
  const defaultEndDate = dayjs(data?.date_range.end_date);

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

  if (isLoading)
    return (
      <Container>
        <Flex justify="center" align="center" style={{ height: "25vh" }}>
          <Loader />
        </Flex>
      </Container>
    );

  return (
    <Container>
      <Grid>
        <Grid.Col>
          <DateSelector
            setDateRange={setDateRange}
            defaultStart={defaultStartDate}
            defaultEnd={defaultEndDate}
            dateRange={dateRange}
          />
        </Grid.Col>
      </Grid>

      {/* <Text size="xl">
        {dayjs(data?.date_range.start_date).format("MM/DD/YYYY")} -{" "}
        {dayjs(data?.date_range.end_date).format("MM/DD/YYYY")}
      </Text> */}
      <Grid>
        <Grid.Col span={{ base: 12, md: 6, lg: 3 }}>
          <RevenueCard label={"Total"} value={data?.total_revenue ?? "0"} />
        </Grid.Col>

        {salesBySource
          .filter(
            (item) => item.label === "Recurring" || item.label === "Invoice"
          )
          .map((item) => (
            <Grid.Col span={{ base: 12, md: 6, lg: 3 }} key={item.label}>
              <RevenueCard label={item.label} value={item.value} />
            </Grid.Col>
          ))}
      </Grid>
      {isLoading && <p>Loading...</p>}
      {error && <p>Error loading report</p>}
    </Container>
  );
};
