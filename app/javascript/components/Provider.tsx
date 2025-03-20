// app/javascript/components/Provider.tsx
import React, { FC, ReactNode } from "react";
import { ChakraProvider, defaultSystem } from "@chakra-ui/react";

interface ProviderProps {
  children: ReactNode;
}

const Provider: React.FC<ProviderProps> = ({ children }) => {
  return <ChakraProvider value={defaultSystem}>{children}</ChakraProvider>;
};

export default Provider;
