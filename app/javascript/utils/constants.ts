import dayjs from "dayjs";

export type DatePreset = 'custom' | 'this_month' | 'last_month' | 'this_year' | 'last_year';


export const DATE_PRESETS = {
    this_month: {
      start: () => dayjs().startOf("month"),
      end: () => dayjs().endOf("day"),
      label: "This Month"
    },
    this_year: {
      start: () => dayjs().startOf("year"),
      end: () => dayjs().endOf("day"),
      label: "This Year"
    },
    last_month: {
      start: () => dayjs().subtract(1, "month").startOf("month"),
      end: () => dayjs().subtract(1, "month").endOf("month"),
      label: "Last Month"
    },
    
    last_year: {
      start: () => dayjs().subtract(1, "year").startOf("year"),
      end: () => dayjs().subtract(1, "year").endOf("year"),
      label: "Last Year"
    },
    custom: {
      start: () => dayjs().startOf("day"),
      end: () => null,
      label: "Custom"
    }
  } as const;

export const getDateRangeForPreset = (preset: DatePreset): [Date | null, Date | null] => {
    const datePreset = DATE_PRESETS[preset] || DATE_PRESETS.custom;
    return [
      datePreset.start().toDate(),
      datePreset.end()?.toDate() ?? null
    ];
  };

export const PRESET_OPTIONS = Object.entries(DATE_PRESETS).map(([value, config]) => ({
    value,
    label: config.label
  }));