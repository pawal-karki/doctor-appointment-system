<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctors - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --primary-light: #dbeafe;
            --secondary-color: #64748b;
            --background-color: #f8fafc;
            --text-color: #1e293b;
            --text-muted: #94a3b8;
            --error-bg: #fee2e2;
            --error-text: #dc2626;
            --success-bg: #dcfce7;
            --success-text: #16a34a;
            --warning-bg: #fef3c7;
            --warning-text: #d97706;
            --border-radius: 0.5rem;
            --transition: all 0.3s ease;
            --card-bg: #fff;
            --card-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
            --card-shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --sidebar-width: 250px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem 2rem;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .content-header h1 {
            font-size: 1.875rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert i {
            font-size: 1.25rem;
        }

        .alert-success {
            background-color: var(--success-bg);
            color: var(--success-text);
            border-left: 4px solid var(--success-text);
        }

        .alert-danger {
            background-color: var(--error-bg);
            color: var(--error-text);
            border-left: 4px solid var(--error-text);
        }

        .card {
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: var(--transition);
            overflow: hidden;
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .card-body {
            padding: 0;
        }

        .search-filter {
            padding: 1rem 1.5rem;
            display: flex;
            gap: 1rem;
            border-bottom: 1px solid #e2e8f0;
            background-color: #f8fafc;
        }

        .search-input {
            flex: 1;
            position: relative;
        }

        .search-input input {
            width: 100%;
            padding: 0.625rem 1rem 0.625rem 2.5rem;
            border: 1px solid #e2e8f0;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            transition: var(--transition);
        }

        .search-input input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .search-input i {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
        }

        .filter-select select {
            padding: 0.625rem 2rem 0.625rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            background-color: white;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.5rem center;
            background-size: 1.25rem;
            appearance: none;
            transition: var(--transition);
        }

        .filter-select select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem 1.5rem;
            text-align: left;
        }

        th {
            font-weight: 600;
            color: var(--secondary-color);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            background-color: #f8fafc;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        tr {
            border-bottom: 1px solid #e2e8f0;
            transition: var(--transition);
        }

        tr:last-child {
            border-bottom: none;
        }

        tr:hover {
            background-color: #f1f5f9;
        }

        .doctor-img-small {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }

        .doctor-img-small img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .doctor-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .doctor-details {
            display: flex;
            flex-direction: column;
        }

        .doctor-name {
            font-weight: 600;
            color: var(--text-color);
        }

        .doctor-specialization {
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .doctor-department {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .doctor-contact {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .doctor-contact-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }

        .doctor-contact-item i {
            color: var(--secondary-color);
            width: 1rem;
            text-align: center;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
            cursor: pointer;
            border: none;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.75rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .btn-secondary {
            background-color: white;
            color: var(--text-color);
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background-color: #f8fafc;
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .btn-danger {
            background-color: white;
            color: var(--error-text);
            border: 1px solid #e2e8f0;
        }

        .btn-danger:hover {
            background-color: var(--error-bg);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .no-results {
            text-align: center;
            padding: 3rem;
            color: var(--text-muted);
            font-size: 1rem;
        }

        .no-results i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .pagination {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 1rem 1.5rem;
            border-top: 1px solid #e2e8f0;
            gap: 0.5rem;
        }

        .pagination-item {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 2rem;
            height: 2rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
            cursor: pointer;
            border: 1px solid #e2e8f0;
            color: var(--text-color);
        }

        .pagination-item:hover {
            background-color: #f8fafc;
        }

        .pagination-item.active {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        @media (max-width: 1024px) {
            .doctor-contact {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .admin-content {
                margin-left: 0;
            }

            .content-container {
                padding: 0 1rem 1rem;
            }

            .content-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .search-filter {
                flex-direction: column;
            }

            .card-body {
                overflow-x: auto;
            }

            table {
                min-width: 800px;
            }

            .doctor-department {
                display: none;
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
                <div class="content-header">
                    <h1>Doctors</h1>
                    <a href="${pageContext.request.contextPath}/admin/doctors?action=add" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Doctor
                    </a>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <div class="card">
                    <div class="card-header">
                        <h2>Doctor List</h2>
                    </div>
                    
                    <div class="search-filter">
                        <div class="search-input">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchDoctor" placeholder="Search doctors..." onkeyup="searchDoctors()">
                        </div>
                        
                        <div class="filter-select">
                            <select id="departmentFilter" onchange="filterDoctors()">
                                <option value="">All Departments</option>
                                <c:forEach var="department" items="${departments}">
                                    <option value="${department.id}">${department.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>Doctor</th>
                                    <th>Department</th>
                                    <th>Contact</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="doctorsTable">
                                <c:forEach var="doctor" items="${doctors}">
                                    <tr data-department="${doctor.departmentId}">
                                        <td>
                                            <div class="doctor-info">
                                                <div class="doctor-img-small">
                                                    <c:choose>
                                                        <c:when test="${not empty doctor.imageUrl}">
                                                            <img src="${pageContext.request.contextPath}/${doctor.imageUrl}" alt="${doctor.name}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/images/default-doctor.jpg" alt="${doctor.name}">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="doctor-details">
                                                    <span class="doctor-name">${doctor.name}</span>
                                                    <span class="doctor-specialization">${doctor.specialization}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="doctor-department">${departmentMap[doctor.departmentId].name}</span>
                                        </td>
                                        <td>
                                            <div class="doctor-contact">
                                                <div class="doctor-contact-item">
                                                    <i class="fas fa-envelope"></i>
                                                    <span>${doctor.email}</span>
                                                </div>
                                                <div class="doctor-contact-item">
                                                    <i class="fas fa-phone"></i>
                                                    <span>${doctor.phone}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/doctors?action=edit&id=${doctor.id}" class="btn btn-sm btn-secondary">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/doctors?action=delete&id=${doctor.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this doctor?')">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty doctors}">
                                    <tr>
                                        <td colspan="4" class="no-results">
                                            <i class="fas fa-user-md"></i>
                                            <p>No doctors found.</p>
                                            <a href="${pageContext.request.contextPath}/admin/doctors?action=add" class="btn btn-primary">
                                                <i class="fas fa-plus"></i> Add Doctor
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    
                    <c:if test="${not empty doctors && doctors.size() > 10}">
                        <div class="pagination">
                            <a href="#" class="pagination-item"><i class="fas fa-chevron-left"></i></a>
                            <a href="#" class="pagination-item active">1</a>
                            <a href="#" class="pagination-item">2</a>
                            <a href="#" class="pagination-item">3</a>
                            <a href="#" class="pagination-item"><i class="fas fa-chevron-right"></i></a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function searchDoctors() {
            const input = document.getElementById('searchDoctor');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('doctorsTable');
            const rows = table.getElementsByTagName('tr');
            const departmentFilter = document.getElementById('departmentFilter').value;
            
            let noResults = true;
            
            for (let i = 0; i < rows.length; i++) {
                const doctorInfo = rows[i].getElementsByClassName('doctor-info')[0];
                if (doctorInfo) {
                    const doctorName = doctorInfo.getElementsByClassName('doctor-name')[0].textContent;
                    const doctorSpecialization = doctorInfo.getElementsByClassName('doctor-specialization')[0].textContent;
                    const departmentId = rows[i].getAttribute('data-department');
                    
                    const matchesSearch = doctorName.toUpperCase().indexOf(filter) > -1 || 
                                         doctorSpecialization.toUpperCase().indexOf(filter) > -1;
                    const matchesDepartment = departmentFilter === '' || departmentId === departmentFilter;
                    
                    if (matchesSearch && matchesDepartment) {
                        rows[i].style.display = '';
                        noResults = false;
                    } else {
                        rows[i].style.display = 'none';
                    }
                }
            }
            
            // Show no results message if needed
            const noResultsRow = document.querySelector('.no-results');
            if (noResultsRow) {
                noResultsRow.style.display = noResults ? '' : 'none';
            }
        }
        
        function filterDoctors() {
            searchDoctors(); // Reuse the search function which also handles department filtering
        }
    </script>
</body>
</html>