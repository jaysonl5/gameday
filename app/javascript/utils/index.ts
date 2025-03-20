
export function formatCurrency(value: any , digits = 2) {
    const formatter = new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      maximumFractionDigits: digits,
      minimumFractionDigits: digits,
    });
  
    return formatter.format(value);
  }