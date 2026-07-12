-- Add system settings table to store application-wide configuration
CREATE TABLE IF NOT EXISTS system_settings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  setting_key VARCHAR(100) UNIQUE NOT NULL,
  setting_value TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_setting_key (setting_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default system settings
INSERT INTO system_settings (setting_key, setting_value) VALUES
('system_name', 'Employee Management System'),
('system_logo_url', NULL),
('system_logo_public_id', NULL),
('primary_color', '#0ea5e9'),
('background_color', '#ffffff')
ON DUPLICATE KEY UPDATE setting_key = setting_key;
