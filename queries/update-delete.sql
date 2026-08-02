-- ============================================================
-- UPDATE and DELETE Statements - Smart Clinic Database
-- ============================================================

USE SmartClinic;

-- ============================================================
-- UPDATE STATEMENTS
-- ============================================================

-- ============================================================
-- Update 1: Update patient contact information
-- Purpose: Modify patient phone and email
-- ============================================================
UPDATE Patient
SET 
    phone = '966501234567',
    email = 'patient.new@email.com',
    address = 'New Address, New City'
WHERE patient_id = 1;

-- Verify the update
SELECT patient_id, phone, email, address FROM Patient WHERE patient_id = 1;

-- ============================================================
-- Update 2: Update appointment status to completed
-- Purpose: Mark an appointment as completed after treatment
-- ============================================================
UPDATE Appointment
SET 
    status = 'Completed',
    notes = 'Patient responded well to treatment. Follow-up recommended in 1 week.'
WHERE appointment_id = 1
AND status = 'Scheduled';

-- Verify the update
SELECT appointment_id, status, notes FROM Appointment WHERE appointment_id = 1;

-- ============================================================
-- Update 3: Update medicine stock after usage
-- Purpose: Decrease medicine stock quantity after dispensing
-- ============================================================
UPDATE Medicine
SET stock_quantity = stock_quantity - 5
WHERE medicine_id = 1
AND stock_quantity >= 5;

-- Verify the update
SELECT medicine_id, medicine_name, stock_quantity FROM Medicine WHERE medicine_id = 1;

-- ============================================================
-- Update 4: Update doctor's years of experience
-- Purpose: Reflect doctor's career progression
-- ============================================================
UPDATE Doctor
SET years_experience = years_experience + 1
WHERE doctor_id = 1;

-- Verify the update
SELECT doctor_id, years_experience FROM Doctor WHERE doctor_id = 1;

-- ============================================================
-- Update 5: Update employee salary
-- Purpose: Grant salary increase to employees
-- ============================================================
UPDATE Employee
SET salary = salary * 1.05
WHERE employee_type = 'Doctor'
AND hire_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- Verify the update
SELECT employee_id, first_name, salary FROM Employee 
WHERE employee_type = 'Doctor' AND hire_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- ============================================================
-- Update 6: Update payment status
-- Purpose: Mark payment as completed when received
-- ============================================================
UPDATE Payment
SET 
    status = 'Paid',
    payment_date = CURDATE()
WHERE payment_id = 1
AND status IN ('Pending', 'Failed');

-- Verify the update
SELECT payment_id, status, payment_date FROM Payment WHERE payment_id = 1;

-- ============================================================
-- Update 7: Update prescription expiry
-- Purpose: Extend prescription validity if needed
-- ============================================================
UPDATE Prescription
SET expiry_date = DATE_ADD(expiry_date, INTERVAL 30 DAY)
WHERE prescription_id = 1
AND expiry_date > CURDATE();

-- Verify the update
SELECT prescription_id, date_issued, expiry_date FROM Prescription WHERE prescription_id = 1;

-- ============================================================
-- Update 8: Update department location
-- Purpose: Record department relocation
-- ============================================================
UPDATE Department
SET location = 'Building B, Floor 3, Room 301'
WHERE department_id = 1;

-- Verify the update
SELECT department_id, department_name, location FROM Department WHERE department_id = 1;

-- ============================================================
-- Update 9: Update nurse shift preference
-- Purpose: Change nurse's working shift
-- ============================================================
UPDATE Nurse
SET shift_preference = 'Night'
WHERE nurse_id = 1;

-- Verify the update
SELECT nurse_id, shift_preference FROM Nurse WHERE nurse_id = 1;

-- ============================================================
-- Update 10: Update appointment reason (reschedule reason)
-- Purpose: Record reason for appointment rescheduling
-- ============================================================
UPDATE Appointment
SET reason = 'Patient requested rescheduling - Medical emergency'
WHERE appointment_id = 2;

-- Verify the update
SELECT appointment_id, reason FROM Appointment WHERE appointment_id = 2;

-- ============================================================
-- DELETE STATEMENTS
-- ============================================================

-- ============================================================
-- Delete 1: Delete cancelled appointments (safe delete)
-- Purpose: Remove appointments that were cancelled
-- ============================================================
DELETE FROM Appointment
WHERE appointment_id = 3
AND status = 'Cancelled';

-- Verify the deletion
SELECT COUNT(*) FROM Appointment WHERE appointment_id = 3;

-- ============================================================
-- Delete 2: Delete expired prescriptions
-- Purpose: Remove prescriptions that have expired
-- ============================================================
DELETE FROM Prescription
WHERE prescription_id = 2
AND expiry_date < CURDATE();

-- Verify the deletion
SELECT COUNT(*) FROM Prescription WHERE prescription_id = 2;

-- ============================================================
-- Delete 3: Delete low-stock medicines (with backup)
-- Purpose: Remove medicines with zero or near-zero stock
-- ============================================================
-- First, check which medicines will be deleted
SELECT medicine_id, medicine_name, stock_quantity FROM Medicine
WHERE stock_quantity = 0;

-- Delete only if stock is exactly zero
DELETE FROM Medicine
WHERE medicine_id = 5
AND stock_quantity = 0;

-- Verify the deletion
SELECT COUNT(*) FROM Medicine WHERE medicine_id = 5;

-- ============================================================
-- Delete 4: Delete appointment treatment association (many-to-many)
-- Purpose: Remove a treatment from an appointment record
-- ============================================================
DELETE FROM Appointment_Treatment
WHERE appointment_id = 4
AND treatment_id = 2;

-- Verify the deletion
SELECT COUNT(*) FROM Appointment_Treatment 
WHERE appointment_id = 4 AND treatment_id = 2;

-- ============================================================
-- Delete 5: Delete prescription details
-- Purpose: Remove medicine from a specific prescription
-- ============================================================
DELETE FROM Prescription_Detail
WHERE prescription_id = 3
AND medicine_id = 4;

-- Verify the deletion
SELECT COUNT(*) FROM Prescription_Detail 
WHERE prescription_id = 3 AND medicine_id = 4;

-- ============================================================
-- Delete 6: Delete failed payment records (for audit)
-- Purpose: Remove duplicate or erroneous payment entries
-- ============================================================
DELETE FROM Payment
WHERE payment_id = 6
AND status = 'Failed'
AND payment_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Verify the deletion
SELECT COUNT(*) FROM Payment WHERE payment_id = 6;

-- ============================================================
-- Delete 7: Delete no-show appointments after archive
-- Purpose: Clean up old no-show appointment records
-- ============================================================
DELETE FROM Appointment
WHERE appointment_id = 7
AND status = 'No-Show'
AND appointment_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Verify the deletion
SELECT COUNT(*) FROM Appointment WHERE appointment_id = 7;

-- ============================================================
-- Delete 8: Delete receptionist record (with cascade)
-- Purpose: Remove employee and associated specialization
-- Note: Due to ON DELETE CASCADE, this deletes from Receptionist table
-- ============================================================
DELETE FROM Employee
WHERE employee_id = 8
AND employee_type = 'Receptionist';

-- Verify the deletion
SELECT COUNT(*) FROM Employee WHERE employee_id = 8;
SELECT COUNT(*) FROM Receptionist WHERE employee_id = 8;

-- ============================================================
-- Delete 9: Delete department (safe if no head doctor assigned)
-- Purpose: Remove an empty or obsolete department
-- ============================================================
DELETE FROM Department
WHERE department_id = 4
AND head_doctor_id IS NULL;

-- Verify the deletion
SELECT COUNT(*) FROM Department WHERE department_id = 4;

-- ============================================================
-- Delete 10: Cleanup - Delete test patient and related records
-- Purpose: Remove test/dummy data from database
-- Note: This demonstrates transaction with multiple deletes
-- ============================================================
-- DELETE FROM Payment WHERE appointment_id IN (
--     SELECT appointment_id FROM Appointment WHERE patient_id = 10
-- );
-- DELETE FROM Appointment WHERE patient_id = 10;
-- DELETE FROM Prescription WHERE patient_id = 10;
-- DELETE FROM Patient WHERE patient_id = 10;

-- Verify the cleanup
SELECT COUNT(*) FROM Patient WHERE patient_id = 10;
SELECT COUNT(*) FROM Appointment WHERE patient_id = 10;

-- ============================================================
-- BATCH UPDATE EXAMPLES
-- ============================================================

-- ============================================================
-- Batch Update 1: Update all no-show patients for billing review
-- Purpose: Mark appointments for follow-up with no-show patients
-- ============================================================
UPDATE Appointment
SET notes = CONCAT(notes, ' [FOLLOW-UP: Patient No-Show - Check Status]')
WHERE status = 'No-Show'
AND notes NOT LIKE '%FOLLOW-UP%';

-- Verify batch update
SELECT COUNT(*) FROM Appointment WHERE status = 'No-Show' AND notes LIKE '%FOLLOW-UP%';

-- ============================================================
-- Batch Update 2: Reorder medicines below minimum threshold
-- Purpose: Flag medicines that need reordering
-- ============================================================
UPDATE Medicine
SET stock_quantity = reorder_level * 3
WHERE stock_quantity <= reorder_level
AND medicine_id IN (1, 2, 3, 4, 5);

-- Verify batch update
SELECT medicine_id, medicine_name, stock_quantity, reorder_level FROM Medicine
WHERE stock_quantity <= reorder_level * 4;

-- ============================================================
-- CONDITIONAL DELETE EXAMPLE
-- Purpose: Clean up old payment records safely
-- ============================================================
-- Before deletion - view records to be deleted
SELECT * FROM Payment
WHERE status = 'Failed'
AND payment_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY)
LIMIT 5;

-- Safe delete with condition
DELETE FROM Payment
WHERE status = 'Failed'
AND payment_date < DATE_SUB(CURDATE(), INTERVAL 90 DAY);

-- Verify deletion
SELECT COUNT(*) FROM Payment WHERE status = 'Failed';

-- ============================================================
-- UNDO/ROLLBACK EXAMPLE (for transaction management)
-- Purpose: Show how to safely update with rollback capability
-- ============================================================
-- START TRANSACTION;
-- UPDATE Doctor SET years_experience = years_experience - 1 WHERE doctor_id = 1;
-- ROLLBACK;  -- Undo changes

-- OR if successful:
-- COMMIT;  -- Save changes

-- ============================================================
-- NOTE ON FOREIGN KEY CONSTRAINTS
-- ============================================================
-- Before deleting a doctor, appointments referencing that doctor
-- will be affected by the foreign key constraint.
-- To safely delete, use:
-- 1. Delete dependent records first (Appointment, Payment, etc.)
-- 2. Then delete the main record (Doctor, Employee)
-- 3. Or use ON DELETE CASCADE if configured
-- ============================================================
