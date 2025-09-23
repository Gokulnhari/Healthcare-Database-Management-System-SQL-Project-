-- 1 creating a new database

CREATE DATABASE healthcare_db;
USE healthcare_db;

-- 2 creating tables for patients, doctors and visits

-- patients table
CREATE TABLE patients (
patient_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
date_of_birth DATE NOT NULL,
gender ENUM('Male', 'Female', 'Other') NOT NULL,
contact_info VARCHAR(50) UNIQUE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE doctors (
doctor_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
speciality VARCHAR(50) NOT NULL,
contact_info VARCHAR(50) UNIQUE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- visits table 
CREATE TABLE visits (
visit_id INT AUTO_INCREMENT PRIMARY KEY,
patient_id INT NOT NULL,
doctor_id INT NOT NULL,
visit_date DATE NOT NULL,
visit_type ENUM('New Visit','Re-Visit','Revisit-New') NOT NULL,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- 3 Inserting Sample Data & Test

-- Sample data for doctors
INSERT INTO doctors (name, speciality, contact_info)
VALUES ('Dr. Smith', 'Cardiology', 'smith@clinic.com'),
('Dr. Ajay','neurology', 'ajay@clinic.com'),
('Dr. Meera Nair', 'Dermatology', 'meera.nair@clinic.com'),
('Dr. Ramesh Iyer', 'Orthopedics', 'ramesh.iyer@clinic.com'),
('Dr. Anjali Menon', 'Pediatrics', 'anjali.menon@clinic.com'),
('Dr. Arvind Rao', 'General Medicine', 'arvind.rao@clinic.com'),
('Dr. Sneha Pillai', 'Gynecology', 'sneha.pillai@clinic.com'),
('Dr. Kiran Thomas', 'ENT', 'kiran.thomas@clinic.com'),
('Dr. Priya Das', 'Psychiatry', 'priya.das@clinic.com'),
('Dr. Mohan Krishnan', 'Urology', 'mohan.krishnan@clinic.com'),
('Dr. Neha Joseph', 'Endocrinology', 'neha.joseph@clinic.com'),
('Dr. Rahul Varma', 'Oncology', 'rahul.varma@clinic.com');

-- Sample data for patients
INSERT INTO patients (name, date_of_birth, gender, contact_info)
VALUES ('Johnson', '1990-05-11', 'Male', 'johnson@gmail.com'),
('vivek', '2000-10-12','Male','vivek@gmail.com'),
('Aarav Kumar', '1985-03-22', 'Male', 'aarav.kumar@gmail.com'),
('Diya Sharma', '1992-07-15', 'Female', 'diya.sharma@gmail.com'),
('Rohan Nair', '1978-11-30', 'Male', 'rohan.nair@gmail.com'),
('Sneha Raj', '2001-04-09', 'Female', 'sneha.raj@gmail.com'),
('Aditya Menon', '1995-08-18', 'Male', 'aditya.menon@gmail.com'),
('Isha Thomas', '1989-12-05', 'Female', 'isha.thomas@gmail.com'),
('Karthik Pillai', '1993-06-27', 'Male', 'karthik.pillai@gmail.com'),
('Neha Joseph', '1998-10-21', 'Female', 'neha.joseph@gmail.com'),
('Vikram Das', '1982-02-14', 'Male', 'vikram.das@gmail.com'),
('Meera Varma', '1990-09-03', 'Female', 'meera.varma@gmail.com');

-- 4 Created a Trigger for Visit Classification

DELIMITER //
CREATE TRIGGER trg_visits_before_insert
BEFORE INSERT ON visits
FOR EACH ROW
BEGIN
  DECLARE last_visit_date DATE;

  SELECT MAX(visit_date) INTO last_visit_date
  FROM visits
  WHERE patient_id = NEW.patient_id AND doctor_id = NEW.doctor_id;

  SET NEW.visit_type = CASE
    WHEN last_visit_date IS NULL THEN 'New Visit'
    WHEN DATEDIFF(NEW.visit_date, last_visit_date) <= 7 THEN 'Re-Visit'
    ELSE 'Revisit-New'
  END;
END //
DELIMITER ;


INSERT INTO visits (patient_id, doctor_id, visit_date)
VALUES (4, 2, '2025-09-08'),(4,2, '2025-09-13'),(4,2, '2025-09-23'),(4,1, '2025-09-23'),(1,2, '2025-09-23');

-- 4.1 Created a Stored Procedure for Visit Classification 

DELIMITER //
CREATE PROCEDURE classify_visit (
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_visit_date DATE
)
BEGIN
    DECLARE last_visit_date DATE;
    DECLARE visit_type VARCHAR(20);

    SELECT MAX(visit_date)
    INTO last_visit_date
    FROM visits
    WHERE patient_id = p_patient_id AND doctor_id = p_doctor_id;

    SET visit_type = CASE
        WHEN last_visit_date IS NULL THEN 'New Visit'
        WHEN DATEDIFF(p_visit_date, last_visit_date) <= 7 THEN 'Re-Visit'
        ELSE 'Revisit-New'
    END;

    INSERT INTO visits (patient_id, doctor_id, visit_date, visit_type)
    VALUES (p_patient_id, p_doctor_id, p_visit_date, visit_type);
END //
DELIMITER ;


-- 6 To verify the results
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