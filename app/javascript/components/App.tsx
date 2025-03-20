import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Payments from "./Payments";
import { Dashboard } from "./Dashboard";
import { Container } from "@chakra-ui/react";
import { Nav } from "./Nav";

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Container>
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
