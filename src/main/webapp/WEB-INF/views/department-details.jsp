<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${department.name} - Hospital Management System</title>
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
            background-color: var(--light-gray);
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .department-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeInUp 0.8s ease-out;
        }

        .department-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 1rem;
            background: linear-gradient(to right, var(--dark) 0%, var(--primary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .department-header p {
            color: var(--gray);
            max-width: 800px;
            margin: 0 auto;
            font-size: 1.1rem;
        }

        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            animation: fadeInUp 0.8s ease-out 0.2s backwards;
        }

        .doctor-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid var(--border);
        }

        .doctor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
            border-color: var(--primary);
        }

        .doctor-image {
            width: 100%;
            height: 200px;
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
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .doctor-info .specialization {
            color: var(--primary);
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .doctor-info .qualification {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-weight: 500;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            gap: 0.5rem;
            width: 100%;
            justify-content: center;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
        }

        .no-doctors {
            text-align: center;
            padding: 3rem 2rem;
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-top: 2rem;
            animation: fadeInUp 0.8s ease-out;
        }

        .no-doctors p {
            color: var(--gray);
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 1.5rem 1rem;
            }

            .department-header h1 {
                font-size: 2rem;
            }

            .department-header p {
                font-size: 1rem;
            }

            .doctors-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .doctor-info {
                padding: 1.25rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container">
        <div class="department-header">
            <h1>${department.name}</h1>
            <p>${department.description}</p>
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
                <div class="no-doctors">
                    <p>No doctors found in this department.</p>
                    <a href="${pageContext.request.contextPath}/departments" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i>
                        Back to Departments
                    </a>
                </div>
            </c:if>
        </div>
    </div>
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
