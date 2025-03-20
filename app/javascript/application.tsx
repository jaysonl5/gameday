// Entry point for the build script in your package.json
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./components/App";
import { ChakraProvider, defaultSystem, Theme } from "@chakra-ui/react";
import Provider from "./components/Provider";

const rootElement = document.getElementById("root");
if (rootElement) {
  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <Provider>
        <App />
      </Provider>
    </React.StrictMode>
  );
}
