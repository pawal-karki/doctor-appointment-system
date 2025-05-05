<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${doctor.name} - Hospital Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px 15px;
        }
        
        .doctor-profile {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin: 40px auto;
        }
        
        .doctor-header {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .doctor-image {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            overflow: hidden;
            background-color: #f8f9fa;
        }
        
        .doctor-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .doctor-info {
            flex: 1;
        }
        
        .doctor-info h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .doctor-specialization {
            color: #666;
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .doctor-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .doctor-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .detail-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        
        .detail-section h3 {
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .detail-list {
            list-style: none;
        }
        
        .detail-list li {
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }
        
        .detail-list li i {
            margin-right: 10px;
            color: #007bff;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
        
        .btn-block {
            display: block;
            width: 100%;
            text-align: center;
        }
        
        .schedule-section {
            margin-top: 30px;
        }
        
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .schedule-table th,
        .schedule-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .schedule-table th {
            background-color: #f8f9fa;
            color: #2c3e50;
        }
        
        .schedule-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .appointment-section {
            background: #ffffff;
            border-radius: 16px;
            padding: 32px;
            margin-top: 40px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }
        
        .appointment-section h2 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 24px;
            font-weight: 600;
            position: relative;
            padding-bottom: 12px;
        }
        
        .appointment-section h2:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: #3498db;
            border-radius: 2px;
        }
        
        .date-selection {
            display: flex;
            gap: 16px;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
        }
        
        .date-input-container {
            position: relative;
            flex: 1;
            min-width: 250px;
        }
        
        .date-input {
            width: 100%;
            padding: 12px 16px;
            padding-right: 40px;
            font-size: 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            background-color: #f8fafc;
            transition: all 0.3s ease;
            color: #2c3e50;
        }
        
        .date-input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: #ffffff;
        }
        
        .date-input::-webkit-calendar-picker-indicator {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            opacity: 0.6;
            transition: opacity 0.3s ease;
        }
        
        .date-input::-webkit-calendar-picker-indicator:hover {
            opacity: 1;
        }
        
        .check-availability-btn {
            padding: 12px 24px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        
        .check-availability-btn:hover {
            background: #2980b9;
            transform: translateY(-1px);
        }
        
        .check-availability-btn:active {
            transform: translateY(0);
        }
        
        .available-slots {
            margin-top: 32px;
        }
        
        .available-slots h3 {
            color: #2c3e50;
            font-size: 1.3rem;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .slots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px;
        }
        
        .slot-card {
            background: #ffffff;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .slot-card:hover {
            border-color: #3498db;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        
        .slot-time {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 12px;
        }
        
        .book-btn {
            display: inline-block;
            padding: 8px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .book-btn:hover {
            background: #2980b9;
            transform: translateY(-1px);
        }
        
        .no-results {
            text-align: center;
            padding: 40px;
            background: #f8fafc;
            border-radius: 12px;
            color: #64748b;
        }
        
        .login-prompt {
            text-align: center;
            padding: 40px;
            background: #f8fafc;
            border-radius: 12px;
        }
        
        .login-prompt p {
            color: #64748b;
            margin-bottom: 16px;
        }
        
        .login-prompt a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .login-prompt a:hover {
            color: #2980b9;
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .appointment-section {
                padding: 24px;
            }
            
            .date-selection {
                flex-direction: column;
            }
            
            .date-input-container {
                width: 100%;
            }
            
            .check-availability-btn {
                width: 100%;
            }
            
            .slots-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="container">
        <div class="doctor-profile">
            <div class="doctor-header">
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
                    <h1>${doctor.name}</h1>
                    <p class="doctor-specialization">${doctor.specialization}</p>
                    <p class="doctor-qualification">${doctor.qualification}</p>
                    <p class="doctor-experience">Experience: ${doctor.experience}</p>
                    <p class="doctor-contact">Email: ${doctor.email}</p>
                    <p class="doctor-contact">Phone: ${doctor.phone}</p>
                </div>
            </div>
            
            <div class="appointment-section">
                <h2>Book an Appointment</h2>
                
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <div class="login-prompt">
                            <p>Please <a href="${pageContext.request.contextPath}/login">login</a> to book an appointment.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/doctors" method="post">
                            <input type="hidden" name="action" value="getSlots">
                            <input type="hidden" name="doctorId" value="${doctor.id}">
                            
                            <div class="date-selection">
                                <div class="date-input-container">
                                    <input 
                                        type="date" 
                                        id="date" 
                                        name="date" 
                                        value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>" 
                                        min="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>" 
                                        required
                                        class="date-input">
                                </div>
                                <button type="submit" class="check-availability-btn">
                                    Check Availability
                                </button>
                            </div>
                        </form>
                        
                        <c:if test="${not empty availableSlots}">
                            <div class="available-slots">
                                <h3>Available Slots for <fmt:formatDate value="${selectedDate}" pattern="MMMM dd, yyyy"/></h3>
                                
                                <div class="slots-grid">
                                    <c:forEach var="slot" items="${availableSlots}">
                                        <div class="slot-card">
                                            <p class="slot-time">${slot.startTime} - ${slot.endTime}</p>
                                            <a href="${pageContext.request.contextPath}/appointments?action=book&doctorId=${doctor.id}&date=<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>&slotId=${slot.id}" 
                                               class="book-btn">Book Now</a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${empty availableSlots}">
                            <div class="no-results">
                                <p>No available slots for this date.</p>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
</body>
</html>
