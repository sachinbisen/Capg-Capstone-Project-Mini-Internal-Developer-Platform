/**
 * Mini Internal Developer Platform sample service.
 * This lightweight Express API acts as the deployable workload
 * managed by the platform pipeline.
 */

const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

// Health endpoint used for liveness checks and smoke tests.
app.get("/health", (_req, res) => {
  res.status(200).json({
    status: "healthy",
    service: "mini-idp-app",
    timestamp: new Date().toISOString(),
  });
});

// Root endpoint for quick verification after deployment.
app.get("/", (_req, res) => {
  res.status(200).send("Mini Internal Developer Platform app is running.");
});

// Start the HTTP server and listen on the configured port.
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
