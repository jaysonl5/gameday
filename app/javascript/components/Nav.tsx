import React from "react";
import { Link, useLocation } from "react-router-dom";

import { MdOutlineSpaceDashboard } from "react-icons/md";
import { TbPigMoney } from "react-icons/tb";
import { Button, Flex, Image } from "@mantine/core";

export const Nav: React.FC = () => {
  const location = useLocation();

  const getButtonVariant = (path: string) =>
    location.pathname === path ? "filled" : "subtle";
  return (
    <Flex direction="row" justify="space-between" gap={4}>
      <Image
        w="150px"
        fit="contain"
        src="https://gamedaymenshealth.com/wp-content/uploads/2024/09/GD-Header-black.png"
        alt="Logo"
      />
      <Button.Group>
        <Button
          color="var(--mantine-color-dark-8)"
          variant={getButtonVariant("/")}
          component={Link}
          to="/"
        >
          Dashboard <MdOutlineSpaceDashboard />
        </Button>

        <Button
          component={Link}
          to="/Payments"
          color="green"
          variant={getButtonVariant("/Payments")}
        >
          Payments <TbPigMoney />
        </Button>
      </Button.Group>
    </Flex>
  );
};
