-- ============================================================
-- SELECT Queries - Smart Clinic Database
-- ============================================================

USE SmartClinic;

-- ============================================================
-- Query 1: Retrieve all patients
-- Purpose: Get a complete list of all patients with their details
-- ============================================================
SELECT 
    patient_id,
    CONCAT(first_name, ' ', last_name) AS patient_name,
    date_of_birth,
    gender,
    phone,
    email,
    blood_type
FROM Patient
ORDER BY patient_id;

-- ============================================================
-- Query 2: Get all doctors with their specialization
-- Purpose: Display doctor information and their specialization
-- ============================================================
SELECT 
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    d.license_number,
    d.years_experience,
    e.email,
    e.phone
FROM Doctor d
JOIN Employee e ON d.employee_id = e.employee_id
ORDER BY d.specialization, e.last_name;

-- ============================================================
-- Query 3: List all scheduled appointments
-- Purpose: Find all upcoming appointments that are scheduled
-- ============================================================
SELECT 
    a.appointment_id,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    a.appointment_date,
    a.reason,
    a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Employee e ON d.employee_id = e.employee_id
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date;

-- ============================================================
-- Query 4: Get all medicines in inventory
-- Purpose: View all available medicines with their details
-- ============================================================
SELECT 
    medicine_id,
    medicine_name,
    formula,
    dosage,
    manufacturer,
    stock_quantity,
    reorder_level,
    price
FROM Medicine
ORDER BY medicine_name;

-- ============================================================
-- Query 5: List all prescriptions issued in the last 30 days
-- Purpose: Track recent prescriptions for audit purposes
-- ============================================================
SELECT 
    pr.prescription_id,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    pr.date_issued,
    pr.expiry_date,
    pr.notes
FROM Prescription pr
JOIN Patient p ON pr.patient_id = p.patient_id
JOIN Doctor d ON pr.doctor_id = d.doctor_id
JOIN Employee e ON d.employee_id = e.employee_id
WHERE DATE(pr.date_issued) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY pr.date_issued DESC;

-- ============================================================
-- Query 6: Get patient payment history
-- Purpose: Review all payments made by a specific patient
-- ============================================================
SELECT 
    payment_id,
    appointment_id,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    amount,
    payment_date,
    payment_method,
    status
FROM Payment py
JOIN Appointment a ON py.appointment_id = a.appointment_id
JOIN Patient p ON a.patient_id = p.patient_id
ORDER BY payment_date DESC;

-- ============================================================
-- Query 7: Find all completed appointments
-- Purpose: View appointments that have been completed
-- ============================================================
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    a.appointment_date,
    a.reason,
    a.notes,
    a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Employee e ON d.employee_id = e.employee_id
WHERE a.status = 'Completed'
ORDER BY a.appointment_date DESC;

-- ============================================================
-- Query 8: List all employees and their roles
-- Purpose: View all clinic staff with their positions
-- ============================================================
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    employee_type,
    email,
    phone,
    hire_date,
    salary
FROM Employee
ORDER BY hire_date DESC;

-- ============================================================
-- Query 9: Get treatments available at the clinic
-- Purpose: Display all treatment options offered
-- ============================================================
SELECT 
    treatment_id,
    treatment_name,
    description,
    estimated_duration_hours,
    cost
FROM Treatment
ORDER BY treatment_name;

-- ============================================================
-- Query 10: Find patients by blood type
-- Purpose: Locate patients with a specific blood type
-- ============================================================
SELECT 
    patient_id,
    CONCAT(first_name, ' ', last_name) AS patient_name,
    blood_type,
    date_of_birth,
    phone,
    emergency_contact_name
FROM Patient
WHERE blood_type IS NOT NULL
ORDER BY blood_type, last_name;
