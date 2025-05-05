<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctors - Hospital Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #f0f7ff;
            --dark: #1e293b;
            --gray: #64748b;
            --light-gray: #f8fafc;
            --border: #e2e8f0;
            --white: #ffffff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            --shadow-hover: 0 8px 15px rgba(0, 0, 0, 0.1);
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
            background-color: var(--light-gray);
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 1rem;
            background: linear-gradient(to right, var(--dark) 0%, var(--primary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-header p {
            color: var(--gray);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .search-section {
            background: var(--white);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            margin-bottom: 3rem;
        }

        .search-form {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 200px;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--gray);
            font-weight: 500;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            gap: 0.5rem;
            border: none;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .doctor-card {
            background: var(--white);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            border: 1px solid var(--border);
        }

        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
            border-color: var(--primary);
        }

        .doctor-image {
            width: 100%;
            height: 250px;
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f8fafc;
        }

        .doctor-image img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .doctor-card:hover .doctor-image img {
            transform: scale(1.05);
        }

        .doctor-info {
            padding: 1.5rem;
        }

        .doctor-info h3 {
            color: var(--dark);
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .doctor-info .specialization {
            color: var(--primary);
            font-size: 1rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .doctor-info .qualification {
            color: var(--gray);
            font-size: 0.95rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .no-results {
            text-align: center;
            padding: 3rem;
            background: var(--white);
            border-radius: 15px;
            box-shadow: var(--shadow);
        }

        .no-results p {
            color: var(--gray);
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 1.5rem 1rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .search-form {
                flex-direction: column;
            }

            .form-group {
                width: 100%;
            }

            .doctors-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container">
        <div class="page-header">
            <h1>Our Doctors</h1>
            <p>Meet our team of experienced and dedicated healthcare professionals</p>
        </div>
        
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/doctors" method="get" class="search-form">
                <div class="form-group">
                    <label for="specialization">Specialization</label>
                    <select id="specialization" name="specialization" class="form-control">
                        <option value="">All Specializations</option>
                        <c:forEach var="spec" items="${specializations}">
                            <option value="${spec}" ${param.specialization == spec ? 'selected' : ''}>${spec}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="search">Search</label>
                    <input type="text" id="search" name="search" class="form-control" 
                           placeholder="Search by name..." value="${param.search}">
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i>
                        Search
                    </button>
                </div>
            </form>
        </div>
        
        <div class="doctors-grid">
            <c:forEach var="doctor" items="${doctors}">
                <div class="doctor-card">
                    <div class="doctor-image">
                        <c:choose>
                            <c:when test="${not empty doctor.imageUrl}">
                                <img src="${pageContext.request.contextPath}/${doctor.imageUrl}" alt="${doctor.name}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/default-doctor.jpg" alt="${doctor.name}">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="doctor-info">
                        <h3>${doctor.name}</h3>
                        <div class="specialization">
                            <i class="fas fa-stethoscope"></i>
                            ${doctor.specialization}
                        </div>
                        <div class="qualification">
                            <i class="fas fa-graduation-cap"></i>
                            ${doctor.qualification}
                        </div>
                        <a href="${pageContext.request.contextPath}/doctors?action=view&id=${doctor.id}" 
                           class="btn btn-primary">
                           <i class="fas fa-calendar-alt"></i>
                           Book Appointment
                        </a>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty doctors}">
                <div class="no-results">
                    <p>No doctors found matching your criteria.</p>
                    <a href="${pageContext.request.contextPath}/doctors" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i>
                        Reset Search
                    </a>
                </div>
            </c:if>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html> 