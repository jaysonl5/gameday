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

  useEffect(() => {
    if (preset === "this_month") {
      setDateRange([
        dayjs().startOf("month").toDate(),
        dayjs().startOf("day").toDate(),
      ]);
    } else if (preset === "last_month") {
      setDateRange([
        dayjs().subtract(1, "month").startOf("month").toDate(),
        dayjs().subtract(1, "month").endOf("month").toDate(),
      ]);
    } else if (preset === "last_year") {
      setDateRange([
        dayjs().subtract(1, "year").startOf("year").toDate(),
        dayjs().subtract(1, "year").endOf("year").toDate(),
      ]);
    } else if (preset === "this_year") {
      setDateRange([
        dayjs().startOf("year").toDate(),
        dayjs().endOf("year").toDate(),
      ]);
    } else if (preset === "custom") {
      setDateRange([null, null]);
    }
  }, [preset]);

  return (
    <>
      <SegmentedControl
        value={preset}
        onChange={setPreset}
        data={presetOptions}
        fullWidth
        mb="md"
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
