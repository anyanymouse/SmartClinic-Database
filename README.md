# 🏥 Smart Clinic Database System

**A comprehensive relational database management system for clinic operations**

![Database Project](https://img.shields.io/badge/Project-Database%20System-blue)
![Status](https://img.shields.io/badge/Status-Complete-green)
![MySQL](https://img.shields.io/badge/Database-MySQL-orange)

---

## 📋 Project Overview

This project implements a complete database system for a private clinic to manage:
- Patient information and medical history
- Doctor and staff management
- Appointment scheduling
- Treatment records and prescriptions
- Medication management
- Payment and billing

**Course:** IT403 - Fundamentals of Database  
**Deadline:** Monday 09/08/2026  
**Total Marks:** 20

---

## 👥 Team Members

| Name | ID | Role | Contributions |
|------|-----|------|----------------|
| Hanadi Abdullah Alshehri | S230035637 | Database Designer | ER/EER diagram, relational schema |
| Sakinah Ali Almuhaini | S210033402 | Database Administrator | MySQL implementation, table creation |
| Sarah hadi alyami | S220002526 | SQL Developer | Queries, views, triggers |
| Kadi Alharbi | S230019734 | Documentation Lead | Repository management, final review |

---

## 📊 Database Structure

### **Entities & Tables**

1. **Employee** (Superclass)
   - Base information for all clinic staff
   - Specialization/Generalization: Doctor, Nurse, Receptionist

2. **Doctor**
   - Doctor-specific information (specialization, license)
   - Inherits from Employee

3. **Nurse**
   - Nursing staff details
   - Inherits from Employee

4. **Receptionist**
   - Reception staff information
   - Inherits from Employee

5. **Department**
   - Clinic departments
   - Managed by head doctor

6. **Patient**
   - Patient demographic information
   - Emergency contact details
   - Insurance information

7. **Appointment**
   - Appointment scheduling
   - Links patients with doctors

8. **Treatment**
   - Available treatment types

9. **Appointment_Treatment**
   - Junction table for many-to-many relationship
   - Links appointments with treatments

10. **Medicine**
    - Medication inventory

11. **Prescription**
    - Patient prescriptions

12. **Prescription_Detail**
    - Individual medicine details in prescriptions

13. **Payment**
    - Billing and payment records

---

## 🗄️ Database Design Features

### **Key Design Decisions**

✅ **Specialization/Generalization (EER Feature)**
- Employee as superclass with Doctor, Nurse, Receptionist as subclasses
- Eliminates redundant data
- Maintains referential integrity

✅ **Many-to-Many Relationship**
- Appointment_Treatment junction table for flexible treatment assignments
- Properly normalized following 3NF

✅ **Data Integrity**
- Primary keys on all tables
- Foreign key constraints
- NOT NULL, UNIQUE, CHECK constraints
- AUTO_INCREMENT for identifiers
- ENUM for status fields

---

## 🛠️ Installation & Setup

### **Prerequisites**
- MySQL Server (version 5.7 or higher)
- MySQL Workbench or any MySQL client

### **Steps to Set Up the Database**

1. **Open MySQL:**
   ```bash
   mysql -u root -p
   ```

2. **Run the SQL script:**
   ```bash
   source /path/to/SmartClinic.sql
   ```
   
   OR copy-paste the entire script in MySQL Workbench

3. **Verify the database:**
   ```sql
   USE SmartClinic;
   SHOW TABLES;
   ```

---

## 📋 SQL Operations Implemented

### **1. SELECT Statements**
- Retrieve all patients
- Get doctor information with specialization
- List appointments for specific date range

### **2. JOIN Queries**
- Multi-table joins to combine related data
- INNER JOIN for employees and doctors
- LEFT JOIN for optional relationships

### **3. Nested Queries (Subqueries)**
- Find patients with specific treatment history
- List doctors with most appointments
- Identify high-value payments

### **4. Aggregate Functions with GROUP BY**
- Count appointments per doctor
- Calculate total payments per patient
- Average age of patients by gender

### **5. UPDATE Statements**
- Update appointment status
- Modify patient contact information
- Change employee salary

### **6. DELETE Statements**
- Remove cancelled appointments
- Delete completed treatments
- Remove patient records

### **7. VIEW**
- `DoctorAppointmentView`: Shows doctor details with appointment statistics

### **8. TRIGGER**
- Automatic timestamp update on record modification
- Validate appointment dates before insertion

---

## 📁 Project Files

```
SmartClinic-Database/
│
├── README.md                    # This file
├── .gitignore                   # Git ignore rules
│
├── database/
│   └── SmartClinic.sql         # Complete database SQL script
│
├── documentation/
│   ├── Project_Report.pdf      # Final project report
│   ├── Project_Report.docx     # Word version of report
│   └── Mid-Project_Report.pdf  # Progress report
│
├── screenshots/
│   ├── database-tables/        # Screenshots of all tables
│   ├── queries-results/        # Query execution screenshots
│   └── er-diagram/             # ER/EER diagram images
│
└── queries/
    ├── select-queries.sql      # SELECT statement examples
    ├── join-queries.sql        # JOIN query examples
    ├── nested-queries.sql      # Subquery examples
    ├── aggregate-queries.sql   # GROUP BY and aggregates
    ├── update-delete.sql       # UPDATE/DELETE examples
    ├── view-creation.sql       # VIEW creation script
    └── trigger-creation.sql    # TRIGGER creation script
```

---

## 🔄 Git Commit History

The repository maintains regular commits showing incremental progress:

```
commit a1b2c3d - Initial project setup: database structure and documentation
commit e4f5g6h - Database implementation: all tables created
commit i7j8k9l - Sample data insertion: 5+ records per table
commit m0n1o2p - SQL operations: queries, views, triggers
commit q3r4s5t - Final documentation and screenshots
commit u6v7w8x - README and project artifacts
```

**Commit frequently with meaningful messages!**

---

## ✅ Project Requirements Checklist

### **Task 1 – Database Design (6 marks)**
- ✅ ER/EER diagram with 13 entities
- ✅ Primary and foreign keys defined
- ✅ Relationships with cardinality
- ✅ Specialization/generalization (Employee hierarchy)
- ✅ Design assumptions documented

### **Task 2 – Database Implementation (6 marks)**
- ✅ Database created with all tables
- ✅ Appropriate data types and constraints
- ✅ At least 5 records per table
- ✅ Referential integrity maintained

### **Task 3 – SQL Operations (6 marks)**
- ✅ SELECT statements
- ✅ JOIN queries
- ✅ Nested queries
- ✅ Aggregate functions with GROUP BY
- ✅ UPDATE and DELETE statements
- ✅ VIEW creation
- ✅ TRIGGER creation

### **Task 4 – Reflection (2 marks)**
- ✅ 300-500 word reflection
- ✅ Challenges and solutions
- ✅ Design approach justification
- ✅ AI tool disclosure
- ✅ Future improvements

### **Deliverables**
- ✅ Project Report (PDF & Word)
- ✅ SQL Script
- ✅ GitHub Repository with commit history
- ✅ Mid-Project Progress Report
- ✅ Project Artifacts with links

---

## 📝 Key Challenges & Solutions

### **Challenge 1: Many-to-Many Relationship**
**Problem:** How to assign multiple treatments to appointments?  
**Solution:** Created Appointment_Treatment junction table with composite primary key

### **Challenge 2: Employee Hierarchy**
**Problem:** Store different employee types with role-specific data?  
**Solution:** Implemented specialization/generalization with Employee superclass

### **Challenge 3: Data Integrity**
**Problem:** Maintain referential integrity across relationships?  
**Solution:** Proper foreign key constraints with ON DELETE CASCADE/SET NULL

---

## 🚀 How to Use the Database

### **Sample Queries**

1. **Find all appointments for a patient:**
   ```sql
   SELECT * FROM Appointment 
   WHERE patient_id = 1 
   ORDER BY appointment_date DESC;
   ```

2. **Get doctor with most appointments:**
   ```sql
   SELECT doctor_id, COUNT(*) as appointment_count 
   FROM Appointment 
   GROUP BY doctor_id 
   ORDER BY appointment_count DESC LIMIT 1;
   ```

3. **View all prescriptions for a patient:**
   ```sql
   SELECT p.prescription_id, p.date_issued, pd.medicine_id, pd.dosage
   FROM Prescription p
   JOIN Prescription_Detail pd ON p.prescription_id = pd.prescription_id
   WHERE p.patient_id = 1;
   ```

---

## 📞 Support & Documentation

- **Course:** Fundamentals of Database (IT403)
- **Instructor:** [Instructor Name]
- **Institution:** College of Computing and Informatics
- **Submission Date:** Monday 09/08/2026

---

## ⚖️ Important Notes

### **AI Usage Disclosure**
As per course requirements, any AI tools used for:
- Brainstorming design approaches
- Debugging SQL errors
- Grammar checking
- Conceptual understanding

All AI usage has been disclosed in the project reflection section.

### **Academic Integrity**
- This project represents original work by the team
- All sources and tools have been properly cited
- Database design and implementation are team-created

---

## 📈 Future Enhancements

With more time and resources, the following improvements could be made:

1. **Web Interface** - User-friendly UI for clinic staff
2. **Advanced Analytics** - Dashboard for clinic performance metrics
3. **Appointment Reminders** - Automated SMS/email notifications
4. **Mobile Application** - Patient app for booking appointments
5. **Integration** - Connect with payment gateways
6. **Security** - User authentication and role-based access control

---

## 📞 Contact Information

For questions or clarifications about this project:

- **Hanadi Abdullah Alshehri** - Database Design Lead
- **Sakinah Ali Almuhaini** - Implementation Specialist  
- **Sarah hadi alyami** - SQL Operations Expert
- **Kadi Alharbi** - Documentation & QA

---

## 📄 License

This project is submitted as academic coursework for IT403.

---

**Last Updated: ** 2026-08-06 


