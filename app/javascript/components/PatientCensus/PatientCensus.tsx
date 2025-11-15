import React, { useState } from "react";
import { Box, Grid, Stack } from "@mantine/core";
import { PatientCensusForm } from "./PatientCensusForm";
import { PatientCensusList } from "./PatientCensusList";

export const PatientCensus: React.FC = () => {
  const [refreshKey, setRefreshKey] = useState(0);

  const handleFormSuccess = () => {
    // Trigger a refresh of the list by updating the key
    setRefreshKey(prev => prev + 1);
  };

  return (
    <Box>
      <Stack gap="lg">
        <PatientCensusForm onSuccess={handleFormSuccess} />
        <PatientCensusList key={refreshKey} />
      </Stack>
    </Box>
  );
};