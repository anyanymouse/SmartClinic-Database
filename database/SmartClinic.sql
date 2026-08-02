-- ============================================================
-- Smart Clinic Database System
-- Complete & Verified SQL Script (FULLY FIXED & REVISED)
-- ============================================================

CREATE DATABASE IF NOT EXISTS SmartClinic;
USE SmartClinic;

-- ============================================================
-- 1. CLEAN START
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Prescription_Detail;
DROP TABLE IF EXISTS Prescription;
DROP TABLE IF EXISTS Appointment_Treatment;
DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS Medicine;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Nurse;
DROP TABLE IF EXISTS Receptionist;
DROP TABLE IF EXISTS Employee;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 2. TABLES CREATION
-- ============================================================

CREATE TABLE Employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL CHECK (salary > 0),
    employee_type ENUM('Doctor', 'Nurse', 'Receptionist') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL UNIQUE,
    specialization VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    years_experience INT DEFAULT 0 CHECK (years_experience >= 0),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE Nurse (
    nurse_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL UNIQUE,
    certification VARCHAR(100),
    shift_preference ENUM('Morning', 'Evening', 'Night', 'Rotating') DEFAULT 'Morning',
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE Receptionist (
    receptionist_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL UNIQUE,
    desk_location VARCHAR(50) DEFAULT 'Main Desk',
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    head_doctor_id INT,
    FOREIGN KEY (head_doctor_id) REFERENCES Doctor(doctor_id) ON DELETE SET NULL
);

CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    blood_type VARCHAR(5),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    insurance_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    reason VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id) ON DELETE CASCADE
);

CREATE TABLE Treatment (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    treatment_name VARCHAR(100) NOT NULL,
    description TEXT,
    cost DECIMAL(10,2) NOT NULL CHECK (cost >= 0),
    duration_minutes INT CHECK (duration_minutes > 0)
);

CREATE TABLE Appointment_Treatment (
    appointment_id INT NOT NULL,
    treatment_id INT NOT NULL,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    notes VARCHAR(255),
    PRIMARY KEY (appointment_id, treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES Treatment(treatment_id) ON DELETE CASCADE
);

CREATE TABLE Medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    description TEXT,
    manufacturer VARCHAR(100),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    expiry_date DATE
);

CREATE TABLE Prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    prescription_date DATE NOT NULL,
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id) ON DELETE CASCADE
);

CREATE TABLE Prescription_Detail (
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration_days INT NOT NULL CHECK (duration_days > 0),
    PRIMARY KEY (prescription_id, medicine_id),
    FOREIGN KEY (prescription_id) REFERENCES Prescription(prescription_id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id) ON DELETE CASCADE
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_date DATE NOT NULL,
    payment_method ENUM('Cash', 'Card', 'Insurance') NOT NULL,
    status ENUM('Pending', 'Paid', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id) ON DELETE SET NULL
);

-- ============================================================
-- 3. INSERT SAMPLE DATA
-- ============================================================

INSERT INTO Employee (first_name, last_name, email, phone, hire_date, salary, employee_type) VALUES
('Ahmad', 'Al-Rashid', 'ahmad.rashid@clinic.com', '0501111111', '2019-03-15', 25000.00, 'Doctor'),
('Sara', 'Al-Farsi', 'sara.farsi@clinic.com', '0502222222', '2020-06-01', 22000.00, 'Doctor'),
('Fatima', 'Al-Zahra', 'fatima.zahra@clinic.com', '0503333333', '2021-01-10', 12000.00, 'Nurse'),
('Omar', 'Al-Hassan', 'omar.hassan@clinic.com', '0504444444', '2021-08-20', 11000.00, 'Nurse'),
('Khalid', 'Al-Mutairi', 'khalid.mutairi@clinic.com', '0505555555', '2022-02-01', 9000.00, 'Receptionist'),
('Noor', 'Al-Sabah', 'noor.sabah@clinic.com', '0506666666', '2023-05-15', 18000.00, 'Doctor');

INSERT INTO Doctor (employee_id, specialization, license_number, years_experience) VALUES
(1, 'Cardiology', 'DOC-2019-001', 8),
(2, 'Dermatology', 'DOC-2020-002', 6),
(6, 'Pediatrics', 'DOC-2023-003', 2);

INSERT INTO Department (department_name, location, head_doctor_id) VALUES
('Cardiology Department', 'Building A - Floor 2', 1),
('Dermatology Department', 'Building A - Floor 3', 2),
('Pediatrics Department', 'Building B - Floor 1', 3);

INSERT INTO Nurse (employee_id, certification, shift_preference) VALUES
(3, 'Registered Nurse (RN)', 'Morning'),
(4, 'Licensed Practical Nurse (LPN)', 'Evening');

INSERT INTO Receptionist (employee_id, desk_location) VALUES
(5, 'Main Reception - Floor 1');

INSERT INTO Patient (first_name, last_name, date_of_birth, gender, phone, email, address, blood_type, emergency_contact_name, emergency_contact_phone, insurance_number) VALUES
('Mohammed', 'Al-Qahtani', '1985-04-12', 'Male', '0551111111', 'mohammed.q@email.com', 'Riyadh, Al-Olaya', 'O+', 'Ahmed Al-Qahtani', '0551111112', 'INS-10001'),
('Laila', 'Al-Shehri', '1990-09-23', 'Female', '0552222222', 'laila.s@email.com', 'Jeddah, Al-Hamra', 'A+', 'Sami Al-Shehri', '0552222223', 'INS-10002'),
('Yousef', 'Al-Otaibi', '1978-11-05', 'Male', '0553333333', 'yousef.o@email.com', 'Dammam, Al-Faisaliyah', 'B+', 'Fahad Al-Otaibi', '0553333334', 'INS-10003'),
('Noura', 'Al-Dosari', '2000-03-18', 'Female', '0554444444', 'noura.d@email.com', 'Riyadh, Al-Narjis', 'AB-', 'Hessa Al-Dosari', '0554444445', 'INS-10004'),
('Faisal', 'Al-Harbi', '1995-07-30', 'Male', '0555555555', 'faisal.h@email.com', 'Makkah, Al-Aziziyah', 'O-', 'Khalid Al-Harbi', '0555555556', 'INS-10005'),
('Amina', 'Al-Bedah', '1988-12-10', 'Female', '0556666666', 'amina.b@email.com', 'Riyadh, Al-Sahafah', 'A-', 'Salman Al-Bedah', '0556666667', 'INS-10006');

INSERT INTO Appointment (patient_id, doctor_id, appointment_date, status, reason, notes) VALUES
(1, 1, '2026-07-25 09:00:00', 'Completed', 'Chest pain and shortness of breath', 'Patient has history of hypertension'),
(2, 2, '2026-07-26 10:30:00', 'Completed', 'Skin rash on arms', 'Prescribed topical cream'),
(3, 1, '2026-07-28 14:00:00', 'Scheduled', 'Annual heart checkup', 'Bring previous ECG reports'),
(4, 3, '2026-07-29 11:00:00', 'Scheduled', 'Adult vaccination', 'Flu vaccine for adult patient'),
(5, 2, '2026-07-30 16:00:00', 'Cancelled', 'Acne treatment follow-up', 'Patient cancelled due to travel'),
(6, 1, '2026-07-31 08:30:00', 'Completed', 'High blood pressure monitoring', 'Blood pressure: 140/90'),
(1, 2, '2025-01-15 10:00:00', 'Cancelled', 'Old follow-up appointment', 'Patient moved abroad');

INSERT INTO Treatment (treatment_name, description, cost, duration_minutes) VALUES
('ECG Test', 'Electrocardiogram to check heart activity', 150.00, 30),
('Blood Test', 'Complete blood count and analysis', 80.00, 15),
('Skin Biopsy', 'Removal of skin sample for examination', 300.00, 45),
('Vaccination', 'Administration of vaccine', 50.00, 10),
('Physical Examination', 'General health checkup', 100.00, 20);

INSERT INTO Appointment_Treatment (appointment_id, treatment_id, quantity, notes) VALUES
(1, 1, 1, 'Normal ECG results'),
(1, 2, 1, 'Cholesterol slightly elevated'),
(2, 3, 1, 'Benign lesion'),
(4, 4, 1, 'Flu vaccine administered'),
(6, 5, 1, 'Weight and height measured');

INSERT INTO Medicine (medicine_name, description, manufacturer, stock_quantity, unit_price, expiry_date) VALUES
('Amlodipine 5mg', 'Calcium channel blocker for hypertension', 'Pfizer', 200, 45.00, '2027-06-15'),
('Metformin 500mg', 'Oral diabetes medication', 'Novartis', 150, 30.00, '2027-08-20'),
('Amoxicillin 250mg', 'Antibiotic for bacterial infections', 'GSK', 300, 25.00, '2026-12-31'),
('Hydrocortisone Cream', 'Topical steroid for skin inflammation', 'Bayer', 100, 55.00, '2027-03-10'),
('Paracetamol 500mg', 'Pain reliever and fever reducer', 'Panadol', 500, 15.00, '2028-01-01'),
('Vitamin D3 1000IU', 'Vitamin D supplement', 'Nature Made', 250, 35.00, '2027-11-30');

INSERT INTO Prescription (appointment_id, prescription_date, notes) VALUES
(1, '2026-07-25', 'Take medication after meals'),
(2, '2026-07-26', 'Apply cream twice daily'),
(4, '2026-07-29', 'No specific instructions'),
(6, '2026-07-31', 'Monitor blood pressure daily');

INSERT INTO Prescription_Detail (prescription_id, medicine_id, quantity, dosage, frequency, duration_days) VALUES
(1, 1, 30, '1 tablet', 'Once daily', 30),
(1, 5, 20, '1 tablet', 'Twice daily', 10),
(2, 4, 1, 'Apply thin layer', 'Twice daily', 14),
(3, 6, 60, '1 tablet', 'Once daily', 60),
(4, 1, 30, '1 tablet', 'Once daily', 30),
(4, 5, 10, '1 tablet', 'As needed', 5);

INSERT INTO Payment (patient_id, appointment_id, amount, payment_date, payment_method, status) VALUES
(1, 1, 230.00, '2026-07-25', 'Card', 'Paid'),
(2, 2, 300.00, '2026-07-26', 'Cash', 'Paid'),
(3, 3, 150.00, '2026-07-28', 'Insurance', 'Pending'),
(5, 5, 0.00, '2026-07-30', 'Cash', 'Refunded'),
(6, 6, 100.00, '2026-07-31', 'Card', 'Paid');

-- ============================================================
-- 4. SQL OPERATIONS
-- ============================================================

-- 4.1 SELECT
SELECT patient_id, first_name, last_name, phone, blood_type
FROM Patient
WHERE blood_type = 'O+';

-- 4.2 JOIN
SELECT 
    a.appointment_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    e.first_name AS doctor_first_name,
    e.last_name AS doctor_last_name,
    doc.specialization,
    a.appointment_date,
    a.status,
    a.reason
FROM Appointment a
INNER JOIN Patient p ON a.patient_id = p.patient_id
INNER JOIN Doctor doc ON a.doctor_id = doc.doctor_id
INNER JOIN Employee e ON doc.employee_id = e.employee_id
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date;

-- 4.3 NESTED QUERY
SELECT patient_id, first_name, last_name, phone
FROM Patient
WHERE patient_id IN (
    SELECT patient_id 
    FROM Appointment 
    WHERE doctor_id = 1 AND status = 'Completed'
);

-- 4.4 AGGREGATE + GROUP BY
SELECT 
    doc.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    ROUND(AVG(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) * 100, 2) AS completion_rate_pct
FROM Doctor doc
LEFT JOIN Appointment a ON doc.doctor_id = a.doctor_id
GROUP BY doc.specialization
ORDER BY total_appointments DESC;

-- 4.5 UPDATE
UPDATE Medicine 
SET stock_quantity = stock_quantity + 100 
WHERE medicine_id = 5;

SELECT medicine_id, medicine_name, stock_quantity 
FROM Medicine 
WHERE medicine_id = 5;

-- 4.6 DELETE
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Appointment 
WHERE status = 'Cancelled' 
AND appointment_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Appointment WHERE status = 'Cancelled';

-- ============================================================
-- 5. VIEW
-- ============================================================

CREATE OR REPLACE VIEW Patient_Appointment_Summary AS
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    p.phone,
    p.blood_type,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(DISTINCT CASE WHEN a.status = 'Completed' THEN a.appointment_id END) AS completed_appointments,
    COALESCE(SUM(py.amount), 0) AS total_paid_amount,
    MAX(a.appointment_date) AS last_appointment_date
FROM Patient p
LEFT JOIN Appointment a ON p.patient_id = a.patient_id
LEFT JOIN Payment py ON p.patient_id = py.patient_id AND py.status = 'Paid'
GROUP BY p.patient_id, p.first_name, p.last_name, p.phone, p.blood_type;

SELECT * FROM Patient_Appointment_Summary;

-- ============================================================
-- 6. TRIGGER
-- ============================================================

DELIMITER //

CREATE TRIGGER trg_after_prescription_detail_insert
AFTER INSERT ON Prescription_Detail
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    SELECT stock_quantity INTO current_stock 
    FROM Medicine 
    WHERE medicine_id = NEW.medicine_id;
    
    IF current_stock >= NEW.quantity THEN
        UPDATE Medicine 
        SET stock_quantity = stock_quantity - NEW.quantity 
        WHERE medicine_id = NEW.medicine_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Insufficient medicine stock for this prescription.';
    END IF;
END //

DELIMITER ;

-- Test Trigger
INSERT INTO Prescription (appointment_id, prescription_date, notes) 
VALUES (3, '2026-07-28', 'Test prescription for trigger');

INSERT INTO Prescription_Detail (prescription_id, medicine_id, quantity, dosage, frequency, duration_days)
VALUES (5, 2, 10, '1 tablet', 'Twice daily', 30);

SELECT medicine_id, medicine_name, stock_quantity 
FROM Medicine 
WHERE medicine_id = 2;

-- ============================================================
-- 7. BONUS QUERIES
-- ============================================================

SELECT payment_method, COUNT(*) AS transactions, SUM(amount) AS revenue, ROUND(AVG(amount), 2) AS avg_amount
FROM Payment WHERE status = 'Paid' GROUP BY payment_method;

SELECT medicine_id, medicine_name, stock_quantity FROM Medicine WHERE stock_quantity < 50 ORDER BY stock_quantity;

SELECT e.first_name, e.last_name, doc.specialization, COUNT(a.appointment_id) AS total, 
SUM(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) AS completed
FROM Employee e 
JOIN Doctor doc ON e.employee_id = doc.employee_id
LEFT JOIN Appointment a ON doc.doctor_id = a.doctor_id
GROUP BY doc.doctor_id, e.first_name, e.last_name, doc.specialization;

-- ============================================================
-- 8. VERIFY ALL DATA
-- ============================================================

SELECT 'Employee' AS Table_Name, COUNT(*) AS Record_Count FROM Employee
UNION ALL
SELECT 'Doctor', COUNT(*) FROM Doctor
UNION ALL
SELECT 'Nurse', COUNT(*) FROM Nurse
UNION ALL
SELECT 'Receptionist', COUNT(*) FROM Receptionist
UNION ALL
SELECT 'Department', COUNT(*) FROM Department
UNION ALL
SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL
SELECT 'Appointment', COUNT(*) FROM Appointment
UNION ALL
SELECT 'Treatment', COUNT(*) FROM Treatment
UNION ALL
SELECT 'Appointment_Treatment', COUNT(*) FROM Appointment_Treatment
UNION ALL
SELECT 'Medicine', COUNT(*) FROM Medicine
UNION ALL
SELECT 'Prescription', COUNT(*) FROM Prescription
UNION ALL
SELECT 'Prescription_Detail', COUNT(*) FROM Prescription_Detail
UNION ALL
SELECT 'Payment', COUNT(*) FROM Payment;

-- ============================================================
-- END OF SCRIPT
-- ============================================================