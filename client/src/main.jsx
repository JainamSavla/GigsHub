import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

// Suppress defaultProps warning from third-party libraries
const originalError = console.error;
console.error = (...args) => {
  if (
    typeof args[0] === "string" &&
    args[0].includes("Support for defaultProps will be removed")
  ) {
    return;
  }
  originalError.apply(console, args);
};

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
