import express from "express";
import { verifyAdmin } from "../middleware/auth.js";
import {
  getAllSalaryScales,
  getSalaryScaleById,
  createSalaryScale,
  updateSalaryScale,
  deleteSalaryScale,
  getAllJobClasses,
  createJobClass,
  updateJobClass,
  deleteJobClass,
  getAllJobRoleClasses,
  createJobRoleClass,
  createJobRoleClassBulk,
  updateJobRoleClass,
  deleteJobRoleClass,
  getAllJobRoles,
  createJobRole,
  updateJobRole,
  deleteJobRole,
  getSystemSettings,
  updateSystemSettings,
} from "../controllers/settings.Controller.js";

const router = express.Router();

// Salary Scales Routes
router.get("/salary-scales", verifyAdmin, getAllSalaryScales);
router.get("/salary-scales/:id", verifyAdmin, getSalaryScaleById);
router.post("/salary-scales", verifyAdmin, createSalaryScale);
router.put("/salary-scales/:id", verifyAdmin, updateSalaryScale);
router.delete("/salary-scales/:id", verifyAdmin, deleteSalaryScale);

// Job Classes Routes
router.get("/job-classes", verifyAdmin, getAllJobClasses);
router.post("/job-classes", verifyAdmin, createJobClass);
router.put("/job-classes/:id", verifyAdmin, updateJobClass);
router.delete("/job-classes/:id", verifyAdmin, deleteJobClass);

// Job Roles Routes
router.get("/job-roles", verifyAdmin, getAllJobRoles);
router.post("/job-roles", verifyAdmin, createJobRole);
router.put("/job-roles/:id", verifyAdmin, updateJobRole);
router.delete("/job-roles/:id", verifyAdmin, deleteJobRole);

// Job Role Class Assignments Routes
router.get("/job-role-classes", verifyAdmin, getAllJobRoleClasses);
router.post("/job-role-classes", verifyAdmin, createJobRoleClass);
router.post("/job-role-classes/bulk", verifyAdmin, createJobRoleClassBulk);
router.put("/job-role-classes/:id", verifyAdmin, updateJobRoleClass);
router.delete("/job-role-classes/:id", verifyAdmin, deleteJobRoleClass);

// Job Roles Routes (for dropdowns)
router.get("/job-roles", verifyAdmin, getAllJobRoles);

// System Settings Routes
router.get("/system", getSystemSettings); // Public - needed before login for theme/colors
router.put("/system", verifyAdmin, updateSystemSettings);

export default router;
