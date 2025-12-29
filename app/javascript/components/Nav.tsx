import React, { useState } from "react";
import { Link, useLocation } from "react-router-dom";

import { MdOutlineSpaceDashboard, MdPayment, MdSettings, MdLogout } from "react-icons/md";
import { TbPigMoney } from "react-icons/tb";
import { FaUserInjured, FaUserPlus } from "react-icons/fa";
import { Box, Button, Flex, Image, NavLink, Divider } from "@mantine/core";

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
        />

        <NavLink
          component={Link}
          to="/payments"
          color="dark"
          variant={getButtonVariant("/payments")}
          leftSection={<MdPayment size={20} />}
          label="Payments"
          onClick={() => setActive("Payments")}
          active={active === "Payments"}
        />

        <NavLink
          component={Link}
          to="/patient-census"
          color="dark"
          variant={getButtonVariant("/patient-census")}
          leftSection={<FaUserPlus size={20} />}
          label="Patient Census"
          onClick={() => setActive("PatientCensus")}
          active={active === "PatientCensus"}
        />

        <Divider my="sm" />

        <NavLink
          component={Link}
          to="/settings"
          color="dark"
          variant={getButtonVariant("/settings")}
          leftSection={<MdSettings size={20} />}
          label="Settings"
          onClick={() => setActive("Settings")}
          active={active === "Settings"}
        />

        <Divider my="sm" />

        <form method="post" action="/users/sign_out">
          <input type="hidden" name="_method" value="delete" />
          <input type="hidden" name="authenticity_token" value={document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || ''} />
          <NavLink
            component="button"
            type="submit"
            color="red"
            leftSection={<MdLogout size={20} />}
            label="Logout"
            style={{ border: 'none', background: 'none', cursor: 'pointer', width: '100%', textAlign: 'left' }}
          />
        </form>
      </Box>
    </>
  );
};
