import axios from "axios";
import useSWRMutation from "swr/mutation";

const syncPayments = async (url: string) => {
  const res = await axios.get(url);
  if (res.status !== 200) {
    throw new Error("Failed to sync payments");
  }
  return res.data.json();
};

export const useSyncPayments = () => {
  const apiUrl = `/api/v1/payments/sync`;

  return useSWRMutation(apiUrl, syncPayments);
};
