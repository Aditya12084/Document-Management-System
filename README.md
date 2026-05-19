# Document Management System (DMS)

A secure and scalable Document Management System developed using Java, Spring Boot, JSP, and MySQL. The application enables users to upload, manage, and track documents efficiently with role-based access control.

## Features

* Secure document upload and management
* Role-Based Access Control (RBAC) for Admin and User
* Separate Admin/User dashboards
* Document status tracking workflow
* MVC architecture with DTO pattern
* Scalable backend service layer
* MySQL database integration

## Tech Stack

* Java
* Spring Boot
* JSP
* MySQL
* HTML/CSS
* Maven

## Modules

* User Authentication & Authorization
* Document Upload & Management
* Admin Dashboard
* User Dashboard
* Activity/System Logs

## Database

The project uses MySQL for storing:

* User details
* Roles & permissions
* Document metadata
* Status logs

## How to Run

1. Clone the repository
2. Configure MySQL database in `application.properties`
3. Run the Spring Boot application
4. Open in browser:

   ```bash
   http://localhost:8080
   ```

## Future Enhancements

* Email notifications
* Cloud file storage integration
* Document sharing via secure links
* Advanced search & filtering
