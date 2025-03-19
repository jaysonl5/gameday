import React from "react";
import { BrowserRouter, Routes, Route, Link } from "react-router-dom";
import Payments from "./Payments";
import { Dashboard } from "./Dashboard";

const App: React.FC = () => {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">Dashboard</Link> | <Link to="/Payments">Payments</Link>
      </nav>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/Payments" element={<Payments />} />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
