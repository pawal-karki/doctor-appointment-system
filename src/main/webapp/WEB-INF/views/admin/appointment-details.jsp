<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details - Admin Dashboard</title>
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
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background-color: var(--success-bg);
            color: var(--success-text);
        }

        .alert-danger {
            background-color: var(--error-bg);
            color: var(--error-text);
        }

        .appointment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .detail-card {
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 1.5rem;
        }

        .detail-card h2 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text-color);
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 0.75rem;
        }

        .detail-row {
            display: flex;
            margin-bottom: 1rem;
        }

        .detail-label {
            font-weight: 500;
            width: 40%;
            color: var(--secondary-color);
        }

        .detail-value {
            width: 60%;
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-pending {
            background-color: #fef3c7;
            color: #d97706;
        }

        .status-confirmed {
            background-color: var(--success-bg);
            color: var(--success-text);
        }

        .status-completed {
            background-color: #e0f2fe;
            color: #0284c7;
        }

        .status-cancelled {
            background-color: var(--error-bg);
            color: var(--error-text);
        }

        .appointment-actions {
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            padding: 1.5rem;
        }

        .appointment-actions h2 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text-color);
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 0.75rem;
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

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-control:focus {
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

        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background-color: #475569;
            transform: translateY(-1px);
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
                align-items: flex-start;
                gap: 1rem;
            }

            .content-header h1 {
                font-size: 1.5rem;
            }

            .appointment-details {
                grid-template-columns: 1fr;
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
                    <h1>Appointment Details</h1>
                    <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-secondary">Back to Appointments</a>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                
                <div class="appointment-details">
                    <div class="detail-card">
                        <h2>Appointment Information</h2>
                        <div class="detail-row">
                            <div class="detail-label">Appointment ID:</div>
                            <div class="detail-value">${appointment.appointmentId}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Date:</div>
                            <div class="detail-value"><fmt:formatDate value="${appointment.appointmentDate}" pattern="MMMM dd, yyyy" /></div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Time Slot:</div>
                            <div class="detail-value">
                                <c:if test="${not empty timeSlot}">
                                    <fmt:formatDate value="${timeSlot.startTime}" pattern="hh:mm a" /> - 
                                    <fmt:formatDate value="${timeSlot.endTime}" pattern="hh:mm a" />
                                </c:if>
                                <c:if test="${empty timeSlot}">
                                    Time Slot ID: ${appointment.timeSlot}
                                </c:if>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Status:</div>
                            <div class="detail-value">
                                <span class="status-badge status-${appointment.status}">
                                    ${appointment.status}
                                </span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Notes:</div>
                            <div class="detail-value">${appointment.note}</div>
                        </div>
                    </div>
                    
                    <div class="detail-card">
                        <h2>Patient Information</h2>
                        <div class="detail-row">
                            <div class="detail-label">Name:</div>
                            <div class="detail-value">${patient.name}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Email:</div>
                            <div class="detail-value">${patient.email}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Phone:</div>
                            <div class="detail-value">${patient.phone}</div>
                        </div>
                    </div>
                    
                    <div class="detail-card">
                        <h2>Doctor Information</h2>
                        <div class="detail-row">
                            <div class="detail-label">Name:</div>
                            <div class="detail-value">${doctor.name}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Specialization:</div>
                            <div class="detail-value">${doctor.specialization}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Email:</div>
                            <div class="detail-value">${doctor.email}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Phone:</div>
                            <div class="detail-value">${doctor.phone}</div>
                        </div>
                    </div>
                </div>
                
                <div class="appointment-actions">
                    <h2>Update Appointment Status</h2>
                    <form action="${pageContext.request.contextPath}/admin/appointments" method="post">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="${appointment.appointmentId}">
                        
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" class="form-control">
                                <option value="pending" ${appointment.status == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="confirmed" ${appointment.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="completed" ${appointment.status == 'completed' ? 'selected' : ''}>Completed</option>
                                <option value="cancelled" ${appointment.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Update Status</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>