# 🦷 Sunrise Dental Clinic Management System

[![Java Version](https://img.shields.io/badge/Java-21%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10.0-F37024?style=for-the-badge&logo=eclipse-ide&logoColor=white)](https://jakarta.ee/)
[![Apache Tomcat](https://img.shields.io/badge/Tomcat-10.1%2B-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![JUnit 5](https://img.shields.io/badge/JUnit-5.10-25A162?style=for-the-badge&logo=junit5&logoColor=white)](https://junit.org/junit5/)

> A full-featured, enterprise-grade Java web application designed to streamline operations for dental clinics. The system provides role-based workspaces for **Administrators**, **Receptionists**, **Dentists**, and **Cashiers**, handling patient registration, dynamic appointment scheduling, clinical records, treatment logging, multi-tier billing, and automated email notifications.

---

## 📌 Table of Contents

- [Key Features by Role](#-key-features-by-role)
- [System Architecture](#-system-architecture)
- [Technology Stack](#-technology-stack)
- [Database Configuration](#-database-configuration)
- [Automated Testing (JUnit 5)](#-automated-testing-junit-5)
- [Installation & Setup](#-installation--setup)
- [Email Service Configuration (SMTP)](#-email-service-configuration-smtp)
- [Default Login Credentials](#-default-login-credentials)
- [Project Directory Structure](#-project-directory-structure)

---

## 🚀 Key Features by Role

### 👩‍💼 1. Receptionist Portal (`/reception/*`)
* **Patient Management:** Fast registration, profile editing, and live search by Name, Phone, Email, or Patient ID (`#PAT-xxx`).
* **Smart Appointment Booking:**
  * Real-time 30-minute interval availability checking via AJAX.
  * Same-day and advance schedule booking with automatic conflict avoidance.
  * Visual indicators for available (teal), fully booked (red), and past time slots (gray).
* **Schedule & Appointment Operations:** Reschedule appointments, process cancellations, filter by doctor or date, and resend confirmation notifications.
* **Patient Consultation Queue:** Live view of today's scheduled consultations.

---

### 👨‍⚕️ 2. Dentist Specialist Portal (`/dentist/*`)
* **Daily Consultation Schedule:** View assigned patient appointments categorized by status (`CONFIRMED`, `IN-PROGRESS`, `COMPLETED`, `CANCELLED`).
* **Clinical Records & History:** Inspect patient medical history, previous consultations, and dental notes.
* **Treatment & Diagnosis Logging:** Record dental procedures performed, add specialist observations, and update appointment progress.
* **Diagnostic Reports:** Upload and review clinical attachments and dental X-ray documents.
* **Availability Management:** Set weekly consultation working hours, room assignments, and patient capacity per slot.

---

### 💳 3. Cashier & Billing Portal (`/cashier/*`)
* **Automated Invoice Generation:** Automatically imports treatment base fees and specialist charges from completed appointments.
* **Multi-Item Billing Breakdown:**
  * Base treatment procedure fee.
  * Doctor/Specialist consultation fee.
  * Itemized additional charges (anesthesia, specialized dental materials, medicine).
  * Applicable clinic tax computation.
* **Flexible Payment Methods:** Supports **Cash**, **Credit/Debit Card**, and **Insurance Claims**.
* **Email Invoicing:** Automatically dispatches a formatted HTML receipt/invoice directly to the patient's email.

---

### 🛡️ 4. Administrator Portal (`/admin/*`)
* **Staff Management:** Create, update, deactivate, and manage roles for all clinic personnel (Dentists, Receptionists, Cashiers, Admins).
* **Doctor Time Slots & Schedules:** Global configuration of clinic operating hours, dental rooms, and appointment capacities.
* **Reports & Financial Analytics:** Comprehensive audit reports on appointment volume, revenue generated, and patient demographics.
* **Help Desk & Support:** Track inquiries and clinic system logs.

---

## 🏛 System Architecture

The project strictly follows the **Model-View-Controller (MVC)** design pattern combined with the **Data Access Object (DAO)** architectural pattern:

```
                            [ Web Browser / Client ]
                                       │
                              (HTTP / AJAX / HTTPS)
                                       │
                                       ▼
                   ┌───────────────────────────────────────┐
                   │       AuthenticationFilter            │
                   └──────────────────┬────────────────────┘
                                      │
                                      ▼
                   ┌───────────────────────────────────────┐
                   │    Controller Layer (Jakarta Servlets)│
                   └──────────────────┬────────────────────┘
                                      │
                                      ▼
                   ┌───────────────────────────────────────┐
                   │     Service Layer (Business Logic)    │
                   │  - AppointmentService, EmailService   │
                   └──────────────────┬────────────────────┘
                                      │
                                      ▼
                   ┌───────────────────────────────────────┐
                   │  Data Access Layer (DAO Interfaces)   │
                   │  - PatientDAO, DentistDAO, etc.       │
                   └──────────────────┬────────────────────┘
                                      │
                             (JDBC Connection Pool)
                                      │
                                      ▼
                   ┌───────────────────────────────────────┐
                   │          MySQL Database (3307)        │
                   └───────────────────────────────────────┘
```

---

## 🛠 Technology Stack

| Layer | Technologies Used |
| :--- | :--- |
| **Backend** | Java 21 (JDK 21), Jakarta Servlet 6.0, JSP, JSTL |
| **Persistence / Data** | MySQL 8.0+, JDBC Driver (`mysql-connector-j-26.7.0.jar`), Connection Pooling |
| **Mailing / Notifications** | Jakarta Mail 2.0.1 (`jakarta.mail-2.0.1.jar`), Jakarta Activation API |
| **Testing Framework** | JUnit 5 (Jupiter 5.10.x) Suite |
| **Frontend UI** | Modern CSS3 (CSS Variables, Flexbox, Grid), Google Fonts (Poppins), Bootstrap Icons, Vanilla JS (ES6+) |
| **Servlet Container** | Apache Tomcat 10.1+ |
| **IDE Compatibility** | Eclipse IDE for Enterprise Java and Web Developers / IntelliJ IDEA Ultimate |

---

## 🗄 Database Configuration

The application connects to a MySQL database named `sunrise_dental_clinic`.

### Connection Configuration (`DBConnection.java`)
```java
// Default Database Connection Properties:
URL      = "jdbc:mysql://localhost:3307/sunrise_dental_clinic?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
USERNAME = "root";
PASSWORD = "Theek@2004#0117";
```

> **Note:** If your MySQL server runs on default port `3306`, update the URL in [`src/main/java/com/sunrise/dental/util/DBConnection.java`](src/main/java/com/sunrise/dental/util/DBConnection.java).

### Primary Database Tables
* `patient` – Patient demographics, contact info, and medical remarks.
* `dentist` – Dentist credentials, specialization, assigned room, and status.
* `staff` – Administrative, reception, and cashier user accounts with encrypted credentials.
* `dentist_availability` – Doctor schedules, date windows, and slot limits.
* `appointment` – Patient appointments, status, assigned times, and reference numbers.
* `treatment_type` – Catalog of dental procedures and standard base costs.
* `treatment` – Clinical records of performed procedures, notes, and prescribed follow-ups.
* `payment` – Invoice numbers, billing breakdowns, payment methods, and timestamps.
* `payment_additional_charge` – Itemized line-item charges per invoice.
* `patient_report` – Uploaded clinical attachments and diagnostic documents.

---

## 🧪 Automated Testing (JUnit 5)

The project includes an end-to-end DAO test suite verifying database connectivity, CRUD operations, query integrity, and constraints:

| Test ID | Test Class | Tested Module / Scope |
| :--- | :--- | :--- |
| **J01** | `J01_DBConnectionTest.java` | Verifies active MySQL driver loading and live connection ping |
| **J02** | `J02_DentistDaoTest.java` | Tests dentist profile lookups, specialization filters, and active queries |
| **J03** | `J03_PatientDaoTest.java` | Tests patient registration, email validation, and profile updates |
| **J04** | `J04_TreatmentTypeDaoTest.java` | Tests active dental procedure catalogs and base fee lookups |
| **J05** | `J05_AppointmentDaoTest.java` | Tests appointment booking persistence and sequential ID generation |
| **J06** | `J06_StaffDaoTest.java` | Tests staff authentication, role permissions, and active statuses |
| **J07** | `J07_DentistAvailabilityDaoTest.java` | Tests doctor schedule queries, slot limits, and date matching |
| **J08** | `J08_PatientReportDaoTest.java` | Tests medical report metadata and clinical attachment queries |
| **J09** | `J09_PaymentDaoTest.java` | Tests invoice generation, payment records, and line-item charges |
| **J10** | `J10_TreatmentDaoTest.java` | Tests treatment diagnosis persistence and medical record history |

### Running the Tests in Eclipse:
1. Right-click the `src/main/java/com/sunrise/dental/test` package.
2. Select **Run As** $\rightarrow$ **JUnit Test**.
3. All 10 test suites will execute with 100% Green Bar status.

---

## ⚙️ Installation & Setup

### Prerequisites
* **Java Development Kit (JDK):** Version 17 or 21+
* **Database:** MySQL Server 8.0+
* **Server:** Apache Tomcat 10.1+ (Jakarta EE 10 compliant)
* **IDE:** Eclipse IDE for Enterprise Java Developers

### Step-by-step Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/Theek0117/sunrise-dental-clinic-system.git
   ```
2. **Import into Eclipse:**
   - Open Eclipse $\rightarrow$ **File** $\rightarrow$ **Import...**
   - Choose **General** $\rightarrow$ **Existing Projects into Workspace**.
   - Select the cloned `SunriseDentalClinic` root directory.
3. **Configure Tomcat 10.1 Server Runtime:**
   - In Eclipse, open the **Servers** tab $\rightarrow$ **New Server**.
   - Select **Apache Tomcat v10.1** and point to your local Tomcat installation.
   - Right-click Tomcat $\rightarrow$ **Add and Remove...** $\rightarrow$ Add `SunriseDentalClinic`.
4. **Deploy & Launch:**
   - Start the Tomcat server.
   - Access the clinic home page at:
     ```
     http://localhost:8080/SunriseDentalClinic/
     ```

---

## 📧 Email Service Configuration (SMTP)

The application includes a **Dual-Mode Email Dispatch System**:

* **Production Mode (Live SMTP):** If credentials are configured, emails (appointment confirmations, rescheduling notices, invoices) are dispatched via secure TLS SMTP.
* **Development Mode (Simulated Notification):** If SMTP credentials are blank or the environment is offline, emails are generated, validated, and logged to the console without blocking clinic workflows.

### Enabling Live Gmail SMTP:
Set the following environment variables or Java System Properties:

```properties
SUNRISE_SMTP_HOST=smtp.gmail.com
SUNRISE_SMTP_PORT=587
SUNRISE_SMTP_USERNAME=yourclinicemail@gmail.com
SUNRISE_SMTP_PASSWORD=your-google-app-password
SUNRISE_EMAIL_FROM=yourclinicemail@gmail.com
SUNRISE_EMAIL_NAME=Sunrise Dental Clinic
```

---

## 🔑 Default Login Credentials

| Role | Username | Password | Dashboard URL |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin` | `Admin@123` | `/admin/dashboard` |
| **Receptionist** | `receptionist` | `Reception@123` | `/reception/dashboard` |
| **Dentist Specialist** | `dentist` | `Dentist@123` | `/dentist/dashboard` |
| **Cashier / Billing** | `cashier` | `Cashier@123` | `/cashier/dashboard` |

---

## 📂 Project Directory Structure

```
SunriseDentalClinic/
├── README.md
├── .classpath
├── .project
└── src/
    └── main/
        ├── java/
        │   └── com/sunrise/dental/
        │       ├── controller/        # Jakarta Servlets (Admin, Reception, Dentist, Cashier)
        │       ├── dao/               # Data Access Objects (Interfaces & Implementations)
        │       ├── model/             # POJO Domain Entities (Patient, Appointment, Bill, etc.)
        │       ├── service/           # Business Services (AppointmentService, EmailService)
        │       ├── test/              # JUnit 5 Test Suite (J01 - J10)
        │       └── util/              # Database Connectivity & Utilities
        └── webapp/
            ├── META-INF/
            ├── WEB-INF/
            │   ├── lib/               # MySQL Connector, Jakarta Mail & Activation JARs
            │   └── web.xml            # Web Application Deployment Descriptor
            ├── admin/                 # Administrator JSP views
            ├── cashier/               # Cashier & Billing JSP views
            ├── dentist/               # Dentist Portal JSP views
            ├── reception/             # Receptionist Portal JSP views
            ├── css/                   # Stylesheets
            ├── js/                    # Client-side JavaScript & AJAX Handlers
            ├── images/                # Clinic branding, logos, and UI assets
            ├── index.jsp              # Public landing page
            ├── login.jsp              # Clinic staff authentication portal
            └── contact.jsp            # Clinic contact & inquiry page
```

---

## 👥 Authors & Acknowledgments

* **Development:** Sunrise Dental Clinic Development Team
* **Institution:** Computing & Software Engineering Division

---

<p align="center">
  <sub>© 2026 Sunrise Dental Clinic System. All rights reserved.</sub>
</p>
