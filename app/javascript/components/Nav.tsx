import React from "react";
import { Link as RouterLink, useLocation } from "react-router-dom";

import { Button, ButtonGroup, Flex, Image } from "@chakra-ui/react";
import { MdOutlineSpaceDashboard } from "react-icons/md";
import { TbPigMoney } from "react-icons/tb";

export const Nav: React.FC = () => {
  const location = useLocation();

  const getButtonVariant = (path: string) =>
    location.pathname === path ? "solid" : "ghost";
  return (
    <Flex direction="row" justify="space-between" gap={4}>
      <Image
        rounded="md"
        w="250px"
        aspectRatio={2 / 1}
        fit="contain"
        src="https://gamedaymenshealth.com/wp-content/uploads/2024/09/GD-Header-black.png"
        alt="Logo"
      />
      <ButtonGroup>
        <Button asChild variant={getButtonVariant("/")}>
          <RouterLink to="/">
            Dashboard <MdOutlineSpaceDashboard />
          </RouterLink>
        </Button>

        <Button
          asChild
          colorPalette="green"
          variant={getButtonVariant("/Payments")}
        >
          <RouterLink to="/Payments">
            Payments <TbPigMoney />
          </RouterLink>
        </Button>
      </ButtonGroup>
    </Flex>
  );
};
