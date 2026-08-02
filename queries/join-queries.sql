-- ============================================================
-- JOIN Queries - Smart Clinic Database
-- ============================================================

USE SmartClinic;

-- ============================================================
-- Query 1: Get appointment details with patient and doctor info
-- Purpose: Show complete appointment information combining
--          patient, doctor, and appointment data
-- ============================================================
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.phone AS patient_phone,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.reason,
    a.status,
    a.notes
FROM Appointment a
INNER JOIN Patient p ON a.patient_id = p.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id
ORDER BY a.appointment_date DESC;

-- ============================================================
-- Query 2: Get all appointments with treatments prescribed
-- Purpose: Combine appointment and treatment information
--          through the junction table
-- ============================================================
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    a.appointment_date,
    t.treatment_name,
    t.description,
    t.estimated_duration_hours,
    t.cost
FROM Appointment a
INNER JOIN Patient p ON a.patient_id = p.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id
INNER JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
INNER JOIN Treatment t ON at.treatment_id = t.treatment_id
ORDER BY a.appointment_date DESC;

-- ============================================================
-- Query 3: Get prescription details with medicine information
-- Purpose: Show complete prescription including medicines
--          prescribed through the detail table
-- ============================================================
SELECT 
    pr.prescription_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    pr.date_issued,
    m.medicine_name,
    m.formula,
    pd.dosage,
    pd.frequency,
    pd.duration_days,
    m.price
FROM Prescription pr
INNER JOIN Patient p ON pr.patient_id = p.patient_id
INNER JOIN Doctor d ON pr.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id
INNER JOIN Prescription_Detail pd ON pr.prescription_id = pd.prescription_id
INNER JOIN Medicine m ON pd.medicine_id = m.medicine_id
ORDER BY pr.date_issued DESC;

-- ============================================================
-- Query 4: Get departments with their head doctor information
-- Purpose: Show department details along with head doctor
--          using LEFT JOIN to include departments without head doctor
-- ============================================================
SELECT 
    dp.department_id,
    dp.department_name,
    dp.location,
    CONCAT(e.first_name, ' ', e.last_name) AS head_doctor_name,
    d.specialization,
    e.email,
    e.phone
FROM Department dp
LEFT JOIN Doctor d ON dp.head_doctor_id = d.doctor_id
LEFT JOIN Employee e ON d.employee_id = e.employee_id
ORDER BY dp.department_name;

-- ============================================================
-- Query 5: Get payment information with appointment and patient details
-- Purpose: Show complete payment history with related information
-- ============================================================
SELECT 
    py.payment_id,
    py.amount,
    py.payment_date,
    py.payment_method,
    py.status,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    a.appointment_date,
    a.reason
FROM Payment py
INNER JOIN Appointment a ON py.appointment_id = a.appointment_id
INNER JOIN Patient p ON a.patient_id = p.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id
ORDER BY py.payment_date DESC;

-- ============================================================
-- Query 6: Get nurse and doctor employee information
-- Purpose: Combine employee base info with specialized info
--          for nurses and doctors
-- ============================================================
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    'Doctor' AS role,
    d.specialization AS specialization,
    d.license_number,
    d.years_experience,
    e.email,
    e.phone,
    e.hire_date,
    e.salary
FROM Employee e
INNER JOIN Doctor d ON e.employee_id = d.employee_id
UNION ALL
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    'Nurse' AS role,
    n.certification AS specialization,
    NULL AS license_number,
    NULL AS years_experience,
    e.email,
    e.phone,
    e.hire_date,
    e.salary
FROM Employee e
INNER JOIN Nurse n ON e.employee_id = n.employee_id
ORDER BY employee_name;

-- ============================================================
-- Query 7: Get all patients with their recent appointments
-- Purpose: Show patient information with their last 3 appointments
-- ============================================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender,
    p.blood_type,
    a.appointment_id,
    a.appointment_date,
    a.status,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization
FROM Patient p
LEFT JOIN Appointment a ON p.patient_id = a.patient_id
LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
LEFT JOIN Employee e ON d.employee_id = e.employee_id
ORDER BY p.patient_id, a.appointment_date DESC;

-- ============================================================
-- Query 8: Get medicine availability through prescriptions
-- Purpose: Show medicines and the prescriptions they're in
-- ============================================================
SELECT 
    m.medicine_id,
    m.medicine_name,
    m.formula,
    m.stock_quantity,
    COUNT(pd.prescription_detail_id) AS times_prescribed,
    m.price,
    (m.stock_quantity * m.price) AS total_stock_value
FROM Medicine m
LEFT JOIN Prescription_Detail pd ON m.medicine_id = pd.medicine_id
GROUP BY m.medicine_id, m.medicine_name, m.formula, m.stock_quantity, m.price
ORDER BY times_prescribed DESC;

-- ============================================================
-- Query 9: Get doctor's appointment and treatment information
-- Purpose: Show what treatments each doctor is providing
-- ============================================================
SELECT 
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date,
    t.treatment_name,
    t.cost
FROM Doctor d
INNER JOIN Employee e ON d.employee_id = e.employee_id
INNER JOIN Appointment a ON d.doctor_id = a.doctor_id
INNER JOIN Patient p ON a.patient_id = p.patient_id
LEFT JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
LEFT JOIN Treatment t ON at.treatment_id = t.treatment_id
ORDER BY d.doctor_id, a.appointment_date DESC;

-- ============================================================
-- Query 10: Get insurance and payment information
-- Purpose: Show patient insurance details with payment history
-- ============================================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.insurance_number,
    py.payment_id,
    py.amount,
    py.payment_date,
    py.payment_method,
    py.status,
    a.appointment_date,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name
FROM Patient p
LEFT JOIN Appointment a ON p.patient_id = a.patient_id
LEFT JOIN Payment py ON a.appointment_id = py.appointment_id
LEFT JOIN Doctor d ON a.doctor_id = d.doctor_id
LEFT JOIN Employee e ON d.employee_id = e.employee_id
WHERE p.insurance_number IS NOT NULL
ORDER BY p.patient_id, py.payment_date DESC;
