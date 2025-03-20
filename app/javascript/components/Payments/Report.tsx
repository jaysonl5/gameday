import React from "react";
import useSWR from "swr";
import { PaymentReportResponse } from "./types";
import { swrFetcher } from "../../utils/swr-fetcher";
import { Card, Container, Separator, Spacer, Text } from "@chakra-ui/react";
import { formatCurrency } from "../../utils/index";
import dayjs from "dayjs";

export const Report = () => {
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
      <Text textStyle="5xl">
        {dayjs(data?.date_range.start_date).format("MM/DD/YYYY")} -{" "}
        {dayjs(data?.date_range.end_date).format("MM/DD/YYYY")}
      </Text>
      <Card.Root width="1/4">
        <Card.Header>
          <Card.Title>Total Revenue</Card.Title>
        </Card.Header>
        <Card.Body>
          <Text>{formatCurrency(data?.total_revenue)}</Text>
        </Card.Body>
        <Card.Footer>
          <Text textStyle="sm">
            {salesByType
              .map((item) => (
                <Text key={item.label}>
                  {item.label}: {formatCurrency(item.value)}
                </Text>
              ))
              .sort((a, b) => (b.key ?? "").localeCompare(a.key ?? ""))}
          </Text>
        </Card.Footer>
      </Card.Root>
      <Card.Root width="1/4">
        <Card.Header>
          <Card.Title>Revenue by Type</Card.Title>
        </Card.Header>
        <Card.Body>
          <Text>
            {salesBySource.map((item) => (
              <Text key={item.label}>
                {item.label}: {formatCurrency(item.value)}
              </Text>
            ))}
          </Text>
        </Card.Body>
        <Card.Footer></Card.Footer>
      </Card.Root>
      <Card.Root width="1/4">
        <Card.Header>
          <Card.Title>Sales</Card.Title>
        </Card.Header>
        <Card.Body>
          <Text>{data?.payment_breakdown.total_count}</Text>
        </Card.Body>
      </Card.Root>
      {isLoading && <p>Loading...</p>}
      {error && <p>Error loading report</p>}
    </Container>
  );
};
