# 🏥 Doctor Appointment | Hospital Management System

A web-based application that allows patients to book appointments with doctors, manage schedules Built using **Java Servlets**, **JSP**, and **Maven**, the system follows an MVC architecture and supports multi-role access: **Admin**, **Patient**

---

## 🧰 Technologies Used

- **Java EE** (Servlets, JSP)
- **Maven** (Project management and build)
- **JDBC** (Database interaction)
- **MySQL / Oracle DB** (Configurable in `database.properties`)
- **HTML, CSS, JSTL** (Frontend)
- **Tomcat 9+** (Recommended deployment)

---


## 📁 Project Structure


```plaintext
javadoctorappointmentsystem/
├── src/
│   ├── main/
│   │   ├── java/com/hospital/
│   │   │   ├── controller/        # Servlet controllers
│   │   │   ├── dao/              # Data Access Objects
│   │   │   ├── model/            # POJOs for domain objects
│   │   │   ├── filter/           # Servlet filters for auth/logging
│   │   │   ├── util/             # Utility classes
│   │   │   ├── scheduler/        # Background tasks
│   │   │   └── listener/         # Application lifecycle listeners
│   ├── resources/
│   │   ├── database.properties   # DB config
│   │   └── schema.sql            # SQL schema
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── views/
│       │   │   ├── admin/        # Admin-specific JSPs
│       │   │   ├── includes/     # Header/footer etc.
│       │   │   └── my-appointments.jsp
│       │   └── web.xml           # Deployment descriptor
│       ├── css/                  # Stylesheets
│       ├── uploads/              # Uploaded documents
│       └── index.jsp             # Landing/login page
├── test/                         # Test cases
├── target/                       # Build output
└── pom.xml                       # Maven config file
```
#Project Images
![Image](https://github.com/user-attachments/assets/08a936eb-10c7-493b-8878-29b454d998e9)
![Image](https://github.com/user-attachments/assets/cbb517e7-9dd0-47b1-8edf-a4ccf19bff4a)
![Image](https://github.com/user-attachments/assets/740f2c8a-66c9-4411-8169-ee4e9e367c7a)
![Image](https://github.com/user-attachments/assets/11fbcb86-9690-451f-89b6-4a8f1daafc41)
![Image](https://github.com/user-attachments/assets/a833fd99-dde6-4455-997e-d400bf63ee00)
![Image](https://github.com/user-attachments/assets/dd47a429-6e79-48ce-99a0-d810961f14a1)
