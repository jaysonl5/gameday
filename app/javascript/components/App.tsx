import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Dashboard } from "./Dashboard/Dashboard";
import { Nav } from "./Nav";
import { Container, Grid, Image } from "@mantine/core";
import { Payments } from "./Payments/Payments";

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Container p={15} pt={30} my={5} size="xl">
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
          <Grid.Col span={2}>
            <Nav />
          </Grid.Col>
          <Grid.Col span={10}>
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
