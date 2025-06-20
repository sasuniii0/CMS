# Complaint Management System (CMS)

A synchronous, form-based complaint management system built with **Jakarta EE**, following the **MVC architecture**. This system allows **employees** to submit and manage complaints, while providing **administrators** with tools to oversee and resolve them.

---

## 📑 Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Screenshots](#screenshots)
- [License](#license)

---

## ✅ Features

### 🔐 Authentication Module
- **User Login**: Secure login with session management.
- **Role-Based Access Control**:
  - **Employee**: Submit and manage personal complaints.
  - **Admin**: Manage all complaints and users.

### 📝 Complaint Management

#### Employee Role
- Submit new complaints.
- View personal complaint list.
- Edit or delete unresolved complaints.

#### Admin Role
- View all complaints.
- Update complaint status (OPEN/RESOLVED).
- Add remarks to any complaint.
- Delete any complaint.

---

## 💻 Technology Stack

### Frontend
- JSP (JavaServer Pages)
- HTML5, CSS3
- JavaScript (only for form validation)

### Backend
- Jakarta EE 9.1 (Servlets, JSP, JSTL)
- Apache Commons DBCP 2.9.0

### Database
- MySQL 8.0+

### Server
- Apache Tomcat 10.0.x

---

## 🧱 Architecture

### MVC Pattern

- **Model**: DTOs and DAO classes (e.g., `ComplaintDTO`, `ComplaintModel`)
- **View**: JSP pages
- **Controller**: Servlets (e.g., `LoginServlet`, `DashboardServlet`, `ComplaintServlet`)

### HTTP Method Usage
- `POST`: For state-changing operations (submit, update, delete)
- `GET`: For read-only operations (login page, dashboard, list)
- **No AJAX**: Fully synchronous form submissions

---

## ⚙️ Installation

### Prerequisites
- Java JDK 17+
- Apache Tomcat 10.0.x
- MySQL 8.0+

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/complaint-management-system.git
cd complaint-management-system
