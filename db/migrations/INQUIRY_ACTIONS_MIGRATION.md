# Database Migration: Add Inquiry Action Controls

## Description

This migration adds three new fields to the `employee_career` table to provide granular control over employee restrictions during active inquiries.

## New Fields

1. **hold_increment** (TINYINT): Prevents salary increments
2. **hold_salary** (TINYINT): Suspends salary payments
3. **disable_employment** (TINYINT): Suspends employment status

## How to Run

### Option 1: Using MySQL Command Line

```bash
mysql -u root -p project_ems < backend/db/migrations/add_inquiry_action_fields.sql
```

### Option 2: Using MySQL Workbench

1. Open MySQL Workbench
2. Connect to your database
3. Open the file: `backend/db/migrations/add_inquiry_action_fields.sql`
4. Execute the SQL script

### Option 3: Manual Execution

Run the following SQL commands in your MySQL client:

```sql
USE project_ems;

ALTER TABLE employee_career
ADD COLUMN IF NOT EXISTS hold_increment TINYINT(1) DEFAULT 0 COMMENT 'Prevents salary increments when set to 1',
ADD COLUMN IF NOT EXISTS hold_salary TINYINT(1) DEFAULT 0 COMMENT 'Suspends salary payments when set to 1',
ADD COLUMN IF NOT EXISTS disable_employment TINYINT(1) DEFAULT 0 COMMENT 'Suspends employment status when set to 1';

UPDATE employee_career
SET hold_increment = 0,
    hold_salary = 0,
    disable_employment = 0
WHERE hold_increment IS NULL
   OR hold_salary IS NULL
   OR disable_employment IS NULL;
```

## Verification

After running the migration, verify the columns were added:

```sql
DESCRIBE employee_career;
```

You should see three new columns:

- hold_increment (tinyint(1), default 0)
- hold_salary (tinyint(1), default 0)
- disable_employment (tinyint(1), default 0)

## Changes Required

### Backend

✅ Updated `backend/controllers/employee.Controller.js`:

- Added three fields to UPDATE query (line ~420)
- Added three fields to INSERT query for new employees (line ~132)
- Added three fields to INSERT query for employees without career records (line ~507)

### Frontend

✅ Updated `frontend/src/components/Inquiry.jsx`:

- Added Switch import from shadcn/ui
- Updated inquiryForm state to include three new fields
- Added three switches in the dialog (visible only when inquiry is active)
- Updated handleSaveInquiry to include new fields in payload
- Updated handleAddInquiry to load new fields from employee data
- Added new fields to employee data fetching

## Testing

After running the migration:

1. Open the Inquiry management page
2. Add or edit an inquiry for an employee
3. Toggle the three switches:
   - Hold Increment
   - Hold Salary
   - Disable Employment
4. Save the inquiry
5. Verify the values are saved in the database

## Rollback (if needed)

```sql
USE project_ems;

ALTER TABLE employee_career
DROP COLUMN IF EXISTS hold_increment,
DROP COLUMN IF EXISTS hold_salary,
DROP COLUMN IF EXISTS disable_employment;
```
