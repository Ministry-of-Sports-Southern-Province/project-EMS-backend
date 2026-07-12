import pool from "../config/db.config.js";

/**
 * System Configuration Controller
 * Handles salary scales, codes, job classes, and system setup
 */

// ==================== Salary Scales ====================

// Get all salary scales
export const getAllSalaryScales = async (req, res) => {
  try {
    const [scales] = await pool.query(`
      SELECT 
        ss.*,
        COUNT(DISTINCT sip.id) as phase_count,
        COUNT(DISTINCT jrc.id) as assigned_roles
      FROM salary_scale ss
      LEFT JOIN salary_increment_phase sip ON ss.id = sip.fk_salary_scale_id
      LEFT JOIN job_role_class jrc ON ss.id = jrc.fk_salary_scale_id
      GROUP BY ss.id
      ORDER BY ss.code
    `);

    res.json({
      success: true,
      data: scales,
    });
  } catch (error) {
    console.error("Error fetching salary scales:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch salary scales",
      error: error.message,
    });
  }
};

// Get salary scale by ID with phases and class progression
export const getSalaryScaleById = async (req, res) => {
  const { id } = req.params;

  try {
    const [scales] = await pool.query(
      "SELECT * FROM salary_scale WHERE id = ?",
      [id],
    );

    if (scales.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Salary scale not found",
      });
    }

    const [phases] = await pool.query(
      "SELECT * FROM salary_increment_phase WHERE fk_salary_scale_id = ? ORDER BY phase_order",
      [id],
    );

    const [classProgression] = await pool.query(
      `SELECT 
        sscp.*,
        jc.class_code
      FROM salary_scale_class_progression sscp
      INNER JOIN job_class jc ON sscp.fk_job_class_id = jc.id
      WHERE sscp.fk_salary_scale_id = ?
      ORDER BY sscp.from_step`,
      [id],
    );

    res.json({
      success: true,
      data: {
        ...scales[0],
        phases,
        class_progression: classProgression,
      },
    });
  } catch (error) {
    console.error("Error fetching salary scale:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch salary scale",
      error: error.message,
    });
  }
};

// Create salary scale with phases and class progression
export const createSalaryScale = async (req, res) => {
  const {
    code,
    starting_basic,
    max_years,
    final_basic,
    effective_from,
    phases,
    has_class_progression,
    class_progression,
  } = req.body;

  const connection = await pool.getConnection();

  try {
    // Validate that phases amount equals final basic
    if (phases && phases.length > 0) {
      const startingBasicNum = parseFloat(starting_basic);
      const finalBasicNum = parseFloat(final_basic);

      const totalIncrement = phases.reduce((sum, phase) => {
        const years = parseInt(phase.years || 0);
        const increment = parseFloat(phase.annual_increment || 0);
        return sum + years * increment;
      }, 0);

      const calculatedFinalBasic = startingBasicNum + totalIncrement;
      const difference = Math.abs(calculatedFinalBasic - finalBasicNum);

      // Allow small rounding differences (±1)
      if (difference > 1) {
        return res.status(400).json({
          success: false,
          message: `Validation Error: Phase amounts sum to ${calculatedFinalBasic.toFixed(
            2,
          )}, but final basic is ${finalBasicNum.toFixed(
            2,
          )}. Difference: ${difference.toFixed(
            2,
          )}. Please adjust phase increments or final basic.`,
        });
      }
    }

    await connection.beginTransaction();

    // Insert salary scale
    const [result] = await connection.query(
      `INSERT INTO salary_scale (code, starting_basic, max_years, final_basic, effective_from, has_class_progression)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [
        code,
        starting_basic,
        max_years,
        final_basic,
        effective_from,
        has_class_progression ? 1 : 0,
      ],
    );

    const salaryScaleId = result.insertId;

    // Insert phases if provided
    if (phases && phases.length > 0) {
      const phaseValues = phases.map((p) => [
        salaryScaleId,
        p.phase_order,
        p.years,
        p.annual_increment,
      ]);

      await connection.query(
        `INSERT INTO salary_increment_phase (fk_salary_scale_id, phase_order, years, annual_increment)
         VALUES ?`,
        [phaseValues],
      );
    }

    // Insert class progression if provided
    if (
      has_class_progression &&
      class_progression &&
      class_progression.length > 0
    ) {
      const progressionValues = class_progression.map((cp) => [
        salaryScaleId,
        cp.fk_job_class_id,
        cp.from_step,
        cp.to_step,
        cp.starting_basic,
        cp.final_basic,
      ]);

      await connection.query(
        `INSERT INTO salary_scale_class_progression (fk_salary_scale_id, fk_job_class_id, from_step, to_step, starting_basic, final_basic)
         VALUES ?`,
        [progressionValues],
      );
    }

    await connection.commit();

    res.status(201).json({
      success: true,
      message: "Salary scale created successfully",
      data: { id: salaryScaleId },
    });
  } catch (error) {
    await connection.rollback();
    console.error("Error creating salary scale:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create salary scale",
      error: error.message,
    });
  } finally {
    connection.release();
  }
};

// Update salary scale
export const updateSalaryScale = async (req, res) => {
  const { id } = req.params;
  const {
    code,
    starting_basic,
    max_years,
    final_basic,
    effective_from,
    effective_to,
    phases,
    has_class_progression,
    class_progression,
  } = req.body;

  const connection = await pool.getConnection();

  try {
    // Validate that phases amount equals final basic
    if (phases && phases.length > 0) {
      const startingBasicNum = parseFloat(starting_basic);
      const finalBasicNum = parseFloat(final_basic);

      const totalIncrement = phases.reduce((sum, phase) => {
        const years = parseInt(phase.years || 0);
        const increment = parseFloat(phase.annual_increment || 0);
        return sum + years * increment;
      }, 0);

      const calculatedFinalBasic = startingBasicNum + totalIncrement;
      const difference = Math.abs(calculatedFinalBasic - finalBasicNum);

      // Allow small rounding differences (±1)
      if (difference > 1) {
        return res.status(400).json({
          success: false,
          message: `Validation Error: Phase amounts sum to ${calculatedFinalBasic.toFixed(
            2,
          )}, but final basic is ${finalBasicNum.toFixed(
            2,
          )}. Difference: ${difference.toFixed(
            2,
          )}. Please adjust phase increments or final basic.`,
        });
      }
    }
    await connection.beginTransaction();

    // Update salary scale
    await connection.query(
      `UPDATE salary_scale 
       SET code = ?, starting_basic = ?, max_years = ?, final_basic = ?, 
           effective_from = ?, effective_to = ?, has_class_progression = ?
       WHERE id = ?`,
      [
        code,
        starting_basic,
        max_years,
        final_basic,
        effective_from,
        effective_to,
        has_class_progression ? 1 : 0,
        id,
      ],
    );

    // Delete old phases
    await connection.query(
      "DELETE FROM salary_increment_phase WHERE fk_salary_scale_id = ?",
      [id],
    );

    // Insert new phases
    if (phases && phases.length > 0) {
      const phaseValues = phases.map((p) => [
        id,
        p.phase_order,
        p.years,
        p.annual_increment,
      ]);

      await connection.query(
        `INSERT INTO salary_increment_phase (fk_salary_scale_id, phase_order, years, annual_increment)
         VALUES ?`,
        [phaseValues],
      );
    }

    // Delete old class progression
    await connection.query(
      "DELETE FROM salary_scale_class_progression WHERE fk_salary_scale_id = ?",
      [id],
    );

    // Insert new class progression
    if (
      has_class_progression &&
      class_progression &&
      class_progression.length > 0
    ) {
      const progressionValues = class_progression.map((cp) => [
        id,
        cp.fk_job_class_id,
        cp.from_step,
        cp.to_step,
        cp.starting_basic,
        cp.final_basic,
      ]);

      await connection.query(
        `INSERT INTO salary_scale_class_progression (fk_salary_scale_id, fk_job_class_id, from_step, to_step, starting_basic, final_basic)
         VALUES ?`,
        [progressionValues],
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "Salary scale updated successfully",
    });
  } catch (error) {
    await connection.rollback();
    console.error("Error updating salary scale:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update salary scale",
      error: error.message,
    });
  } finally {
    connection.release();
  }
};

// Delete salary scale
export const deleteSalaryScale = async (req, res) => {
  const { id } = req.params;

  try {
    // Check if salary scale is in use
    const [usage] = await pool.query(
      "SELECT COUNT(*) as count FROM job_role_class WHERE fk_salary_scale_id = ?",
      [id],
    );

    if (usage[0].count > 0) {
      return res.status(400).json({
        success: false,
        message: "Cannot delete salary scale that is assigned to job roles",
      });
    }

    await pool.query("DELETE FROM salary_scale WHERE id = ?", [id]);

    res.json({
      success: true,
      message: "Salary scale deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting salary scale:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete salary scale",
      error: error.message,
    });
  }
};

// ==================== Job Classes ====================

// Get all job classes
export const getAllJobClasses = async (req, res) => {
  try {
    const [classes] = await pool.query(`
      SELECT 
        jc.*,
        COUNT(DISTINCT jrc.id) as assigned_roles
      FROM job_class jc
      LEFT JOIN job_role_class jrc ON jc.id = jrc.fk_job_class_id
      GROUP BY jc.id
      ORDER BY jc.hierarchy_order
    `);

    res.json({
      success: true,
      data: classes,
    });
  } catch (error) {
    console.error("Error fetching job classes:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch job classes",
      error: error.message,
    });
  }
};

// Create job class
export const createJobClass = async (req, res) => {
  const {
    class_code,
    hierarchy_order,
    requires_efficiency_bar,
    eb_level,
    eb_eligible_period_years,
    eb_grace_period_years,
    blocks_increment_if_failed,
  } = req.body;

  try {
    const [result] = await pool.query(
      `INSERT INTO job_class (
        class_code, 
        hierarchy_order,
        requires_efficiency_bar,
        eb_level,
        eb_eligible_period_years,
        eb_grace_period_years,
        blocks_increment_if_failed
      )
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        class_code,
        hierarchy_order,
        requires_efficiency_bar ? 1 : 0,
        eb_level || null,
        eb_eligible_period_years || null,
        eb_grace_period_years || null,
        blocks_increment_if_failed ? 1 : 0,
      ],
    );

    res.status(201).json({
      success: true,
      message: "Job class created successfully",
      data: { id: result.insertId },
    });
  } catch (error) {
    console.error("Error creating job class:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create job class",
      error: error.message,
    });
  }
};

// Update job class
export const updateJobClass = async (req, res) => {
  const { id } = req.params;
  const {
    class_code,
    hierarchy_order,
    requires_efficiency_bar,
    eb_level,
    eb_eligible_period_years,
    eb_grace_period_years,
    blocks_increment_if_failed,
  } = req.body;

  try {
    await pool.query(
      `UPDATE job_class 
       SET class_code = ?, 
           hierarchy_order = ?,
           requires_efficiency_bar = ?,
           eb_level = ?,
           eb_eligible_period_years = ?,
           eb_grace_period_years = ?,
           blocks_increment_if_failed = ?
       WHERE id = ?`,
      [
        class_code,
        hierarchy_order,
        requires_efficiency_bar ? 1 : 0,
        eb_level || null,
        eb_eligible_period_years || null,
        eb_grace_period_years || null,
        blocks_increment_if_failed ? 1 : 0,
        id,
      ],
    );

    res.json({
      success: true,
      message: "Job class updated successfully",
    });
  } catch (error) {
    console.error("Error updating job class:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update job class",
      error: error.message,
    });
  }
};

// Delete job class
export const deleteJobClass = async (req, res) => {
  const { id } = req.params;

  try {
    // Check if job class is in use
    const [usage] = await pool.query(
      "SELECT COUNT(*) as count FROM job_role_class WHERE fk_job_class_id = ?",
      [id],
    );

    if (usage[0].count > 0) {
      return res.status(400).json({
        success: false,
        message: "Cannot delete job class that is assigned to job roles",
      });
    }

    await pool.query("DELETE FROM job_class WHERE id = ?", [id]);

    res.json({
      success: true,
      message: "Job class deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting job class:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete job class",
      error: error.message,
    });
  }
};

// ==================== Job Role Class Assignments ====================

// Get all job role class assignments
export const getAllJobRoleClasses = async (req, res) => {
  try {
    const [assignments] = await pool.query(`
      SELECT 
        jrc.*,
        jr.name as job_role_name,
        jc.class_code,
        ss.code as salary_code,
        ss.starting_basic,
        ss.final_basic
      FROM job_role_class jrc
      INNER JOIN job_role jr ON jrc.fk_job_role_id = jr.id
      INNER JOIN job_class jc ON jrc.fk_job_class_id = jc.id
      INNER JOIN salary_scale ss ON jrc.fk_salary_scale_id = ss.id
      ORDER BY jr.name, jc.hierarchy_order
    `);

    res.json({
      success: true,
      data: assignments,
    });
  } catch (error) {
    console.error("Error fetching job role classes:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch job role class assignments",
      error: error.message,
    });
  }
};

// Create job role class assignment
export const createJobRoleClass = async (req, res) => {
  const { fk_job_role_id, fk_job_class_id, fk_salary_scale_id } = req.body;

  try {
    const [result] = await pool.query(
      `INSERT INTO job_role_class (fk_job_role_id, fk_job_class_id, fk_salary_scale_id)
       VALUES (?, ?, ?)`,
      [fk_job_role_id, fk_job_class_id, fk_salary_scale_id],
    );

    res.status(201).json({
      success: true,
      message: "Job role class assignment created successfully",
      data: { id: result.insertId },
    });
  } catch (error) {
    console.error("Error creating job role class:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create job role class assignment",
      error: error.message,
    });
  }
};

// Create multiple job role class assignments (bulk)
export const createJobRoleClassBulk = async (req, res) => {
  const { fk_job_role_id, selected_class_ids, fk_salary_scale_id } = req.body;

  if (!selected_class_ids || selected_class_ids.length === 0) {
    return res.status(400).json({
      success: false,
      message: "At least one job class must be selected",
    });
  }

  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // Prepare values for bulk insert
    const values = selected_class_ids.map((classId) => [
      fk_job_role_id,
      classId,
      fk_salary_scale_id,
    ]);

    // Bulk insert
    const [result] = await connection.query(
      `INSERT INTO job_role_class (fk_job_role_id, fk_job_class_id, fk_salary_scale_id)
       VALUES ?`,
      [values],
    );

    await connection.commit();

    res.status(201).json({
      success: true,
      message: `${selected_class_ids.length} assignment(s) created successfully`,
      data: { insertedCount: result.affectedRows },
    });
  } catch (error) {
    await connection.rollback();
    console.error("Error creating job role classes:", error);

    // Check for duplicate entry error
    if (error.code === "ER_DUP_ENTRY") {
      res.status(400).json({
        success: false,
        message: "One or more class assignments already exist for this role",
        error: error.message,
      });
    } else {
      res.status(500).json({
        success: false,
        message: "Failed to create job role class assignments",
        error: error.message,
      });
    }
  } finally {
    connection.release();
  }
};

// Update job role class assignment
export const updateJobRoleClass = async (req, res) => {
  const { id } = req.params;
  const { fk_job_role_id, fk_job_class_id, fk_salary_scale_id } = req.body;

  try {
    await pool.query(
      `UPDATE job_role_class 
       SET fk_job_role_id = ?, fk_job_class_id = ?, fk_salary_scale_id = ?
       WHERE id = ?`,
      [fk_job_role_id, fk_job_class_id, fk_salary_scale_id, id],
    );

    res.json({
      success: true,
      message: "Job role class assignment updated successfully",
    });
  } catch (error) {
    console.error("Error updating job role class:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update job role class assignment",
      error: error.message,
    });
  }
};

// Delete job role class assignment
export const deleteJobRoleClass = async (req, res) => {
  const { id } = req.params;

  try {
    await pool.query("DELETE FROM job_role_class WHERE id = ?", [id]);

    res.json({
      success: true,
      message: "Job role class assignment deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting job role class:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete job role class assignment",
      error: error.message,
    });
  }
};

// ==================== Job Roles ====================

// Get all job roles (for dropdowns)
export const getAllJobRoles = async (req, res) => {
  try {
    const [roles] = await pool.query(`
      SELECT 
        jr.*,
        COUNT(DISTINCT jrc.id) as assigned_classes
      FROM job_role jr
      LEFT JOIN job_role_class jrc ON jr.id = jrc.fk_job_role_id
      GROUP BY jr.id
      ORDER BY jr.name
    `);

    res.json({
      success: true,
      data: roles,
    });
  } catch (error) {
    console.error("Error fetching job roles:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch job roles",
      error: error.message,
    });
  }
};

// Create job role
export const createJobRole = async (req, res) => {
  const { name } = req.body;

  try {
    const [result] = await pool.query(
      `INSERT INTO job_role (name) VALUES (?)`,
      [name],
    );

    res.status(201).json({
      success: true,
      message: "Job role created successfully",
      data: { id: result.insertId },
    });
  } catch (error) {
    console.error("Error creating job role:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create job role",
      error: error.message,
    });
  }
};

// Update job role
export const updateJobRole = async (req, res) => {
  const { id } = req.params;
  const { name } = req.body;

  try {
    await pool.query(`UPDATE job_role SET name = ? WHERE id = ?`, [name, id]);

    res.json({
      success: true,
      message: "Job role updated successfully",
    });
  } catch (error) {
    console.error("Error updating job role:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update job role",
      error: error.message,
    });
  }
};

// Delete job role
export const deleteJobRole = async (req, res) => {
  const { id } = req.params;

  try {
    // Check if job role is in use
    const [usage] = await pool.query(
      "SELECT COUNT(*) as count FROM job_role_class WHERE fk_job_role_id = ?",
      [id],
    );

    if (usage[0].count > 0) {
      return res.status(400).json({
        success: false,
        message: "Cannot delete job role that is assigned to classes",
      });
    }

    await pool.query("DELETE FROM job_role WHERE id = ?", [id]);

    res.json({
      success: true,
      message: "Job role deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting job role:", error);
    res.status(500).json({
      success: false,
      message: "Failed to delete job role",
      error: error.message,
    });
  }
};

// ==================== System Settings ====================

const DEFAULT_SYSTEM_SETTINGS = {
  system_name: "Employee Management System",
  system_logo_url: null,
  system_logo_public_id: null,
  primary_color: "#0ea5e9",
  background_color: "#ffffff",
};

async function ensureSystemSettingsTable(connection) {
  await connection.query(`
    CREATE TABLE IF NOT EXISTS system_settings (
      id INT PRIMARY KEY AUTO_INCREMENT,
      setting_key VARCHAR(100) UNIQUE NOT NULL,
      setting_value TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX idx_setting_key (setting_key)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  const defaults = Object.entries(DEFAULT_SYSTEM_SETTINGS).map(
    ([setting_key, setting_value]) => [setting_key, setting_value],
  );

  await connection.query(
    `INSERT IGNORE INTO system_settings (setting_key, setting_value)
     VALUES ?`,
    [defaults],
  );
}

// Get all system settings
export const getSystemSettings = async (req, res) => {
  try {
    await ensureSystemSettingsTable(pool);
  } catch {
    // Table creation failed (e.g. insufficient DB privileges) — return defaults
    return res.json({ success: true, data: DEFAULT_SYSTEM_SETTINGS });
  }

  try {
    const [settings] = await pool.query("SELECT * FROM system_settings");
    const settingsObj = {};
    settings.forEach((s) => { settingsObj[s.setting_key] = s.setting_value; });
    res.json({ success: true, data: settingsObj });
  } catch (error) {
    console.error("Error fetching system settings:", error);
    res.status(500).json({ success: false, message: "Failed to fetch system settings", error: error.message });
  }
};

// Update system settings
export const updateSystemSettings = async (req, res) => {
  const { settings } = req.body;

  if (!settings || typeof settings !== "object") {
    return res.status(400).json({
      success: false,
      message: "Invalid settings format",
    });
  }

  const connection = await pool.getConnection();

  try {
    await ensureSystemSettingsTable(connection);
    await connection.beginTransaction();

    for (const [key, value] of Object.entries(settings)) {
      await connection.query(
        `INSERT INTO system_settings (setting_key, setting_value)
         VALUES (?, ?)
         ON DUPLICATE KEY UPDATE setting_value = ?`,
        [key, value, value],
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "System settings updated successfully",
    });
  } catch (error) {
    await connection.rollback();
    console.error("Error updating system settings:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update system settings",
      error: error.message,
    });
  } finally {
    connection.release();
  }
};
