import { AreaChart } from "@mantine/charts";
import dayjs from "dayjs";
import React from "react";
import { PaymentReportResponse } from "../types";

type RevenueChartProps = {
  data: PaymentReportResponse | undefined;
  dateRange: [Date | null, Date | null];
};

export const RevenueChart = ({ data, dateRange }: RevenueChartProps) => {
  const formatChartData = (
    raw: Array<{ date: string; source: string; amount: number }>,
    dateRange: [string, string],
    allSources: string[] = ["Invoice", "Recurring", "Customer", "QuickPay"]
  ) => {
    const [start, end] = dateRange.map((d) => new Date(d));

    // Group by date first
    const map = new Map<string, Record<string, any>>();

    for (const entry of raw) {
      const d = new Date(entry.date);
      if (d < start || d > end) continue;

      const dateKey = entry.date;
      if (!map.has(dateKey)) {
        map.set(dateKey, { date: dateKey });
      }
      map.get(dateKey)![entry.source] = entry.amount;
    }

    // Fill in missing sources with 0
    const result = Array.from(map.values()).map((row) => {
      allSources.forEach((src) => {
        if (!(src in row)) row[src] = 0;
      });
      return row;
    });

    // Sort by date
    return result.sort(
      (a, b) => new Date(a.date).getTime() - new Date(b.date).getTime()
    );
  };

  console.log(data?.payment_breakdown.by_day);

  return (
    <div style={{ width: "100%", height: "300px" }}>
      <h2>Revenue Chart</h2>
      {/* <AreaChart
        h={300}
        type="split"
        data={chartData}
        series={[
          { name: "Invoice", color: "blue" },
          { name: "Recurring", color: "green" },
          { name: "Customer", color: "red" },
          { name: "QuickPay", color: "orange" },
        ]}
        withLegend
        curveType="linear"
        dataKey="date"
      /> */}
    </div>
  );
};
