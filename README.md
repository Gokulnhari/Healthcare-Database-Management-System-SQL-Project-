# 🏥 Healthcare Database Management System — SQL Project

This project simulates a **Healthcare Management System** using SQL.  
It includes database design for patients, doctors, and visits, along with triggers and stored procedures to automate visit classification.

---

## 🛠️ Technologies Used
* **MySQL**
* **SQL Scripting**

---

## 🗄️ Database Structure

The database `healthcare_db` contains the following tables:

### 1. `Patients`
Stores patient details such as name, date of birth, gender, and contact info.

### 2. `Doctors`
Stores doctor details, including specialty and contact information.

### 3. `Visits`
Tracks patient visits with doctor details and automatically assigns visit types.

---

## 📂 Key Features
- Automated **visit classification**:  
  - `New Visit` → First visit to a doctor  
  - `Re-Visit` → Within 7 days of last visit  
  - `Revisit-New` → After 7 days  
- Trigger to auto-classify visits during insert.  
- Stored procedure for inserting new visits with classification.  
- Sample data for **12 doctors** and **12 patients**.  

---

## 📊 Sample Query

```sql
SELECT 
  v.visit_id,
  p.name AS patient_name,
  d.name AS doctor_name,
  v.visit_date,
  v.visit_type
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
JOIN doctors d ON v.doctor_id = d.doctor_id
ORDER BY v.visit_id;

## Author

Project by: Gokul N Hari
SQL Project Level: Intermediate
Use Case: Educational
