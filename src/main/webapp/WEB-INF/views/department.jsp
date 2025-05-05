<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Departments - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #f0f7ff;
            --dark: #1e293b;
            --gray: #64748b;
            --light-gray: #f8fafc;
            --border: #e2e8f0;
            --white: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Inter", sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background-color: var(--white);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.5rem 2rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.5rem;
            letter-spacing: -0.02em;
        }

        .page-title::after {
            content: "";
            display: block;
            width: 50px;
            height: 3px;
            background: var(--primary);
            margin: 0.5rem auto 0;
            border-radius: 2px;
        }

        .search-section {
            max-width: 600px;
            margin: 0 auto 2rem;
        }

        .search-box {
            position: relative;
            margin-bottom: 0;
        }

        .search-input {
            width: 100%;
            padding: 0.875rem 1.25rem;
            padding-left: 2.75rem;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 0.95rem;
            color: var(--dark);
            background-color: var(--white);
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
            font-size: 1.2rem;
        }

        .departments-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
        }

        .department-card {
            background: var(--white);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02);
            transition: all 0.3s ease;
            border: 1px solid var(--border);
            position: relative;
            height: 520px;
        }

        .department-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            border-color: var(--primary);
        }

        .department-image {
            width: 100%;
            height: 200px;
            position: relative;
            overflow: hidden;
            background: var(--light-gray);
        }

        .department-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .department-card:hover .department-image img {
            transform: scale(1.05);
        }

        .department-content {
            padding: 2rem;
            text-align: center;
            position: relative;
            height: calc(100% - 200px);
        }

        .department-info {
            margin-bottom: 4rem;
        }

        .department-icon {
            width: 56px;
            height: 56px;
            background: var(--primary-light);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: -3rem auto 1.25rem;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
        }

        .department-icon i {
            font-size: 1.5rem;
            color: var(--primary);
            transition: all 0.3s ease;
        }

        .department-card:hover .department-icon {
            background: var(--primary);
            transform: scale(1.1) rotate(8deg);
        }

        .department-card:hover .department-icon i {
            color: var(--white);
        }

        .department-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.75rem;
        }

        .department-description {
            color: var(--gray);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 0;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all 0.3s ease;
            gap: 0.5rem;
            width: auto;
            min-width: 160px;
            position: absolute;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%);
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
        }

        .no-departments {
            grid-column: 1 / -1;
            text-align: center;
            padding: 4rem;
            background: var(--white);
            border-radius: 20px;
            border: 1px solid var(--border);
        }

        .no-departments p {
            color: var(--gray);
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 1200px) {
            .departments-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem 1.25rem;
            }

            .page-title {
                font-size: 1.75rem;
            }

            .departments-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .department-card {
                height: 480px;
            }

            .department-image {
                height: 180px;
            }

            .department-content {
                padding: 1.5rem;
                height: calc(100% - 180px);
            }

            .department-info {
                margin-bottom: 3.5rem;
            }

            .btn {
                bottom: 1.5rem;
            }

            .department-icon {
                width: 48px;
                height: 48px;
                margin: -2.5rem auto 1rem;
            }

            .search-section {
                margin-bottom: 1.5rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="includes/header.jsp" />

<div class="container">
    <div class="page-header">
        <h1 class="page-title">Our Departments</h1>
    </div>

    <div class="search-section">
        <form action="${pageContext.request.contextPath}/departments" method="get">
            <input type="hidden" name="action" value="search" />
            <div class="search-box">
                <i class="fas fa-search search-icon"></i>
                <input
                        type="text"
                        name="keyword"
                        class="search-input"
                        placeholder="Search departments..."
                        value="${keyword}"
                />
            </div>
        </form>
    </div>

    <div class="departments-grid">
        <c:forEach var="department" items="${departments}">
            <div class="department-card">
                <div class="department-image">
                    <c:choose>
                        <c:when test="${not empty department.imageUrl}">
                            <img src="${pageContext.request.contextPath}/${department.imageUrl}"
                                 alt="${department.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default-department.jpg"
                                 alt="${department.name}">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="department-content">
                    <div class="department-info">
                        <div class="department-icon">
                            <i class="${department.name eq 'Cardiology' ? 'fas fa-heartbeat' :
                            department.name eq 'Neurology' ? 'fas fa-brain' :
                            department.name eq 'Pediatrics' ? 'fas fa-baby' :
                            department.name eq 'Orthopedics' ? 'fas fa-bone' :
                            department.name eq 'Dental' ? 'fas fa-tooth' :
                            department.name eq 'Ophthalmology' ? 'fas fa-eye' :
                            'fas fa-stethoscope'}"></i>
                        </div>
                        <h3 class="department-title">${department.name}</h3>
                        <p class="department-description">${department.description}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/departments?action=view&id=${department.id}"
                       class="btn btn-primary">
                        <i class="fas fa-user-md"></i> View Doctors
                    </a>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty departments}">
            <div class="no-departments">
                <p>No departments found matching your search.</p>
                <a href="${pageContext.request.contextPath}/departments" class="btn btn-primary">
                    <i class="fas fa-sync"></i> Reset Search
                </a>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>
