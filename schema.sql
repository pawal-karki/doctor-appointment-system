-- =====================================================
-- COMPLETE DATABASE SCHEMA FOR DOCTOR APPOINTMENT SYSTEM
-- Generated from Model and DAO Analysis
-- All relationships and constraints included
-- =====================================================

-- Drop database if exists and create fresh
-- DROP DATABASE IF EXISTS doc_appointment_db;
CREATE DATABASE IF NOT EXISTS doc_appointment_db;
USE doc_appointment_db;

-- Disable foreign key checks temporarily for clean setup
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 1. USERS TABLE (User model)
-- =====================================================
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL DEFAULT 'user' COMMENT 'admin or user',
    image_url VARCHAR(255),
    verified BOOLEAN DEFAULT FALSE COMMENT 'Email verification status',
    otp_code VARCHAR(10) COMMENT 'Verification OTP code',
    otp_expiry BIGINT COMMENT 'OTP expiration timestamp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_users_email (email),
    INDEX idx_users_role (role),
    INDEX idx_users_verified (verified)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 2. DEPARTMENTS TABLE (Department model)
-- =====================================================
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_departments_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 3. DOCTORS TABLE (Doctor model)
-- =====================================================
DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(255) NOT NULL,
    experience VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_doctors_email (email),
    INDEX idx_doctors_specialization (specialization),
    INDEX idx_doctors_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 4. TIMESLOTS TABLE (TimeSlot model)
-- =====================================================
DROP TABLE IF EXISTS timeslots;
CREATE TABLE timeslots (
    timeslot_id INT AUTO_INCREMENT PRIMARY KEY,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY unique_timeslot (slot_date, start_time, end_time),
    INDEX idx_timeslots_slot_date (slot_date),
    INDEX idx_timeslots_start_time (start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 5. DOCTOR_DEPARTMENTS TABLE (DoctorDepartment model)
-- Many-to-Many relationship: Doctor ↔ Department
-- =====================================================
DROP TABLE IF EXISTS doctor_departments;
CREATE TABLE doctor_departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_doctor_department (doctor_id, department_id),
    INDEX idx_doctor_departments_doctor_id (doctor_id),
    INDEX idx_doctor_departments_department_id (department_id),

    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 6. DOCTOR_TIMESLOTS TABLE (DoctorTimeSlot model)
-- Many-to-Many relationship: Doctor ↔ TimeSlot with availability
-- =====================================================
DROP TABLE IF EXISTS doctor_timeslots;
CREATE TABLE doctor_timeslots (
    doctor_id INT NOT NULL,
    timeslot_id INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (doctor_id, timeslot_id),
    INDEX idx_doctor_timeslots_doctor_id (doctor_id),
    INDEX idx_doctor_timeslots_timeslot_id (timeslot_id),
    INDEX idx_doctor_timeslots_available (is_available),

    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (timeslot_id) REFERENCES timeslots(timeslot_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 7. APPOINTMENTS TABLE (Appointment model)
-- Central table connecting User, Doctor, TimeSlot with payment integration
-- =====================================================
DROP TABLE IF EXISTS appointments;
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    doctor_id INT NOT NULL,
    time_slot INT NOT NULL COMMENT 'References timeslot_id',
    appointment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' COMMENT 'pending, confirmed, cancelled, completed',
    note TEXT,

    -- Payment integration fields
    amount DECIMAL(10, 2) DEFAULT 2000.00 COMMENT 'Payment amount for the appointment',
    payment_status VARCHAR(20) DEFAULT 'pending' COMMENT 'pending, paid, failed, refunded',
    transaction_uuid VARCHAR(100) COMMENT 'eSewa transaction UUID',
    transaction_code VARCHAR(50) COMMENT 'eSewa transaction code',
    payment_date TIMESTAMP NULL COMMENT 'When payment was made',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_appointments_user_id (user_id),
    INDEX idx_appointments_doctor_id (doctor_id),
    INDEX idx_appointments_time_slot (time_slot),
    INDEX idx_appointments_appointment_date (appointment_date),
    INDEX idx_appointments_status (status),
    INDEX idx_appointments_payment_status (payment_status),
    INDEX idx_appointments_transaction_uuid (transaction_uuid),

    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (time_slot) REFERENCES timeslots(timeslot_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 8. PAYMENTS TABLE (Payment model)
-- eSewa Payment Integration
-- =====================================================
DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL DEFAULT 2000.00,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    service_charge DECIMAL(10, 2) DEFAULT 0.00,
    delivery_charge DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    transaction_uuid VARCHAR(100) UNIQUE NOT NULL,
    transaction_code VARCHAR(50),
    product_code VARCHAR(50) DEFAULT 'EPAYTEST',
    status VARCHAR(20) DEFAULT 'pending' COMMENT 'pending, complete, failed, refund',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    signature TEXT COMMENT 'eSewa signature for verification',

    INDEX idx_payments_appointment_id (appointment_id),
    INDEX idx_payments_transaction_uuid (transaction_uuid),
    INDEX idx_payments_status (status),
    INDEX idx_payments_created_date (created_date),

    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 9. TOKENS TABLE (Token model)
-- Remember Me & Password Reset tokens
-- =====================================================
DROP TABLE IF EXISTS tokens;
CREATE TABLE tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    token_type ENUM('REMEMBER_ME', 'PASSWORD_RESET') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,

    UNIQUE KEY unique_user_token_type (user_id, token, token_type),
    INDEX idx_tokens_user_id (user_id),
    INDEX idx_tokens_token (token),
    INDEX idx_tokens_token_type (token_type),
    INDEX idx_tokens_expires_at (expires_at),

    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 10. INSERT SAMPLE DATA
-- =====================================================

-- Sample Departments
INSERT INTO departments (department_id, name, description, image_url) VALUES
(1, 'Cardiology', 'Heart and cardiovascular system specialists', '/images/departments/cardiology.jpg'),
(2, 'Neurology', 'Brain and nervous system specialists', '/images/departments/neurology.jpg'),
(3, 'Orthopedics', 'Bone and joint specialists', '/images/departments/orthopedics.jpg'),
(4, 'Pediatrics', 'Child healthcare specialists', '/images/departments/pediatrics.jpg'),
(5, 'Dermatology', 'Skin condition specialists', '/images/departments/dermatology.jpg'),
(6, 'General Medicine', 'General health and wellness', '/images/departments/general.jpg');

-- Sample Admin User (password should be properly hashed in production)
INSERT INTO users (user_id, name, email, password, role, verified, phone) VALUES
(1, 'System Admin', 'admin@hospital.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', TRUE, '+977-9800000000');

-- Sample Doctors
INSERT INTO doctors (doctor_id, name, specialization, qualification, experience, email, phone, image_url) VALUES
(1, 'Dr. Rajesh Sharma', 'Cardiology', 'MBBS, MD Cardiology', '15 years', 'rajesh@hospital.com', '+977-9801111111', '/images/doctors/doctor1.jpg'),
(2, 'Dr. Priya Thapa', 'Neurology', 'MBBS, DM Neurology', '12 years', 'priya@hospital.com', '+977-9802222222', '/images/doctors/doctor2.jpg'),
(3, 'Dr. Amit Gurung', 'Orthopedics', 'MBBS, MS Orthopedics', '10 years', 'amit@hospital.com', '+977-9803333333', '/images/doctors/doctor3.jpg'),
(4, 'Dr. Sunita Rai', 'Pediatrics', 'MBBS, MD Pediatrics', '8 years', 'sunita@hospital.com', '+977-9804444444', '/images/doctors/doctor4.jpg'),
(5, 'Dr. Krishna Magar', 'General Medicine', 'MBBS, MD Internal Medicine', '20 years', 'krishna@hospital.com', '+977-9805555555', '/images/doctors/doctor5.jpg');

-- Link Doctors to Departments
INSERT INTO doctor_departments (doctor_id, department_id) VALUES
(1, 1), -- Dr. Rajesh Sharma - Cardiology
(2, 2), -- Dr. Priya Thapa - Neurology
(3, 3), -- Dr. Amit Gurung - Orthopedics
(4, 4), -- Dr. Sunita Rai - Pediatrics
(5, 6), -- Dr. Krishna Magar - General Medicine
(5, 1); -- Dr. Krishna can also handle cardiology cases

-- Sample Time Slots (Today and tomorrow)
INSERT INTO timeslots (timeslot_id, slot_date, start_time, end_time) VALUES
-- Today
(1, CURDATE(), '09:00:00', '09:30:00'),
(2, CURDATE(), '09:30:00', '10:00:00'),
(3, CURDATE(), '10:00:00', '10:30:00'),
(4, CURDATE(), '10:30:00', '11:00:00'),
(5, CURDATE(), '11:00:00', '11:30:00'),
(6, CURDATE(), '14:00:00', '14:30:00'),
(7, CURDATE(), '14:30:00', '15:00:00'),
(8, CURDATE(), '15:00:00', '15:30:00'),
(9, CURDATE(), '15:30:00', '16:00:00'),
(10, CURDATE(), '16:00:00', '16:30:00'),

-- Tomorrow
(11, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '09:30:00'),
(12, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:30:00', '10:00:00'),
(13, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00', '10:30:00'),
(14, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:30:00', '11:00:00'),
(15, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00:00', '11:30:00'),
(16, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '14:30:00'),
(17, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:30:00', '15:00:00'),
(18, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '15:00:00', '15:30:00'),
(19, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '15:30:00', '16:00:00'),
(20, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:00:00', '16:30:00');

-- Link Doctors to Time Slots (make all available)
INSERT INTO doctor_timeslots (doctor_id, timeslot_id, is_available)
SELECT d.doctor_id, t.timeslot_id, TRUE
FROM doctors d
CROSS JOIN timeslots t;

-- Sample Patient User
INSERT INTO users (name, email, password, role, verified, phone) VALUES
('John Patient', 'patient@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', TRUE, '+977-9806666666');


