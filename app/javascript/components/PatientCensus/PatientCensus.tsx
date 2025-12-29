import React, { useState } from "react";
import { Box, Button, Modal, Stack } from "@mantine/core";
import { PatientCensusForm } from "./PatientCensusForm";
import { PatientCensusList } from "./PatientCensusList";
import { FaUserPlus } from "react-icons/fa";

export const PatientCensus: React.FC = () => {
  const [refreshKey, setRefreshKey] = useState(0);
  const [modalOpened, setModalOpened] = useState(false);

  const handleFormSuccess = () => {
    // Trigger a refresh of the list by updating the key
    setRefreshKey(prev => prev + 1);
    setModalOpened(false);
  };

  return (
    <Box>
      <Stack gap="lg">
        <Button
          leftSection={<FaUserPlus />}
          onClick={() => setModalOpened(true)}
          size="lg"
        >
          New Patient
        </Button>

        <PatientCensusList key={refreshKey} />

        <Modal
          opened={modalOpened}
          onClose={() => setModalOpened(false)}
          title="Add New Patient"
          size="xl"
        >
          <PatientCensusForm onSuccess={handleFormSuccess} />
        </Modal>
      </Stack>
    </Box>
  );
};