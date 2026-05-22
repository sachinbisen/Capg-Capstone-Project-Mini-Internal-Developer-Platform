/**
 * Mini Internal Developer Platform - Express Application
 * ------------------------------------------------------
 * This server provides two starter endpoints used in the capstone project:
 * 1) "/"       -> basic welcome response
 * 2) "/health" -> simple health status for monitoring readiness
 */

const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

/**
 * Built-in middleware to parse JSON request bodies.
 * This keeps the app ready for future POST/PUT API extensions.
 */
app.use(express.json());

/**
 * Request logging middleware.
 * Logs request timestamp, HTTP method, and route path for observability.
 */
app.use((req, _res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.originalUrl}`);
  next();
});

/**
 * Root route.
 * Returns a plain-text welcome message.
 */
app.get("/", (_req, res) => {
  res.status(200).send("Hello from Mini Internal Developer Platform");
});

/**
 * Health route.
 * Returns a minimal health response used by monitoring checks.
 */
app.get("/health", (_req, res) => {
  res.status(200).json({ status: "UP" });
});

/**
 * 404 handler for undefined routes.
 */
app.use((req, _res, next) => {
  const error = new Error(`Route not found: ${req.method} ${req.originalUrl}`);
  error.status = 404;
  next(error);
});

/**
 * Basic global error-handling middleware.
 * Sends standardized JSON errors for easier troubleshooting.
 */
app.use((error, _req, res, _next) => {
  const statusCode = error.status || 500;
  const message = error.message || "Internal Server Error";

  console.error(`[ERROR] ${statusCode} - ${message}`);
  res.status(statusCode).json({ error: message });
});

// Start server on configured environment PORT, defaulting to 3000.
app.listen(PORT, () => {
  console.log(`Mini IDP app is running on port ${PORT}`);
});
