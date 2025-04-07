import { SegmentedControl } from "@mantine/core";
import { DatePickerInput } from "@mantine/dates";
import dayjs from "dayjs";
import React, { useEffect, useState } from "react";

type DateSelectorProps = {
  dateRange: [Date | null, Date | null];
  setDateRange: React.Dispatch<
    React.SetStateAction<[Date | null, Date | null]>
  >;
  defaultStart?: dayjs.Dayjs | Date;
  defaultEnd?: dayjs.Dayjs | Date;
  preset: string;
  setPreset: React.Dispatch<React.SetStateAction<string>>;
};

export const DateSelector = ({
  dateRange,
  setDateRange,
  defaultStart,
  defaultEnd,
  preset = "custom",
  setPreset,
}: DateSelectorProps) => {
  const presetOptions = [
    { label: "Custom", value: "custom" },
    { label: "This Month", value: "this_month" },
    { label: "Last Month", value: "last_month" },
    { label: "YTD", value: "this_year" },
    { label: "Previous Year", value: "last_year" },
  ];

  const getDateRangeForPreset = (
    preset: string
  ): [Date | null, Date | null] => {
    switch (preset) {
      case "this_month":
        return [
          dayjs().startOf("month").toDate(),
          dayjs().startOf("day").toDate(),
        ];
      case "last_month":
        return [
          dayjs().subtract(1, "month").startOf("month").toDate(),
          dayjs().subtract(1, "month").endOf("month").toDate(),
        ];
      case "this_year":
        return [
          dayjs().startOf("year").toDate(),
          dayjs().endOf("year").toDate(),
        ];
      case "last_year":
        return [
          dayjs().subtract(1, "year").startOf("year").toDate(),
          dayjs().subtract(1, "year").endOf("year").toDate(),
        ];
      case "custom":
      default:
        return [dayjs().startOf("day").toDate(), null];
    }
  };

  const handlePresetChange = (newPreset: string) => {
    setDateRange(getDateRangeForPreset(newPreset));
    setPreset(newPreset);
  };

  return (
    <>
      <SegmentedControl
        value={preset}
        onChange={handlePresetChange}
        data={presetOptions}
        fullWidth
        mb="md"
        color="dark"
      />
      <DatePickerInput
        allowSingleDateInRange
        type="range"
        value={dateRange}
        onChange={setDateRange}
      />
    </>
  );
};
