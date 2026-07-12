import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import "dotenv/config";
import { adminRouter } from "./routers/admin.Route.js";
import dashboardRouter from "./routers/dashboard.Route.js";
import employeeRouter from "./routers/employee.Route.js";
import uploadRouter from "./routers/upload.Route.js";
import additionalInfoRouter from "./routers/additional-info.route.js";
import settingsRouter from "./routers/settings.Route.js";
import promotionRouter from "./routers/promotion.Route.js";
import promotionApprovalRouter from "./routers/promotion-approval.route.js";
import transferRouter from "./routers/transfer.route.js";
import salaryRouter from "./routers/salary.Route.js";
import documentTypeRouter from "./routers/document-type.Route.js";
import documentCategoryRouter from "./routers/document-category.Route.js";
import reportsRouter from "./routers/reports.Route.js";
import autoInitialize from "./db/auto-init.js";

const app = express();
const PORT = process.env.PORT || 3000;
const corsOrigins = process.env.CORS_ORIGINS
  ? process.env.CORS_ORIGINS.split(",")
  : ["http://localhost:5173", "http://localhost:5174", "http://localhost:5175"];

app.use(
  cors({
    origin: corsOrigins,
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  }),
);

// Increase payload size limit for image uploads
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ limit: "10mb", extended: true }));
app.use(cookieParser());

app.use("/auth", adminRouter);
app.use("/dashboard", dashboardRouter);
app.use("/auth", employeeRouter);
app.use("/upload", uploadRouter);
app.use("/auth", additionalInfoRouter);
app.use("/settings", settingsRouter);
app.use("/promotion", promotionRouter);
app.use("/api/promotion-approval", promotionApprovalRouter);
app.use("/api/transfer", transferRouter);
app.use("/salary", salaryRouter);
app.use("/document-types", documentTypeRouter);
app.use("/document-categories", documentCategoryRouter);
app.use("/reports", reportsRouter);
app.get('/api/health', (req, res) => {
  res.json({ status: "ok" });
});

app.use("/uploads", express.static("uploads"));

// Auto-initialize database if needed
autoInitialize()
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Failed to initialize database:", err.message);
    process.exit(1);
  });
