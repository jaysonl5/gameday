import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Dashboard } from "./Dashboard/Dashboard";
import { Nav } from "./Nav";
import { Box, Container, Grid, Image } from "@mantine/core";
import { Payments } from "./Payments/Payments";

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Container pt={30} size="xl" bg="gray.0">
        <Grid>
          <Image
            w="180px"
            fit="contain"
            src="https://gamedaymenshealth.com/wp-content/uploads/2024/09/GD-Header-black.png"
            alt="Logo"
            mb={20}
          />
        </Grid>
        <Grid>
          <Grid.Col span={{ base: 12, md: 2, lg: 2 }}>
            <Nav />
          </Grid.Col>
          <Grid.Col span={{ base: 12, md: 8, lg: 8 }}>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/Payments" element={<Payments />} />
            </Routes>
          </Grid.Col>
        </Grid>
      </Container>
    </BrowserRouter>
  );
};

export default App;
