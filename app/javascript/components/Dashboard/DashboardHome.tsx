import React, { useState } from "react";
import { Container, Grid, Paper, Title, Card, Text, Button, Select, Group, Stack } from "@mantine/core";
import { FlaggedTitle } from "../Shared/FlaggedTitle";
import { MdOutlineSpaceDashboard } from "react-icons/md";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts";

export const DashboardHome = () => {
  const [thinkersFilter, setThinkersFilter] = useState("this_week");

  // TODO: Replace with actual API data
  const winRateData = [
    { period: "Today", winRate: 65, wins: 13, total: 20 },
    { period: "This Week", winRate: 58, wins: 35, total: 60 },
    { period: "This Month", winRate: 62, wins: 124, total: 200 },
  ];

  // TODO: Replace with actual API data from backend
  const thinkers = [
    { id: 1, name: "John Doe", phone: "555-0101", date: "2025-12-20", notes: "Interested in TRT" },
    { id: 2, name: "Jane Smith", phone: "555-0102", date: "2025-12-21", notes: "Asking about pricing" },
    { id: 3, name: "Bob Johnson", phone: "555-0103", date: "2025-12-22", notes: "Wants to compare with other clinics" },
  ];

  const handleMarkAsCalled = (thinkerId: number) => {
    // TODO: Implement API call to mark thinker as called
    console.log(`Marking thinker ${thinkerId} as called`);
  };

  return (
    <Container size="xl">
      <Paper shadow="sm" w={'100%'} p={{ base: 'sm', md: 'lg' }} radius="md" mb="md">
        <FlaggedTitle titleText="Dashboard" leftIcon={MdOutlineSpaceDashboard} />

        {/* Win Rate Chart */}
        <Card shadow="sm" padding="sm" radius="md" withBorder mb="xl">
          <Title order={3} mb="md">Win Rate</Title>
          <Grid mt="md">
            {winRateData.map((data) => (
              <Grid.Col key={data.period} span={{ base: 12, sm: 4 }}>
                <Card padding="md" radius="md" withBorder>
                  <Text size="sm" c="dimmed">{data.period}</Text>
                  <Title order={2} c="blue">{data.winRate}%</Title>
                  <Text size="xs" c="dimmed">{data.wins} wins of {data.total} total</Text>
                </Card>
              </Grid.Col>
            ))}
            </Grid>
          </Card>
        
        <Card shadow="sm" padding="lg" radius="md" withBorder>
          <Group justify="space-between" mb="md">
            <Title order={3}>Thinkers to Call</Title>
            <Select
              value={thinkersFilter}
              onChange={(value) => setThinkersFilter(value || "this_week")}
              data={[
                { value: "this_week", label: "This Week" },
                { value: "this_month", label: "This Month" },
                { value: "all_time", label: "All Time" },
              ]}
              w={150}
            />
          </Group>

          <Stack gap="md">
            {thinkers.length === 0 ? (
              <Text c="dimmed" ta="center">No thinkers to call</Text>
            ) : (
              thinkers.map((thinker) => (
                <Card key={thinker.id} padding="md" radius="md" withBorder>
                  <Grid align="center">
                    <Grid.Col span={{ base: 12, sm: 3 }}>
                      <Text fw={500}>{thinker.name}</Text>
                      <Text size="sm" c="dimmed">{thinker.phone}</Text>
                    </Grid.Col>
                    <Grid.Col span={{ base: 12, sm: 2 }}>
                      <Text size="sm" c="dimmed">Date</Text>
                      <Text size="sm">{thinker.date}</Text>
                    </Grid.Col>
                    <Grid.Col span={{ base: 12, sm: 4 }}>
                      <Text size="sm" c="dimmed">Notes</Text>
                      <Text size="sm">{thinker.notes}</Text>
                    </Grid.Col>
                    <Grid.Col span={{ base: 12, sm: 3 }}>
                      <Button
                        fullWidth
                        onClick={() => handleMarkAsCalled(thinker.id)}
                        variant="light"
                      >
                        Mark as Called
                      </Button>
                    </Grid.Col>
                  </Grid>
                </Card>
              ))
            )}
          </Stack>
        </Card>
      </Paper>
    </Container>
  );
};
