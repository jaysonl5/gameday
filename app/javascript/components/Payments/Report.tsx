import React, { useEffect, useState } from "react";
import useSWR from "swr";
import { PaymentReportResponse } from "./types";
import { swrFetcher } from "../../utils/swr-fetcher";

import { formatCurrency } from "../../utils/index";
import dayjs from "dayjs";
import {
  Text,
  Card,
  Container,
  Flex,
  Transition,
  List,
  ListItem,
  ThemeIcon,
  Group,
} from "@mantine/core";
import { MdOutlinePointOfSale } from "react-icons/md";
import { TbMoneybag, TbPigMoney, TbTruckReturn } from "react-icons/tb";

export const Report = () => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    setVisible(true); // Trigger the transition when the component mounts
  }, []);

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
      <Flex gap="lg" justify="flex-start" direction="row">
        <Card shadow="md" padding="xl" radius="md" withBorder w={300}>
          <Group justify="start">
            <ThemeIcon radius="xl" color="teal">
              <TbPigMoney size={24} />
            </ThemeIcon>
            <Text size="lg" fw={700}>
              Total Revenue
            </Text>
            <Text>{formatCurrency(data?.total_revenue)}</Text>
          </Group>

          <List size="md">
            {salesByType
              .map((item) => (
                <Group justify="start">
                  <ListItem
                    key={item.label}
                    icon={
                      item.label === "Sale" ? (
                        <ThemeIcon color="teal" radius="xl">
                          <MdOutlinePointOfSale size={24} />
                        </ThemeIcon>
                      ) : (
                        <ThemeIcon color="red" radius="xl">
                          <TbTruckReturn size={24} />
                        </ThemeIcon>
                      )
                    }
                  >
                    {item.label}: {formatCurrency(item.value)}
                  </ListItem>
                </Group>
              ))
              .sort((a, b) => (b.key ?? "").localeCompare(a.key ?? ""))}
          </List>
        </Card>
        <Card shadow="md" padding="xl" radius="md" withBorder w={300}>
          <Text size="lg">Revenue by Type</Text>

          <Text>
            {salesBySource.map((item) => (
              <Text key={item.label}>
                {item.label}: {formatCurrency(item.value)}
              </Text>
            ))}
          </Text>
        </Card>
        <Card shadow="md" padding="xl" radius="md" withBorder w={300}>
          <Text size="lg">Sales</Text>
          <Text>{data?.payment_breakdown.total_count}</Text>
        </Card>
      </Flex>
      {isLoading && <p>Loading...</p>}
      {error && <p>Error loading report</p>}
    </Container>
  );
};
