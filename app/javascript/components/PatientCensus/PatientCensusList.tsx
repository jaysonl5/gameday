import React, { useState } from "react";
import {
  Box,
  Tabs,
  Table,
  Badge,
  Text,
  Group,
  Card,
  Title,
  Loader,
  Center
} from "@mantine/core";
import { PatientCensusEntry } from "../types";
import useSWR from "swr";
import axios from "axios";

const fetcher = (url: string) => axios.get(url).then(res => res.data);

export const PatientCensusList: React.FC = () => {
  const [activeTab, setActiveTab] = useState<string>('Win');
  
  const { data: entries, error, isLoading } = useSWR<PatientCensusEntry[]>(
    `/api/v1/patient_census_entries?patient_result=${activeTab}`,
    fetcher
  );

  const getResultBadgeColor = (result: string) => {
    switch (result) {
      case 'Win': return 'green';
      case 'Thinker': return 'yellow';
      case 'Loss': return 'red';
      default: return 'gray';
    }
  };

  const formatPlan = (plan: string[] | undefined) => {
    if (!plan || plan.length === 0) return '-';
    return plan.join(', ');
  };

  const renderWinRow = (entry: PatientCensusEntry) => (
    <Table.Tr key={entry.id}>
      <Table.Td>{entry.date}</Table.Td>
      <Table.Td>{entry.patient_name}</Table.Td>
      <Table.Td>
        <Badge color={getResultBadgeColor(entry.patient_result)}>
          {entry.patient_result}
        </Badge>
      </Table.Td>
      <Table.Td>{entry.mail_out_in_clinic || '-'}</Table.Td>
      <Table.Td>{entry.in_clinic_dose_ml || '-'}</Table.Td>
      <Table.Td>{entry.lead_source || '-'}</Table.Td>
      <Table.Td>{formatPlan(entry.plan)}</Table.Td>
      <Table.Td>{entry.rate || '-'}</Table.Td>
      <Table.Td>{entry.notes || '-'}</Table.Td>
    </Table.Tr>
  );

  const renderThinkerRow = (entry: PatientCensusEntry) => (
    <Table.Tr key={entry.id}>
      <Table.Td>{entry.date}</Table.Td>
      <Table.Td>{entry.patient_name}</Table.Td>
      <Table.Td>
        <Badge color={getResultBadgeColor(entry.patient_result)}>
          {entry.patient_result}
        </Badge>
      </Table.Td>
      <Table.Td>{entry.p_or_other || '-'}</Table.Td>
      <Table.Td>{formatPlan(entry.plan)}</Table.Td>
      <Table.Td>{entry.rate || '-'}</Table.Td>
      <Table.Td>{entry.extra_info || '-'}</Table.Td>
      <Table.Td>{entry.phone_number || '-'}</Table.Td>
      <Table.Td>{entry.notes || '-'}</Table.Td>
    </Table.Tr>
  );

  const renderLossRow = (entry: PatientCensusEntry) => (
    <Table.Tr key={entry.id}>
      <Table.Td>{entry.date}</Table.Td>
      <Table.Td>{entry.patient_name}</Table.Td>
      <Table.Td>
        <Badge color={getResultBadgeColor(entry.patient_result)}>
          {entry.patient_result}
        </Badge>
      </Table.Td>
      <Table.Td>{entry.p_or_other || '-'}</Table.Td>
      <Table.Td>{formatPlan(entry.plan)}</Table.Td>
      <Table.Td>{entry.why_a_loss || '-'}</Table.Td>
    </Table.Tr>
  );

  const renderWinHeaders = () => (
    <Table.Thead>
      <Table.Tr>
        <Table.Th>Date</Table.Th>
        <Table.Th>Patient</Table.Th>
        <Table.Th>Result</Table.Th>
        <Table.Th>In/Out Clinic</Table.Th>
        <Table.Th>Dose (ml)</Table.Th>
        <Table.Th>Lead Source</Table.Th>
        <Table.Th>Plan</Table.Th>
        <Table.Th>Rate</Table.Th>
        <Table.Th>Notes</Table.Th>
      </Table.Tr>
    </Table.Thead>
  );

  const renderThinkerHeaders = () => (
    <Table.Thead>
      <Table.Tr>
        <Table.Th>Date</Table.Th>
        <Table.Th>Patient</Table.Th>
        <Table.Th>Result</Table.Th>
        <Table.Th>P or Other</Table.Th>
        <Table.Th>Plan</Table.Th>
        <Table.Th>Rate</Table.Th>
        <Table.Th>Other Info</Table.Th>
        <Table.Th>Phone</Table.Th>
        <Table.Th>Notes</Table.Th>
      </Table.Tr>
    </Table.Thead>
  );

  const renderLossHeaders = () => (
    <Table.Thead>
      <Table.Tr>
        <Table.Th>Date</Table.Th>
        <Table.Th>Patient</Table.Th>
        <Table.Th>Result</Table.Th>
        <Table.Th>P or Other</Table.Th>
        <Table.Th>Plan</Table.Th>
        <Table.Th>Why a Loss</Table.Th>
      </Table.Tr>
    </Table.Thead>
  );

  const renderTableContent = () => {
    if (isLoading) {
      return (
        <Center h={200}>
          <Loader />
        </Center>
      );
    }

    if (error) {
      return (
        <Center h={200}>
          <Text c="red">Failed to load entries</Text>
        </Center>
      );
    }

    if (!entries || entries.length === 0) {
      return (
        <Center h={200}>
          <Text c="dimmed">No entries found for {activeTab}</Text>
        </Center>
      );
    }

    return (
      <Table striped highlightOnHover>
        {activeTab === 'Win' && renderWinHeaders()}
        {activeTab === 'Thinker' && renderThinkerHeaders()}
        {activeTab === 'Loss' && renderLossHeaders()}
        
        <Table.Tbody>
          {entries.map(entry => {
            if (activeTab === 'Win') return renderWinRow(entry);
            if (activeTab === 'Thinker') return renderThinkerRow(entry);
            if (activeTab === 'Loss') return renderLossRow(entry);
            return null;
          })}
        </Table.Tbody>
      </Table>
    );
  };

  return (
    <Card shadow="sm" padding="lg">
      <Group justify="space-between" mb="lg">
        <Title order={2}>Patient Census Entries</Title>
        <Badge size="lg" variant="light">
          {entries?.length || 0} {activeTab} entries
        </Badge>
      </Group>

      <Tabs value={activeTab} onChange={(value) => setActiveTab(value || 'Win')}>
        <Tabs.List>
          <Tabs.Tab value="Win" color="green">
            Wins
          </Tabs.Tab>
          <Tabs.Tab value="Thinker" color="yellow">
            Thinkers
          </Tabs.Tab>
          <Tabs.Tab value="Loss" color="red">
            Losses
          </Tabs.Tab>
        </Tabs.List>

        <Tabs.Panel value="Win" pt="md">
          {renderTableContent()}
        </Tabs.Panel>

        <Tabs.Panel value="Thinker" pt="md">
          {renderTableContent()}
        </Tabs.Panel>

        <Tabs.Panel value="Loss" pt="md">
          {renderTableContent()}
        </Tabs.Panel>
      </Tabs>
    </Card>
  );
};