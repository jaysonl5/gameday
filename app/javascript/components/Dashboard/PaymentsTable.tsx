import React, { useState } from "react";
import { 
  Table, 
  Paper, 
  Text, 
  Badge, 
  Pagination, 
  Box, 
  Skeleton,
  Stack,
  Center,
  Group,
  ActionIcon,
  Title
} from "@mantine/core";
import { FaSort, FaSortUp, FaSortDown } from "react-icons/fa";
import dayjs from "dayjs";
import { usePaymentsList } from "./hooks/usePaymentsList";
import { Payment, SortField } from "../types";

type PaymentsTableProps = {
  dateRange: [Date | null, Date | null];
  isLoading?: boolean;
};


export const PaymentsTable: React.FC<PaymentsTableProps> = ({ 
  dateRange, 
  isLoading: externalLoading = false 
}) => {
  const [page, setPage] = useState(1);
  const [sortBy, setSortBy] = useState<SortField>('created_at_api');
  const [sortDirection, setSortDirection] = useState<'asc' | 'desc'>('desc');

  const { data, error, isLoading } = usePaymentsList({
    dateRange,
    page,
    perPage: 10,
    sortBy,
    sortDirection
  });

  const handleSort = (field: SortField) => {
    if (sortBy === field) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortBy(field);
      setSortDirection('desc');
    }
    setPage(1); // Reset to first page when sorting changes
  };

  const getSortIcon = (field: SortField) => {
    if (sortBy !== field) return <FaSort size={12} />;
    return sortDirection === 'asc' ? <FaSortUp size={12} /> : <FaSortDown size={12} />;
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount);
  };

  const getTenderTypeColor = (tenderType: string) => {
    switch (tenderType) {
      case 'Card': return 'blue';
      case 'Cash': return 'green';
      case 'Check': return 'orange';
      case 'ACH': return 'purple';
      default: return 'gray';
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'Sale': return 'blue';
      case 'Return': return 'red';
      default: return 'gray';
    }
  };

  const loading = isLoading || externalLoading;

  if (loading && !data) {
    return (
      <Paper p="md" withBorder>
        <Stack gap="md">
          <Title order={3}>Recent Payments</Title>
          {Array.from({ length: 5 }).map((_, index) => (
            <Skeleton key={index} height={60} />
          ))}
        </Stack>
      </Paper>
    );
  }

  if (error) {
    return (
      <Paper p="md" withBorder>
        <Title order={3}>Recent Payments</Title>
        <Text c="red" mt="md">Error loading payments data</Text>
      </Paper>
    );
  }

  if (!data || data.data.length === 0) {
    return (
      <Paper p="md" withBorder>
        <Title order={3}>Recent Payments</Title>
        <Center h={200}>
          <Text c="dimmed">No payments found for the selected date range</Text>
        </Center>
      </Paper>
    );
  }

  const SortableHeader = ({ field, children }: { field: SortField; children: React.ReactNode }) => (
    <Table.Th 
      style={{ cursor: 'pointer', userSelect: 'none' }}
      onClick={() => handleSort(field)}
    >
      <Group gap="xs">
        {children}
        {getSortIcon(field)}
      </Group>
    </Table.Th>
  );

  return (
    <Paper p="md" withBorder>
      <Stack gap="md">
        <Group justify="space-between">
          <Title order={3}>Recent Payments</Title>
          <Text size="sm" c="dimmed">
            {data.pagination.total_count} total payments
          </Text>
        </Group>

        <Box style={{ overflowX: 'auto' }}>
          <Table striped highlightOnHover>
            <Table.Thead>
              <Table.Tr>
                <SortableHeader field="created_at_api">Date</SortableHeader>
                <SortableHeader field="amount">Amount</SortableHeader>
                <SortableHeader field="tender_type">Tender Type</SortableHeader>
                <SortableHeader field="payment_type">Type</SortableHeader>
                <SortableHeader field="source">Source</SortableHeader>
                <Table.Th>Recurring</Table.Th>
                <Table.Th>API ID</Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {data.data.map((payment: Payment) => (
                <Table.Tr key={payment.id}>
                  <Table.Td>
                    <Text size="sm">
                      {dayjs(payment.created_at_api).format('MMM D, YYYY')}
                    </Text>
                    <Text size="xs" c="dimmed">
                      {dayjs(payment.created_at_api).format('h:mm A')}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    <Text 
                      fw={500} 
                      c={payment.payment_type === 'Return' ? 'red' : undefined}
                    >
                      {payment.payment_type === 'Return' ? '-' : ''}
                      {formatCurrency(payment.amount)}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    <Badge 
                      size="sm" 
                      variant="light" 
                      color={getTenderTypeColor(payment.tender_type)}
                    >
                      {payment.tender_type}
                    </Badge>
                  </Table.Td>
                  <Table.Td>
                    <Badge 
                      size="sm" 
                      variant="light" 
                      color={getTypeColor(payment.payment_type)}
                    >
                      {payment.payment_type}
                    </Badge>
                  </Table.Td>
                  <Table.Td>
                    <Text size="sm">{payment.source}</Text>
                  </Table.Td>
                  <Table.Td>
                    <Badge 
                      size="sm" 
                      variant="light" 
                      color={payment.recurring ? 'violet' : 'gray'}
                    >
                      {payment.recurring ? 'Yes' : 'No'}
                    </Badge>
                  </Table.Td>
                  <Table.Td>
                    <Text size="xs" c="dimmed" style={{ fontFamily: 'monospace' }}>
                      {payment.api_id}
                    </Text>
                  </Table.Td>
                </Table.Tr>
              ))}
            </Table.Tbody>
          </Table>
        </Box>

        {data.pagination.total_pages > 1 && (
          <Center>
            <Pagination
              value={page}
              onChange={setPage}
              total={data.pagination.total_pages}
              size="sm"
            />
          </Center>
        )}
      </Stack>
    </Paper>
  );
};