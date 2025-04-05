import React, { useState } from "react";
import dayjs from "dayjs";
import { Container, Grid, Loader, Flex, Button } from "@mantine/core";

import { RevenueCard } from "./RevenueCards";
import { DateSelector } from "./DateSelector";
import { usePaymentReport } from "./hooks/usePaymentReport";
import { RevenueChart } from "./RevenueChart";
import { useSyncPayments } from "./hooks/useSyncPayments";
import { FaSyncAlt } from "react-icons/fa";

export const Dashboard = () => {
  const [dateRange, setDateRange] = useState<[Date | null, Date | null]>([
    null,
    null,
  ]);

  const [shouldFetchPayments, setShouldFetchPayments] = useState(false);

  const {
    mutate: syncPayements,
    data: syncData,
    error: syncErrors,
    isLoading: syncLoading,
  } = useSyncPayments({ shouldFetch: shouldFetchPayments });

  const handleClick = async () => {
    if (shouldFetchPayments) {
      syncPayements();
    } else {
      setShouldFetchPayments(true);
    }
  };

  const { data, error, isLoading } = usePaymentReport({ dateRange });

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

  const labelToColorMap: Record<string, string> = {
    Recurring: "indigo.6",
    Invoice: "blue.6",
    Other: "teal.6", // Add more labels as needed
  };

  const series = salesBySource.map((item) => ({
    name: item.label,
    color: labelToColorMap[item.label] || "gray.6", // Default to gray if no color is defined
  }));

  if (isLoading || syncLoading)
    return (
      <Container>
        <Flex justify="center" align="center" style={{ height: "25vh" }}>
          <Loader />
        </Flex>
      </Container>
    );

  return (
    <Container size="xl">
      <Grid>
        <Grid.Col span={{ base: 12, md: 6, lg: 8 }}>
          <DateSelector
            setDateRange={setDateRange}
            defaultStart={defaultStartDate}
            defaultEnd={defaultEndDate}
            dateRange={dateRange}
          />
        </Grid.Col>
        <Grid.Col span={{ base: 12, md: 6, lg: 2 }} />
        <Grid.Col span={2}>
          <Button
            color="teal"
            variant="filled"
            loading={syncLoading}
            onClick={handleClick}
            leftSection={<FaSyncAlt size={16} />}
          >
            Refresh Data
          </Button>
        </Grid.Col>
      </Grid>

      <Grid>
        <Grid.Col span={{ base: 12, md: 6, lg: 4 }}>
          <RevenueCard label={"Total"} value={data?.total_revenue ?? "0"} />
        </Grid.Col>

        {salesBySource
          .filter(
            (item) => item.label === "Recurring" || item.label === "Invoice"
          )
          .map((item) => (
            <Grid.Col span={{ base: 12, md: 6, lg: 4 }} key={item.label}>
              <RevenueCard label={item.label} value={item.value} />
            </Grid.Col>
          ))}
      </Grid>

      <Grid>
        <Grid.Col span={{ base: 12, md: 12, lg: 12 }}>
          <RevenueChart data={data} dateRange={dateRange} />
        </Grid.Col>
      </Grid>
      {error && <p>Error loading report</p>}
    </Container>
  );
};
