import axios, { AxiosRequestConfig } from "axios";

export const defaultRequestConfig: AxiosRequestConfig = {
  headers: {
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-TOKEN": document.head.querySelector('meta[name="csrf-token"]')?.getAttribute("content"),
    "X-Timezone": Intl && Intl.DateTimeFormat().resolvedOptions().timeZone,
  },
};

export default axios.create({
  ...defaultRequestConfig,
  headers: {
    ...defaultRequestConfig.headers,
    "Content-Type": "multipart/form-data",
  },
});

export const axiosJson = axios.create({
  ...defaultRequestConfig,
  headers: {
    ...defaultRequestConfig.headers,
    "Content-Type": "application/json",
  },
});
