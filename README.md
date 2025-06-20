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

##🖼️ Screenshots
### 🔐 Sign Up Page[signin](images/signin.png)

### 🔐 Sign Up Page[signup](images/signup.png)

### 🔐 Admin Dashboard Page[admin-dashboard](images/admindash.png)

### 🔐 All Complaints View[all-complaints ](images/allcomplainttable.png)

### 🔐 Update Complaint[update-complaints](images/updatecomplaint.png)

### 🔐 Delete Complaint[delete-complaints](images/deletecomplaint.png)

### 👤 Employee Dashboard[employee-dashboard](images/employeedash.png)

### 📝 Submit New Complaint[submit-complaint](images/submitcomplaint.png)

### 📋 View Employee-vise Complaints[view-employeevise-complaints](images/getall.png)



## ⚙️ Installation

### Prerequisites
- Java JDK 17+
- Apache Tomcat 10.0.x
- MySQL 8.0+

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/complaint-management-system.git
cd complaint-management-system
```

### Step 2: Configure Tomcat
Deploy the generated WAR file into the webapps folder, or

Use your IDE (IntelliJ, Eclipse) to run the project with Tomcat.

### Step 3: Install Dependencies (if using Maven)
### Step 4: Build the Project

🛢️ Database Setup
1. Create the Database
2. Create Tables
3. Configure DB Connection


---

### ✅ Final Notes:

- Replace `yourusername` in the Git URL with your actual GitHub username.
- Replace `'hashed_password_here'` with a real hashed password.
- Upload your screenshots to the `images/` folder and rename accordingly.
- Ensure the servlet mappings match your actual project URLs.

Let me know if you’d like a version with clickable links for GitHub or a PDF export.





