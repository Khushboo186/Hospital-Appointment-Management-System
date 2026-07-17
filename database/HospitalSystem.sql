Create database HospitalSystem;
use HospitalSystem;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,                 
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    head_dept VARCHAR(100)
);

CREATE TABLE Room (
    room_id INT PRIMARY KEY,               
    room_type VARCHAR(50),
    capacity INT,
    availability VARCHAR(20),
    status VARCHAR(20)
);
select * from Room;

CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,               
    doct_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    shift_time VARCHAR(50),
    dept_id INT,                              
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);
select * from Doctor;

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,              
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(50),
    room_id INT,                             
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,          
    patient_id INT,                          
    doctor_id INT,                           
    date DATE,
    time TIME,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,                  
    patient_id INT,                           
    appointment_id INT UNIQUE,                
    payment_status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);


-- department log
CREATE TABLE Department_log (
    log_id      INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),       -- INSERT / DELETE
    action_time DATETIME,
    dept_id     INT,
    dept_name   VARCHAR(100),
    location    VARCHAR(100),
    head_dept   VARCHAR(100)
);
select * from department_log;

-- room log
CREATE TABLE Room_log (
    log_id      INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    room_id     INT,
    room_type   VARCHAR(50),
    capacity    INT,
    availability VARCHAR(20),
    status      VARCHAR(20)
);
select * from Room_log;

-- doctor log
CREATE TABLE Doctor_log (
    log_id        INT PRIMARY KEY AUTO_INCREMENT,
    action_type   VARCHAR(10),
    action_time   DATETIME,
    doctor_id     INT,
    doct_name          VARCHAR(100),
    specialization VARCHAR(100),
    phone         VARCHAR(15),
    email         VARCHAR(100),
    shift_time    VARCHAR(50),
    dept_id       INT
);
select * from Doctor_log;

-- patient log
CREATE TABLE Patient_log (
    log_id      INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(10),
    action_time DATETIME,
    patient_id  INT,
    name        VARCHAR(100),
    dob         DATE,
    gender      VARCHAR(10),
    phone       VARCHAR(15),
    email       VARCHAR(100),
    street      VARCHAR(100),
    city        VARCHAR(50),
    room_id     INT
);
select * from Patient_log;

-- appoitment log
CREATE TABLE Appointment_log (
    log_id         INT PRIMARY KEY AUTO_INCREMENT,
    action_type    VARCHAR(10),
    action_time    DATETIME,
    appointment_id INT,
    patient_id     INT,
    doctor_id      INT,
    date           DATE,
    time           TIME,
    status         VARCHAR(20)
);
select * from Appointment_log;


-- biling log
CREATE TABLE Billing_log (
    log_id         INT PRIMARY KEY AUTO_INCREMENT,
    action_type    VARCHAR(10),
    action_time    DATETIME,
    bill_id        INT,
    patient_id     INT,
    appointment_id INT,
    payment_status VARCHAR(50)
);
select * from Billing_log;


--  Triggers --

-- DEPARTMENT TRIGGERS 
DELIMITER //
CREATE TRIGGER department_after_insert
AFTER INSERT ON Department
FOR EACH ROW
BEGIN
    INSERT INTO Department_log
    (action_type, action_time, dept_id, dept_name, location, head_dept)
    VALUES
    ('INSERT', NOW(), NEW.dept_id, NEW.dept_name, NEW.location, NEW.head_dept);
END//

CREATE TRIGGER department_after_delete
AFTER DELETE ON Department
FOR EACH ROW
BEGIN
    INSERT INTO Department_log
    (action_type, action_time, dept_id, dept_name, location, head_dept)
    VALUES
    ('DELETE', NOW(), OLD.dept_id, OLD.dept_name, OLD.location, OLD.head_dept);
END//
DELIMITER ;




-- ROOM TRIGGERS 

DELIMITER //
CREATE TRIGGER room_after_insert
AFTER INSERT ON Room
FOR EACH ROW
BEGIN
    INSERT INTO Room_log
    (action_type, action_time, room_id, room_type, capacity, availability, status)
    VALUES
    ('INSERT', NOW(), NEW.room_id, NEW.room_type, NEW.capacity, NEW.availability, NEW.status);
END//

CREATE TRIGGER room_after_delete
AFTER DELETE ON Room
FOR EACH ROW
BEGIN
    INSERT INTO Room_log
    (action_type, action_time, room_id, room_type, capacity, availability, status)
    VALUES
    ('DELETE', NOW(), OLD.room_id, OLD.room_type, OLD.capacity, OLD.availability, OLD.status);
END//
DELIMITER ;




-- DOCTOR TRIGGERS 

DELIMITER //
CREATE TRIGGER doctor_after_insert
AFTER INSERT ON Doctor
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_log
    (action_type, action_time, doctor_id, doct_name, specialization, phone, email, shift_time, dept_id)
    VALUES
    ('INSERT', NOW(), NEW.doctor_id, NEW.doct_name, NEW.specialization, NEW.phone,
     NEW.email, NEW.shift_time, NEW.dept_id);
END//

CREATE TRIGGER doctor_after_delete
AFTER DELETE ON Doctor
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_log
    (action_type, action_time, doctor_id, doct_name, specialization, phone, email, shift_time, dept_id)
    VALUES
    ('DELETE', NOW(), OLD.doctor_id, OLD.doct_name, OLD.specialization, OLD.phone,
     OLD.email, OLD.shift_time, OLD.dept_id);
END//
DELIMITER ;



-- PATIENT TRIGGERS 
DELIMITER //
CREATE TRIGGER patient_after_insert
AFTER INSERT ON Patient
FOR EACH ROW
BEGIN
    INSERT INTO Patient_log
    (action_type, action_time, patient_id, name, dob, gender, phone, email, street, city, room_id)
    VALUES
    ('INSERT', NOW(), NEW.patient_id, NEW.name, NEW.dob, NEW.gender, NEW.phone,
     NEW.email, NEW.street, NEW.city, NEW.room_id);
END//

CREATE TRIGGER patient_after_delete
AFTER DELETE ON Patient
FOR EACH ROW
BEGIN
    INSERT INTO Patient_log
    (action_type, action_time, patient_id, name, dob, gender, phone, email, street, city, room_id)
    VALUES
    ('DELETE', NOW(), OLD.patient_id, OLD.name, OLD.dob, OLD.gender, OLD.phone,
     OLD.email, OLD.street, OLD.city, OLD.room_id);
END//
DELIMITER ;


-- APPOINTMENT TRIGGERS

DELIMITER //
CREATE TRIGGER appointment_after_insert
AFTER INSERT ON Appointment
FOR EACH ROW
BEGIN
    INSERT INTO Appointment_log
    (action_type, action_time, appointment_id, patient_id, doctor_id, date, time, status)
    VALUES
    ('INSERT', NOW(), NEW.appointment_id, NEW.patient_id, NEW.doctor_id,
     NEW.`date`, NEW.`time`, NEW.status);
END//

CREATE TRIGGER appointment_after_delete
AFTER DELETE ON Appointment
FOR EACH ROW
BEGIN
    INSERT INTO Appointment_log
    (action_type, action_time, appointment_id, patient_id, doctor_id, date, time, status)
    VALUES
    ('DELETE', NOW(), OLD.appointment_id, OLD.patient_id, OLD.doctor_id,
     OLD.`date`, OLD.`time`, OLD.status);
END//
DELIMITER ;


-- BILLING TRIGGERS 
DELIMITER //
CREATE TRIGGER billing_after_insert
AFTER INSERT ON Billing
FOR EACH ROW
BEGIN
    INSERT INTO Billing_log
    (action_type, action_time, bill_id, patient_id, appointment_id, payment_status)
    VALUES
    ('INSERT', NOW(), NEW.bill_id, NEW.patient_id, NEW.appointment_id, NEW.payment_status);
END//

CREATE TRIGGER billing_after_delete
AFTER DELETE ON Billing
FOR EACH ROW
BEGIN
    INSERT INTO Billing_log
    (action_type, action_time, bill_id, patient_id, appointment_id, payment_status)
    VALUES
    ('DELETE', NOW(), OLD.bill_id, OLD.patient_id, OLD.appointment_id, OLD.payment_status);
END//
DELIMITER ;



INSERT INTO Department VALUES
(1, 'Cardiology', 'Block A', 'Dr. Rajesh Mehta'),
(2, 'Neurology', 'Block B', 'Dr. Anjali Sharma'),
(3, 'Orthopedics', 'Block C', 'Dr. Arvind Khanna'),
(4, 'Pediatrics', 'Block D', 'Dr. Neha Verma'),
(5, 'Gynecology', 'Block E', 'Dr. Ritu Bansal'),
(6, 'Dermatology', 'Block F', 'Dr. Karan Gupta'),
(7, 'ENT', 'Block G', 'Dr. Manoj Singh'),
(8, 'Oncology', 'Block H', 'Dr. Seema Kapoor'),
(9, 'Psychiatry', 'Block I', 'Dr. Vivek Nair'),
(10, 'Urology', 'Block J', 'Dr. Sanjay Rao');



INSERT INTO Room VALUES
(101, 'General Ward', 4, 'Available', 'Clean'),
(102, 'ICU', 2, 'Occupied', 'Clean'),
(103, 'Private', 1, 'Available', 'Clean'),
(104, 'Semi-Private', 2, 'Occupied', 'Under Maintenance'),
(105, 'General Ward', 6, 'Available', 'Clean'),
(106, 'Maternity Ward', 1, 'Available', 'Clean'),
(107, 'Recovery Room', 2, 'Available', 'Clean'),
(108, 'Pediatric Ward', 5, 'Occupied', 'Clean'),
(109, 'Isolation Room', 2, 'Available', 'Clean'),
(110, 'Surgery Suite', 1, 'Occupied', 'Clean');

select * from room;
select * from room_log;





INSERT INTO Doctor VALUES
(1, 'Dr. Rajesh Mehta', 'Cardiologist', '9876543210', 'rajesh@hospital.com', 'Morning', 1),
(2, 'Dr. Anjali Sharma', 'Neurologist', '9876500001', 'anjali@hospital.com', 'Evening', 2),
(3, 'Dr. Arvind Khanna', 'Orthopedic', '9876500002', 'arvind@hospital.com', 'Morning', 3),
(4, 'Dr. Neha Verma', 'Pediatrician', '9876500003', 'neha@hospital.com', 'Morning', 4),
(5, 'Dr. Ritu Bansal', 'Gynecologist', '9876500004', 'ritu@hospital.com', 'Evening', 5),
(6, 'Dr. Karan Gupta', 'Dermatologist', '9876500005', 'karan@hospital.com', 'Morning', 6),
(7, 'Dr. Manoj Singh', 'ENT Specialist', '9876500006', 'manoj@hospital.com', 'Evening', 7),
(8, 'Dr. Seema Kapoor', 'Oncologist', '9876500007', 'seema@hospital.com', 'Morning', 8),
(9, 'Dr. Vivek Nair', 'Psychiatrist', '9876500008', 'vivek@hospital.com', 'Evening', 9),
(10, 'Dr. Sanjay Rao', 'Urologist', '9876500009', 'sanjay@hospital.com', 'Morning', 10);
select * from doctor;




INSERT INTO Patient VALUES
(1, 'Amit Sharma', '1990-05-14', 'Male', '9811111111', 'amit@gmail.com', 'Sector 15', 'Chandigarh', 101),
(2, 'Neha Gupta', '1995-07-20', 'Female', '9822222222', 'neha@gmail.com', 'Phase 3B2', 'Mohali', 103),
(3, 'Rohit Mehta', '1988-03-09', 'Male', '9833333333', 'rohit@gmail.com', 'Sector 70', 'Mohali', 105),
(4, 'Priya Arora', '1992-10-01', 'Female', '9844444444', 'priya@gmail.com', 'Sector 10', 'Panchkula', 102),
(5, 'Karan Singh', '1985-12-25', 'Male', '9855555555', 'karan@gmail.com', 'Sector 12', 'Chandigarh', 104),
(6, 'Pooja Bansal', '1998-08-30', 'Female', '9866666666', 'pooja@gmail.com', 'Phase 7', 'Mohali', 106),
(7, 'Rahul Verma', '2000-01-19', 'Male', '9877777777', 'rahul@gmail.com', 'Sector 20', 'Chandigarh', 107),
(8, 'Simran Kaur', '1999-11-09', 'Female', '9888888888', 'simran@gmail.com', 'Phase 5', 'Mohali', 108),
(9, 'Vikram Yadav', '1983-04-05', 'Male', '9899999999', 'vikram@gmail.com', 'Sector 22', 'Chandigarh', 109),
(10, 'Nisha Rani', '1996-06-11', 'Female', '9900000000', 'nisha@gmail.com', 'Sector 18', 'Panchkula', 110);

select * from patient;

  
  
  
  
INSERT INTO Appointment VALUES
(1, 1, 1, '2025-11-01', '09:00:00', 'Completed'),
(2, 2, 2, '2025-11-02', '11:30:00', 'Scheduled'),
(3, 3, 3, '2025-11-02', '10:00:00', 'Completed'),
(4, 4, 4, '2025-11-03', '12:00:00', 'Scheduled'),
(5, 5, 5, '2025-11-04', '13:00:00', 'Cancelled'),
(6, 6, 6, '2025-11-05', '09:30:00', 'Completed'),
(7, 7, 7, '2025-11-06', '15:00:00', 'Scheduled'),
(8, 8, 8, '2025-11-07', '11:00:00', 'Completed'),
(9, 9, 9, '2025-11-08', '16:00:00', 'Scheduled'),
(10, 10, 10, '2025-11-09', '10:30:00', 'Scheduled');
select * from Appointment;

  
  
  
  
  
  
  
INSERT INTO Billing VALUES
(1, 1, 1, 'Paid'),
(2, 2, 2, 'Pending'),
(3, 3, 3, 'Paid'),
(4, 4, 4, 'Pending'),
(5, 5, 5, 'Cancelled'),
(6, 6, 6, 'Paid'),
(7, 7, 7, 'Pending'),
(8, 8, 8, 'Paid'),
(9, 9, 9, 'Pending'),
(10, 10, 10, 'Paid');
select * from Billing;



select * From Department;
select * From Room;
select * From Doctor;
select * From Patient;
select * From Appointment;
select * From Billing;

SHOW TRIGGERS WHERE `Table` = 'department';
SHOW TRIGGERS WHERE `Table` = 'Room';
SHOW TRIGGERS WHERE `Table` = 'Doctor';
SHOW TRIGGERS WHERE `Table` = 'Patient';
SHOW TRIGGERS WHERE `Table` = 'Appointment';
SHOW TRIGGERS WHERE `Table` = 'Billing';

select * From Department; 

select * From Room_log;
select * From Doctor;
select * From Patient;
select * From Appointment;
select * From Billing;


--  queries
-- 1. Get names of patients who booked appointments.
SELECT DISTINCT p.Name
FROM Patient p
JOIN Appointment a
ON p.patient_id = a.patient_iD;

-- 2 . List patients with appointment status ‘Complete’.
SELECT DISTINCT p.Name
FROM Patient p
JOIN Appointment a
ON p.patient_id = a.patient_id
WHERE a.Status = 'Completed';


-- 3. List doctors with specialization ‘Cardiology’.
 SELECT doct_name FROM Doctor
WHERE specialization = 'Cardiologist';

-- 4. List doctors working in the ‘Neurology’ department.
SELECT DISTINCT d.doct_name
FROM Doctor d
JOIN Department dept
ON d.dept_id = dept.dept_id
WHERE dept.dept_name = 'neurology';

-- 5. Get department names with their head of department.
SELECT dept_name, head_dept
FROM Department;

-- 6. Get departments with more than 5 doctors.
SELECT dept.dept_name
FROM Department dept
JOIN Doctor d
    ON dept.dept_id = d.dept_id
GROUP BY dept.dept_id, dept.dept_name
HAVING COUNT(d.doctor_id) > 1;



-- 7.  Find names of patients and their allocated room IDs.
SELECT p.name, r.room_id
FROM Patient p
JOIN Room r
ON p.room_id = r.room_id;



-- 8.  List patients in ICU rooms.
SELECT DISTINCT p.name
FROM Patient p
JOIN Room r
ON p.room_id = r.room_id
WHERE r.room_type = 'ICU';

-- 9. .. Find patients who had an appointment but no bill generated.
SELECT DISTINCT p.name
FROM Patient p
JOIN Appointment a
    ON p.patient_id = a.patient_id
LEFT JOIN Billing b
    ON p.patient_id = b.patient_id
WHERE b.patient_id IS NULL;


-- 10. . Get names of patients with Pending bills.
SELECT DISTINCT p.name
FROM Patient p
JOIN Billing b
ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Pending';














 
















