// Entry point for the build script in your package.json
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./components/App";
import "@mantine/core/styles.css";

import { MantineProvider } from "@mantine/core";

const rootElement = document.getElementById("root");
if (rootElement) {
  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <MantineProvider>
        <App />
      </MantineProvider>
    </React.StrictMode>
  );
}
