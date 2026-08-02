-- ============================================================
-- Nested Queries (Subqueries) - Smart Clinic Database
-- ============================================================

USE SmartClinic;

-- ============================================================
-- Query 1: Find doctors with more than average appointments
-- Purpose: Identify doctors who handle more appointments
--          than the clinic average
-- ============================================================
SELECT 
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctor d
INNER JOIN Employee e ON d.employee_id = e.employee_id
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, e.first_name, e.last_name, d.specialization
HAVING COUNT(a.appointment_id) > 
    (SELECT AVG(appointment_count) FROM 
        (SELECT COUNT(appointment_id) AS appointment_count 
         FROM Appointment 
         GROUP BY doctor_id) AS avg_table)
ORDER BY total_appointments DESC;

-- ============================================================
-- Query 2: Get patients who have paid all their appointments
-- Purpose: Find patients with fully paid appointment records
-- ============================================================
SELECT 
    DISTINCT p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.phone,
    p.email
FROM Patient p
WHERE p.patient_id IN 
    (SELECT a.patient_id 
     FROM Appointment a 
     WHERE a.appointment_id IN 
        (SELECT py.appointment_id 
         FROM Payment py 
         WHERE py.status = 'Paid'))
ORDER BY p.patient_id;

-- ============================================================
-- Query 3: Find patients with pending or unpaid appointments
-- Purpose: Identify patients who have unpaid medical bills
-- ============================================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.email,
    p.phone,
    a.appointment_id,
    a.appointment_date,
    py.amount,
    py.status
FROM Patient p
INNER JOIN Appointment a ON p.patient_id = a.patient_id
INNER JOIN Payment py ON a.appointment_id = py.appointment_id
WHERE py.status != 'Paid'
    AND py.appointment_id IN 
        (SELECT appointment_id 
         FROM Payment 
         WHERE status IN ('Pending', 'Failed'))
ORDER BY p.patient_id;

-- ============================================================
-- Query 4: Get medicines frequently prescribed with specific treatment
-- Purpose: Find medicines commonly used with a particular treatment
-- ============================================================
SELECT 
    m.medicine_id,
    m.medicine_name,
    m.formula,
    COUNT(pd.prescription_detail_id) AS times_prescribed
FROM Medicine m
INNER JOIN Prescription_Detail pd ON m.medicine_id = pd.medicine_id
WHERE m.medicine_id IN 
    (SELECT pd.medicine_id 
     FROM Prescription_Detail pd
     INNER JOIN Prescription pr ON pd.prescription_id = pr.prescription_id
     INNER JOIN Appointment a ON pr.patient_id = a.patient_id
     AND YEAR(pr.date_issued) = YEAR(a.appointment_date)
     INNER JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
     INNER JOIN Treatment t ON at.treatment_id = t.treatment_id
     WHERE t.treatment_name LIKE '%Consultation%')
GROUP BY m.medicine_id, m.medicine_name, m.formula
ORDER BY times_prescribed DESC;

-- ============================================================
-- Query 5: Find highest paid doctors in each specialization
-- Purpose: Identify top earners within each medical specialty
-- ============================================================
SELECT 
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    e.salary
FROM Doctor d
INNER JOIN Employee e ON d.employee_id = e.employee_id
WHERE e.salary = 
    (SELECT MAX(e2.salary)
     FROM Doctor d2
     INNER JOIN Employee e2 ON d2.employee_id = e2.employee_id
     WHERE d2.specialization = d.specialization)
ORDER BY d.specialization, e.salary DESC;

-- ============================================================
-- Query 6: Get appointments where multiple treatments were prescribed
-- Purpose: Find complex appointments with multiple treatment options
-- ============================================================
SELECT 
    a.appointment_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    a.appointment_date,
    COUNT(at.treatment_id) AS treatment_count
FROM Appointment a
INNER JOIN Patient p ON a.patient_id = p.patient_id
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Employee e ON d.employee_id = e.employee_id
INNER JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
WHERE a.appointment_id IN 
    (SELECT appointment_id 
     FROM Appointment_Treatment 
     GROUP BY appointment_id 
     HAVING COUNT(treatment_id) > 1)
GROUP BY a.appointment_id, p.first_name, p.last_name, 
         e.first_name, e.last_name, a.appointment_date
ORDER BY treatment_count DESC;

-- ============================================================
-- Query 7: Find patients who haven't had appointments recently
-- Purpose: Identify patients not seen in the last 3 months
-- ============================================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.email,
    p.phone,
    MAX(a.appointment_date) AS last_appointment_date
FROM Patient p
LEFT JOIN Appointment a ON p.patient_id = a.patient_id
WHERE p.patient_id NOT IN 
    (SELECT DISTINCT patient_id 
     FROM Appointment 
     WHERE appointment_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH))
GROUP BY p.patient_id, p.first_name, p.last_name, p.email, p.phone
ORDER BY last_appointment_date;

-- ============================================================
-- Query 8: Get prescriptions with medicines below minimum stock
-- Purpose: Find medicines that need reordering based on prescriptions
-- ============================================================
SELECT 
    m.medicine_id,
    m.medicine_name,
    m.stock_quantity,
    m.reorder_level,
    pr.prescription_id,
    pr.date_issued,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name
FROM Medicine m
INNER JOIN Prescription_Detail pd ON m.medicine_id = pd.medicine_id
INNER JOIN Prescription pr ON pd.prescription_id = pr.prescription_id
INNER JOIN Patient p ON pr.patient_id = p.patient_id
WHERE m.medicine_id IN 
    (SELECT medicine_id 
     FROM Medicine 
     WHERE stock_quantity <= reorder_level)
ORDER BY m.medicine_name, pr.date_issued DESC;

-- ============================================================
-- Query 9: Find doctors with specialized treatment expertise
-- Purpose: Identify doctors providing specific treatments
-- ============================================================
SELECT 
    d.doctor_id,
    CONCAT(e.first_name, ' ', e.last_name) AS doctor_name,
    d.specialization,
    COUNT(DISTINCT at.treatment_id) AS treatment_count
FROM Doctor d
INNER JOIN Employee e ON d.employee_id = e.employee_id
INNER JOIN Appointment a ON d.doctor_id = a.doctor_id
INNER JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
WHERE d.doctor_id IN 
    (SELECT a2.doctor_id 
     FROM Appointment a2
     INNER JOIN Appointment_Treatment at2 ON a2.appointment_id = at2.appointment_id
     INNER JOIN Treatment t2 ON at2.treatment_id = t2.treatment_id
     WHERE t2.treatment_name LIKE '%Surgery%')
GROUP BY d.doctor_id, e.first_name, e.last_name, d.specialization
ORDER BY treatment_count DESC;

-- ============================================================
-- Query 10: Find patients with expensive treatment history
-- Purpose: Identify high-cost patients for billing purposes
-- ============================================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    SUM(t.cost) AS total_treatment_cost,
    AVG(t.cost) AS average_treatment_cost
FROM Patient p
INNER JOIN Appointment a ON p.patient_id = a.patient_id
INNER JOIN Appointment_Treatment at ON a.appointment_id = at.appointment_id
INNER JOIN Treatment t ON at.treatment_id = t.treatment_id
WHERE p.patient_id IN 
    (SELECT a2.patient_id 
     FROM Appointment a2
     INNER JOIN Appointment_Treatment at2 ON a2.appointment_id = at2.appointment_id
     INNER JOIN Treatment t2 ON at2.treatment_id = t2.treatment_id
     GROUP BY a2.patient_id
     HAVING SUM(t2.cost) > 5000)
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_treatment_cost DESC;
