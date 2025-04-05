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
};

export const DateSelector = ({
  dateRange,
  setDateRange,
  defaultStart,
  defaultEnd,
}: DateSelectorProps) => {
  const presetOptions = [
    { label: "Custom", value: "custom" },
    { label: "This Month", value: "this_month" },
    { label: "Last Month", value: "last_month" },
    { label: "YTD", value: "this_year" },
    { label: "Previous Year", value: "last_year" },
  ];

  const [preset, setPreset] = useState("custom");

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
    setPreset(newPreset);
    setDateRange(getDateRangeForPreset(newPreset));
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
        value={
          dateRange ??
          (defaultStart && defaultEnd) ?? [defaultStart, defaultEnd]
        }
        onChange={([start, end]) => {
          setDateRange([start, end]), setPreset("custom");
        }}
      />
    </>
  );
};
