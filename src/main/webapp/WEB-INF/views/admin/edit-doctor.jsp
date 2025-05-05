<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Doctor - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --secondary-color: #64748b;
            --background-color: #f8fafc;
            --text-color: #1e293b;
            --error-bg: #fee2e2;
            --error-text: #dc2626;
            --success-bg: #dcfce7;
            --success-text: #16a34a;
            --border-radius: 0.5rem;
            --transition: all 0.3s ease;
            --card-bg: #fff;
            --card-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1),
                0 2px 4px -2px rgb(0 0 0 / 0.1);
            --sidebar-width: 250px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI",
                Roboto, sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--background-color);
            min-height: 100vh;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-content {
            flex: 1;
            margin-left: var(--sidebar-width);
        }

        .content-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 2rem 2rem;
        }

        .card {
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 2rem;
        }

        .card h1 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text-color);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-color);
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .alert-success {
            background-color: var(--success-bg);
            color: var(--success-text);
            border: 1px solid var(--success-text);
        }

        .alert-danger {
            background-color: var(--error-bg);
            color: var(--error-text);
            border: 1px solid var(--error-text);
        }

        .current-image {
            margin-top: 1rem;
        }

        .current-image img {
            max-width: 200px;
            border-radius: var(--border-radius);
        }
        
        @media (max-width: 768px) {
            .admin-content {
                margin-left: 0;
            }
            
            .content-container {
                padding: 0 1rem 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="includes/sidebar.jsp" />
        
        <div class="admin-content">
            <jsp:include page="includes/header.jsp" />
            
            <div class="content-container">
                <div class="card">
                    <h1>Edit Doctor</h1>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/doctors" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="${doctor.id}">

                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="${doctor.name}" required>
                        </div>

                        <div class="form-group">
                            <label for="specialization">Specialization</label>
                            <input type="text" id="specialization" name="specialization" value="${doctor.specialization}" required>
                        </div>

                        <div class="form-group">
                            <label for="qualification">Qualification</label>
                            <input type="text" id="qualification" name="qualification" value="${doctor.qualification}" required>
                        </div>

                        <div class="form-group">
                            <label for="experience">Experience</label>
                            <input type="text" id="experience" name="experience" value="${doctor.experience}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${doctor.email}" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="tel" id="phone" name="phone" value="${doctor.phone}" required>
                        </div>

                        <div class="form-group">
                            <label for="departmentId">Department</label>
                            <select id="departmentId" name="departmentId" required>
                                <option value="">Select Department</option>
                                <c:forEach var="department" items="${departments}">
                                    <option value="${department.id}" ${department.id == doctor.departmentId ? 'selected' : ''}>
                                        ${department.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="image">Profile Image</label>
                            <input type="file" id="image" name="image" accept="image/*">
                            <c:if test="${not empty doctor.imageUrl}">
                                <div class="current-image">
                                    <p>Current Image:</p>
                                    <img src="${pageContext.request.contextPath}/${doctor.imageUrl}" alt="Current Doctor Image">
                                </div>
                            </c:if>
                        </div>

                        <button type="submit" class="btn btn-primary">Update Doctor</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>