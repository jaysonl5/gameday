import React, { useState } from "react";
import { Link, useLocation } from "react-router-dom";

import { MdOutlineSpaceDashboard } from "react-icons/md";
import { TbPigMoney } from "react-icons/tb";
import { FaUserInjured } from "react-icons/fa";
import { Box, Button, Flex, Image, NavLink } from "@mantine/core";

export const Nav: React.FC = () => {
  const location = useLocation();

  const [active, setActive] = useState("Dashboard");

  const getButtonVariant = (path: string) =>
    location.pathname === path ? "filled" : "subtle";
  return (
    <>
      <Box>
        <NavLink
          color="dark"
          variant={getButtonVariant("/")}
          component={Link}
          to="/"
          leftSection={<MdOutlineSpaceDashboard size={20} />}
          label="Dashboard"
          onClick={() => setActive("Dashboard")}
          active={active === "Dashboard"}
        />

        <NavLink
          component={Link}
          to="/Payments"
          color="dark"
          variant={getButtonVariant("/Payments")}
          leftSection={<TbPigMoney size={20} />}
          label="Payments"
          onClick={() => setActive("Payments")}
          active={active === "Payments"}
        />

        <NavLink
          component={Link}
          to="/PatientCensus"
          color="dark"
          variant={getButtonVariant("/PatientCensus")}
          leftSection={<FaUserInjured size={20} />}
          label="Patient Census"
          onClick={() => setActive("PatientCensus")}
          active={active === "PatientCensus"}
        />
      </Box>
    </>
  );
};
