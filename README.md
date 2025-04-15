# 🏥 Doctor Appointment | Hospital Management System

A web-based application that allows patients to book appointments with doctors, manage schedules Built using **Java Servlets**, **JSP**, and **Maven**, the system follows an MVC architecture and supports multi-role access: **Admin**, **Doctor**, and **Patient**.

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
