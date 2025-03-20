import axios, { AxiosRequestConfig } from "axios";

import { RequestOptions } from "../api/request-types";
import { defaultRequestConfig } from "./axios";



export const swrFetcher = async (url: string, options?: AxiosRequestConfig & RequestOptions) => {
  const response = await axios.get(url, { ...defaultRequestConfig, ...options });

  if (response.data) {
    return response.data;
  }

  return response;
};

export const swrMultiFetcher = async (urls: string[], options?: AxiosRequestConfig & RequestOptions) => {
  const results = await Promise.all(urls.map((url) => swrFetcher(url, options)));

  return results;
};
