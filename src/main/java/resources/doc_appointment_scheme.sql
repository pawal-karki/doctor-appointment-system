-- Create database
CREATE DATABASE IF NOT EXISTS appointment_db;
USE doc_appointment_db;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Timeslots table
CREATE TABLE timeslots (
    timeslot_id INT AUTO_INCREMENT PRIMARY KEY,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT unique_timeslot UNIQUE (slot_date, start_time, end_time)
);

-- Departments table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    qualification VARCHAR(255) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    experience VARCHAR(50),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Doctor-Department relationship table
CREATE TABLE doctor_departments (
    doctor_id INT,
    department_id INT,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- Doctor-Timeslot relationship table
CREATE TABLE doctor_timeslots (
    doctor_id INT,
    timeslot_id INT,
    is_available BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (doctor_id, timeslot_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (timeslot_id) REFERENCES timeslots(timeslot_id) ON DELETE CASCADE
);

-- Appointments table
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    doctor_id INT NOT NULL,
    time_slot INT NOT NULL,
    appointment_date DATE NOT NULL,
    note TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);
-- Create the combined tokens table
CREATE TABLE tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    token_type ENUM('REMEMBER_ME', 'PASSWORD_RESET') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT unique_user_token_type UNIQUE (user_id, token, token_type)
);



-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_doctors_email ON doctors(email);
CREATE INDEX idx_timeslots_date ON timeslots(slot_date);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_user ON appointments(user_id);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_doctor_timeslots_available ON doctor_timeslots(is_available); 
CREATE INDEX idx_tokens_token ON tokens(token);
CREATE INDEX idx_tokens_expires ON tokens(expires_at);
CREATE INDEX idx_tokens_type ON tokens(token_type);

-- Sample data for users table
INSERT INTO users (name, phone, email, password, role, image_url) VALUES 
('John Admin', '555-123-4567', 'admin@hospital.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'admin', 'admin.jpg'),
('Jane Smith', '555-987-6543', 'jane@example.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'user', 'jane.jpg'),
('Robert Johnson', '555-456-7890', 'robert@example.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'user', 'robert.jpg'),
('Maria Garcia', '555-789-0123', 'maria@example.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'user', 'maria.jpg'),
('David Lee', '555-234-5678', 'david@example.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'user', 'david.jpg');

-- Sample data for departments table
INSERT INTO departments (name, description, image_url) VALUES
('Cardiology', 'Specializes in diagnosing and treating heart conditions', 'cardiology.jpg'),
('Neurology', 'Focuses on disorders of the nervous system', 'neurology.jpg'),
('Orthopedics', 'Deals with conditions involving the musculoskeletal system', 'orthopedics.jpg'),
('Pediatrics', 'Specializes in medical care for infants, children, and adolescents', 'pediatrics.jpg'),
('Dermatology', 'Focuses on conditions affecting the skin', 'dermatology.jpg');

-- Sample data for doctors table
INSERT INTO doctors (name, email, phone, qualification, specialization, experience, image_url) VALUES
('Dr. Michael Brown', 'michael@hospital.com', '555-111-2222', 'MD, FACC', 'Cardiologist', '15 years', 'dr_michael.jpg'),
('Dr. Sarah Wilson', 'sarah@hospital.com', '555-222-3333', 'MD, PhD', 'Neurologist', '12 years', 'dr_sarah.jpg'),
('Dr. James Taylor', 'james@hospital.com', '555-333-4444', 'MD, FAAOS', 'Orthopedic Surgeon', '10 years', 'dr_james.jpg'),
('Dr. Emily Davis', 'emily@hospital.com', '555-444-5555', 'MD, FAAP', 'Pediatrician', '8 years', 'dr_emily.jpg'),
('Dr. Thomas Miller', 'thomas@hospital.com', '555-555-6666', 'MD, FAAD', 'Dermatologist', '11 years', 'dr_thomas.jpg');

-- Sample data for doctor_departments table
INSERT INTO doctor_departments (doctor_id, department_id) VALUES
(1, 1), -- Dr. Michael (Cardiology)
(2, 2), -- Dr. Sarah (Neurology)
(3, 3), -- Dr. James (Orthopedics)
(4, 4), -- Dr. Emily (Pediatrics)
(5, 5); -- Dr. Thomas (Dermatology)

-- Sample data for timeslots table
INSERT INTO timeslots (slot_date, start_time, end_time) VALUES
('2023-06-01', '09:00:00', '10:00:00'),
('2023-06-01', '10:00:00', '11:00:00'),
('2023-06-01', '11:00:00', '12:00:00'),
('2023-06-01', '14:00:00', '15:00:00'),
('2023-06-01', '15:00:00', '16:00:00'),
('2023-06-02', '09:00:00', '10:00:00'),
('2023-06-02', '10:00:00', '11:00:00'),
('2023-06-02', '11:00:00', '12:00:00'),
('2023-06-02', '14:00:00', '15:00:00'),
('2023-06-02', '15:00:00', '16:00:00');

-- Sample data for doctor_timeslots table
INSERT INTO doctor_timeslots (doctor_id, timeslot_id, is_available) VALUES
(1, 1, true),
(1, 2, true),
(1, 6, true),
(1, 7, true),
(2, 3, true),
(2, 4, true),
(2, 8, true),
(2, 9, true),
(3, 1, true),
(3, 5, true),
(3, 6, true),
(3, 10, true),
(4, 2, true),
(4, 3, true),
(4, 7, true),
(4, 8, true),
(5, 4, true),
(5, 5, true),
(5, 9, true),
(5, 10, true);

-- Sample data for appointments table
INSERT INTO appointments (user_id, doctor_id, time_slot, appointment_date, note, status) VALUES
(2, 1, 1, '2023-06-01', 'Annual checkup for heart condition', 'confirmed'),
(3, 2, 4, '2023-06-01', 'Follow-up on migraine treatment', 'pending'),
(4, 3, 6, '2023-06-02', 'Knee pain consultation', 'confirmed'),
(5, 4, 8, '2023-06-02', 'Child vaccination appointment', 'confirmed'),
(2, 5, 10, '2023-06-02', 'Skin rash examination', 'pending');

-- Change availability for booked slots
UPDATE doctor_timeslots SET is_available = false WHERE (doctor_id = 1 AND timeslot_id = 1) 
                                                    OR (doctor_id = 2 AND timeslot_id = 4)
                                                    OR (doctor_id = 3 AND timeslot_id = 6)
                                                    OR (doctor_id = 4 AND timeslot_id = 8)
                                                    OR (doctor_id = 5 AND timeslot_id = 10); 