import React, { useState } from "react";
import { Link, useLocation } from "react-router-dom";

import { MdOutlineSpaceDashboard } from "react-icons/md";
import { TbPigMoney } from "react-icons/tb";
import { FaUserInjured, FaUserPlus } from "react-icons/fa";
import { Box, Button, Flex, Image, NavLink } from "@mantine/core";

export const Nav: React.FC = () => {
  const location = useLocation();

  const [active, setActive] = useState("Dashboard");

  const getButtonVariant = (path: string) =>
    location.pathname === path ? "filled" : "subtle";
  return (
    <>
      <Box my={10}> 
        <img src="/assets/images/logo.svg" alt="Logo" width={"100%"} />
      </Box>
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
          disabled={true}
        />

        <NavLink
          component={Link}
          to="/PatientCensus"
          color="dark"
          variant={getButtonVariant("/PatientCensus")}
          leftSection={<FaUserPlus size={20} />}
          label="Patient Census"
          onClick={() => setActive("PatientCensus")}
          active={active === "PatientCensus"}
        />
      </Box>
    </>
  );
};
