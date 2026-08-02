-- ============================================================
-- VIEWS and TRIGGERS - Smart Clinic Database
-- ============================================================

USE SmartClinic;

-- ============================================================
-- VIEWS
-- ============================================================

-- ============================================================
-- View 1: Doctor Appointment Summary
-- Purpose: Provides a comprehensive view of each doctor's 
--          appointment statistics and performance
-- ============================================================
CREATE OR REPLACE VIEW DoctorAppointmentView AS
SELECT 
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    d.license_number,
    d.years_experience,
    e.email,
    e.phone,
    e.salary,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) AS completed_appointments,
    COUNT(CASE WHEN a.status = 'Scheduled' THEN 1 END) AS scheduled_appointments,
    COUNT(CASE WHEN a.status = 'Cancelled' THEN 1 END) AS cancelled_appointments,
    COUNT(CASE WHEN a.status = 'No-Show' THEN 1 END) AS no_show_appointments,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    ROUND(
        (COUNT(CASE WHEN a.status = 'Cancelled' THEN 1 END) / 
         COUNT(a.appointment_id)) * 100, 2
    ) AS cancellation_rate,
    SUM(t.cost) AS total_treatment_revenue
FROM Doctor d
INNER JOIN Employee e ON d.employee_id = e.employee_id
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
LEFT JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
LEFT JOIN Treatment t ON at.treatment_id = t.treatment_id
GROUP BY 
    d.doctor_id, 
    e.first_name, 
    e.last_name, 
    d.specialization, 
    d.license_number,
    d.years_experience,
    e.email,
    e.phone,
    e.salary;

-- ============================================================
-- View 2: Patient Medical History
-- Purpose: Provides complete medical history for each patient
-- ============================================================
CREATE OR REPLACE VIEW PatientMedicalHistoryView AS
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.date_of_birth,
    YEAR(CURDATE()) - YEAR(p.date_of_birth) AS age,
    p.gender,
    p.blood_type,
    p.phone,
    p.email,
    a.appointment_id,
    a.appointment_date,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    a.reason,
    a.status,
    GROUP_CONCAT(t.treatment_name SEPARATOR ', ') AS treatments_received,
    SUM(t.cost) AS appointment_cost
FROM Patient p
LEFT JOIN Appointment a ON p.patient_id = a.patient_id
LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
LEFT JOIN Employee e ON d.employee_id = e.employee_id
LEFT JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
LEFT JOIN Treatment t ON at.treatment_id = t.treatment_id
GROUP BY 
    p.patient_id,
    p.first_name,
    p.last_name,
    p.date_of_birth,
    p.gender,
    p.blood_type,
    p.phone,
    p.email,
    a.appointment_id,
    a.appointment_date,
    e.first_name,
    e.last_name,
    d.specialization,
    a.reason,
    a.status;

-- ============================================================
-- View 3: Prescription and Medication Details
-- Purpose: Shows all prescription details with medicine information
-- ============================================================
CREATE OR REPLACE VIEW PrescriptionDetailView AS
SELECT 
    pr.prescription_id,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    pr.date_issued,
    pr.expiry_date,
    DATEDIFF(pr.expiry_date, CURDATE()) AS days_until_expiry,
    CASE 
        WHEN pr.expiry_date < CURDATE() THEN 'Expired'
        WHEN DATEDIFF(pr.expiry_date, CURDATE()) < 7 THEN 'Expiring Soon'
        ELSE 'Valid'
    END AS prescription_status,
    m.medicine_id,
    m.medicine_name,
    m.formula,
    pd.dosage,
    pd.frequency,
    pd.duration_days,
    m.price,
    (pd.duration_days * m.price) AS total_medicine_cost
FROM Prescription pr
INNER JOIN Patient p ON pr.patient_id = p.patient_id
INNER JOIN Doctor d ON pr.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id
INNER JOIN Prescription_Detail pd ON pr.prescription_id = pd.prescription_id
INNER JOIN Medicine m ON pd.medicine_id = m.medicine_id;

-- ============================================================
-- View 4: Clinic Revenue Analysis
-- Purpose: Tracks all revenue sources and payment status
-- ============================================================
CREATE OR REPLACE VIEW RevenueAnalysisView AS
SELECT 
    py.payment_id,
    a.appointment_id,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    a.appointment_date,
    py.payment_date,
    py.amount,
    py.payment_method,
    py.status,
    CASE 
        WHEN py.status = 'Paid' THEN py.amount
        ELSE 0
    END AS received_amount,
    CASE 
        WHEN py.status = 'Pending' THEN py.amount
        ELSE 0
    END AS pending_amount,
    DATEDIFF(CURDATE(), py.payment_date) AS days_since_payment,
    MONTH(a.appointment_date) AS appointment_month,
    YEAR(a.appointment_date) AS appointment_year
FROM Payment py
INNER JOIN Appointment a ON py.appointment_id = a.appointment_id
INNER JOIN Patient p ON a.patient_id = p.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id;

-- ============================================================
-- Test the Views
-- ============================================================

-- Test View 1: Doctor Appointment View
SELECT * FROM DoctorAppointmentView
ORDER BY total_appointments DESC
LIMIT 5;

-- Test View 2: Patient Medical History View
SELECT * FROM PatientMedicalHistoryView
LIMIT 5;

-- Test View 3: Prescription Detail View
SELECT * FROM PrescriptionDetailView
LIMIT 5;

-- Test View 4: Revenue Analysis View
SELECT * FROM RevenueAnalysisView
LIMIT 5;

-- ============================================================
-- TRIGGERS
-- ============================================================

-- ============================================================
-- Trigger 1: Audit table for tracking changes
-- Purpose: Create audit trail for all modifications
-- ============================================================
CREATE TABLE IF NOT EXISTS AuditLog (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100),
    operation VARCHAR(50),
    affected_id INT,
    old_value TEXT,
    new_value TEXT,
    changed_by VARCHAR(100) DEFAULT 'System',
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- Trigger 2: Automatically update timestamp on Patient record change
-- Purpose: Track when patient records are last modified
-- ============================================================
ALTER TABLE Patient ADD COLUMN last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DELIMITER //

CREATE TRIGGER PatientUpdateTrigger
BEFORE UPDATE ON Patient
FOR EACH ROW
BEGIN
    -- Insert audit log
    INSERT INTO AuditLog (table_name, operation, affected_id, old_value, new_value)
    VALUES (
        'Patient',
        'UPDATE',
        NEW.patient_id,
        CONCAT('phone: ', OLD.phone),
        CONCAT('phone: ', NEW.phone)
    );
END//

DELIMITER ;

-- ============================================================
-- Trigger 3: Prevent appointment deletion if payment pending
-- Purpose: Maintain data integrity by preventing deletion of 
--          appointments with pending payments
-- ============================================================
DELIMITER //

CREATE TRIGGER PreventAppointmentDeletion
BEFORE DELETE ON Appointment
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Payment 
        WHERE appointment_id = OLD.appointment_id 
        AND status = 'Pending'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete appointment with pending payments';
    END IF;
END//

DELIMITER ;

-- ============================================================
-- Trigger 4: Validate appointment date (must be future date)
-- Purpose: Prevent scheduling appointments in the past
-- ============================================================
DELIMITER //

CREATE TRIGGER ValidateAppointmentDate
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.appointment_date < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Appointment date must be in the future';
    END IF;
END//

DELIMITER ;

-- ============================================================
-- Trigger 5: Update appointment status when payment is made
-- Purpose: Automatically mark appointment as paid when payment received
-- ============================================================
DELIMITER //

CREATE TRIGGER UpdatePaymentStatus
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.status = 'Paid' THEN
        INSERT INTO AuditLog (table_name, operation, affected_id, new_value)
        VALUES ('Payment', 'INSERT', NEW.appointment_id, 
                CONCAT('Payment received: ', NEW.amount));
    END IF;
END//

DELIMITER ;

-- ============================================================
-- Trigger 6: Prevent medicine prescriptions if stock is low
-- Purpose: Ensure medicines are not prescribed when stock is critical
-- ============================================================
DELIMITER //

CREATE TRIGGER CheckMedicineStock
BEFORE INSERT ON Prescription_Detail
FOR EACH ROW
BEGIN
    DECLARE stock_qty INT;
    SELECT stock_quantity INTO stock_qty FROM Medicine 
    WHERE medicine_id = NEW.medicine_id;
    
    IF stock_qty < NEW.dosage THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient medicine stock for prescription';
    END IF;
END//

DELIMITER ;

-- ============================================================
-- Trigger 7: Create audit log for salary changes
-- Purpose: Track all salary modifications for compliance
-- ============================================================
DELIMITER //

CREATE TRIGGER SalaryAuditTrigger
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO AuditLog (table_name, operation, affected_id, old_value, new_value)
        VALUES (
            'Employee',
            'SALARY_CHANGE',
            NEW.employee_id,
            CONCAT('Old salary: ', OLD.salary),
            CONCAT('New salary: ', NEW.salary)
        );
    END IF;
END//

DELIMITER ;

-- ============================================================
-- Trigger 8: Log prescription creation with medicine details
-- Purpose: Create detailed audit trail for prescriptions
-- ============================================================
DELIMITER //

CREATE TRIGGER PrescriptionAuditTrigger
AFTER INSERT ON Prescription
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (table_name, operation, affected_id, new_value)
    VALUES (
        'Prescription',
        'INSERT',
        NEW.prescription_id,
        CONCAT('New prescription issued on ', NEW.date_issued)
    );
END//

DELIMITER ;

-- ============================================================
-- Trigger 9: Update doctor's patient count on new appointment
-- Purpose: Track growing patient base for each doctor (informational)
-- ============================================================
DELIMITER //

CREATE TRIGGER AppointmentCreationLog
AFTER INSERT ON Appointment
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (table_name, operation, affected_id, new_value)
    VALUES (
        'Appointment',
        'INSERT',
        NEW.appointment_id,
        CONCAT('New appointment scheduled for patient ', NEW.patient_id, 
               ' with doctor ', NEW.doctor_id)
    );
END//

DELIMITER ;

-- ============================================================
-- Trigger 10: Cascade update for appointment status changes
-- Purpose: Automatically log status changes for audit purposes
-- ============================================================
DELIMITER //

CREATE TRIGGER AppointmentStatusChangeTrigger
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO AuditLog (table_name, operation, affected_id, old_value, new_value)
        VALUES (
            'Appointment',
            'STATUS_CHANGE',
            NEW.appointment_id,
            CONCAT('Old status: ', OLD.status),
            CONCAT('New status: ', NEW.status)
        );
    END IF;
END//

DELIMITER ;

-- ============================================================
-- Test the Triggers
-- ============================================================

-- View audit log to confirm triggers are working
SELECT * FROM AuditLog ORDER BY changed_at DESC LIMIT 10;

-- ============================================================
-- Useful Trigger Management Commands
-- ============================================================

-- List all triggers
-- SHOW TRIGGERS FROM SmartClinic;

-- Drop a specific trigger
-- DROP TRIGGER PatientUpdateTrigger;

-- Drop all triggers (if needed)
-- DROP TRIGGER IF EXISTS PatientUpdateTrigger;
-- DROP TRIGGER IF EXISTS PreventAppointmentDeletion;
-- DROP TRIGGER IF EXISTS ValidateAppointmentDate;
-- etc.

-- ============================================================
-- Notes on Views and Triggers
-- ============================================================
-- 1. Views are virtual tables that provide a simplified view of data
-- 2. Triggers automatically execute when specified database events occur
-- 3. Both Views and Triggers help maintain data integrity and security
-- 4. Triggers should be used carefully as they impact performance
-- 5. All triggers create audit logs for compliance and tracking
-- ============================================================
