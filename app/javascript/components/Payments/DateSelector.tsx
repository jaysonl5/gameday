import { SegmentedControl } from "@mantine/core";
import { DatePickerInput } from "@mantine/dates";
import dayjs from "dayjs";
import React, { useEffect, useState } from "react";
import {
  DatePreset,
  getDateRangeForPreset,
  PRESET_OPTIONS,
} from "../../utils/constants";

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
  const handlePresetChange = (newPreset: string) => {
    setDateRange(getDateRangeForPreset(newPreset as DatePreset));
    setPreset(newPreset);
  };

  return (
    <>
      <SegmentedControl
        value={preset}
        onChange={handlePresetChange}
        data={PRESET_OPTIONS}
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
