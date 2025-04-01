import { Card, Group, ThemeIcon, Text, Title } from "@mantine/core";
import React, { JSX } from "react";
import { FaFileInvoiceDollar } from "react-icons/fa";
import { RiExchangeDollarLine } from "react-icons/ri";
import { formatCurrency } from "../../utils";
import { TbPigMoney } from "react-icons/tb";

const iconMap: Record<string, JSX.Element> = {
  Revenue: <TbPigMoney size={24} />,
  Invoice: <FaFileInvoiceDollar size={24} />,
  Recurring: <RiExchangeDollarLine size={24} />,
};

type RevenueCardProps = {
  label: string;
  value: string;
};

export const RevenueCard = ({ label, value }: RevenueCardProps) => {
  return (
    <Card shadow="md" padding="xl" withBorder radius="md" key={label} mih={175}>
      <Group>
        <ThemeIcon radius="xl" color="indigo">
          {iconMap[label] ?? null}
        </ThemeIcon>
        <Title order={4}>{label}</Title>
      </Group>
      <Title order={2}>{formatCurrency(value)}</Title>
    </Card>
  );
};
