import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Dashboard } from "./Dashboard/Dashboard";
import { Nav } from "./Nav";
import { Container } from "@mantine/core";
import { Payments } from "./Payments/Payments";

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Container p={15} pt={30} my={10}>
        <Nav />
      </Container>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/Payments" element={<Payments />} />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
