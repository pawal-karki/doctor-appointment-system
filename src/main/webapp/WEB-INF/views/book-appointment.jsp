<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib prefix="c"
                                           uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
                                                                                                 uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Book Appointment - Hospital Management System</title>
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
            display: flex;
            flex-direction: column;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
            flex: 1;
        }

        .booking-form {
            max-width: 600px;
            margin: 2rem auto;
            padding: 2rem;
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: var(--transition);
        }

        .booking-form:hover {
            box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1),
            0 4px 6px -4px rgb(0 0 0 / 0.1);
        }

        .booking-form h1 {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--text-color);
            font-size: 2rem;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--secondary-color);
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
            background-color: #f8fafc;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: var(--primary-color);
            color: #fff;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            width: 100%;
            transition: var(--transition);
            text-align: center;
            text-decoration: none;
        }

        .btn:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            margin-top: 1rem;
        }

        .btn-secondary:hover {
            background-color: #475569;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 500;
        }

        .alert-danger {
            background-color: var(--error-bg);
            color: var(--error-text);
            border: 1px solid var(--error-text);
        }

        .doctor-info,
        .appointment-info {
            background-color: #f8fafc;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
        }

        .doctor-info h3,
        .appointment-info h3 {
            color: var(--text-color);
            margin-bottom: 1rem;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .doctor-info p,
        .appointment-info p {
            margin-bottom: 0.5rem;
            color: var(--secondary-color);
        }

        .doctor-info strong,
        .appointment-info strong {
            color: var(--text-color);
            font-weight: 500;
        }

        .form-actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .time-passed-alert {
            background-color: var(--error-bg);
            color: var(--error-text);
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            border: 1px solid var(--error-text);
        }

        .disabled-btn {
            background-color: #94a3b8;
            cursor: not-allowed;
        }

        .disabled-btn:hover {
            background-color: #94a3b8;
            transform: none;
        }

        @media (max-width: 640px) {
            .booking-form {
                padding: 1.5rem;
            }

            .booking-form h1 {
                font-size: 1.75rem;
            }

            .doctor-info,
            .appointment-info {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="includes/header.jsp" />

<div class="container">
    <div class="booking-form">
        <h1>Book Appointment</h1>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <div class="booking-details">
            <div class="doctor-info">
                <h3>Doctor Details</h3>
                <p><strong>Name:</strong>${doctor.name}</p>
                <p><strong>Specialization:</strong> ${doctor.specialization}</p>
            </div>

            <div class="appointment-info">
                <h3>Appointment Details</h3>
                <p>
                    <strong>Date:</strong>
                    <fmt:parseDate
                            value="${date}"
                            pattern="yyyy-MM-dd"
                            var="parsedDate"
                    /><fmt:formatDate value="${parsedDate}" pattern="MMMM dd, yyyy" />
                </p>
                <p>
                    <strong>Time:</strong>
                    <fmt:formatDate value="${timeSlot.startTime}" pattern="hh:mm a" />
                    -
                    <fmt:formatDate value="${timeSlot.endTime}" pattern="hh:mm a" />
                </p>
            </div>
        </div>

        <%-- Get current date and time --%>
        <jsp:useBean id="now" class="java.util.Date" />

        <%-- Check if appointment date is today and time slot has passed --%>
        <c:set var="today">
            <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" />
        </c:set>

        <c:set var="appointmentPassed" value="false" />
        <c:if test="${date eq today}">
            <fmt:formatDate value="${now}" pattern="HH:mm:ss" var="currentTime" />
            <fmt:formatDate
                    value="${timeSlot.startTime}"
                    pattern="HH:mm:ss"
                    var="slotTime"
            />
            <c:if test="${currentTime gt slotTime}">
                <c:set var="appointmentPassed" value="true" />
            </c:if>
        </c:if>

        <c:if test="${appointmentPassed eq 'true'}">
            <div class="time-passed-alert">
                <strong
                >This time slot has already passed and is no longer available for
                    booking.</strong
                >
                <p>Please select a different time slot for your appointment.</p>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${appointmentPassed eq 'false'}">
                <form
                        action="${pageContext.request.contextPath}/appointments"
                        method="post"
                >
                    <input type="hidden" name="action" value="book" />
                    <input type="hidden" name="doctorId" value="${doctor.doctorId}" />
                    <input
                            type="hidden"
                            name="timeSlotId"
                            value="${timeSlot.timeslotId}"
                    />
                    <input type="hidden" name="date" value="${date}" />

                    <div class="form-group">
                        <label for="notes">Notes (Optional)</label>
                        <textarea id="notes" name="notes" rows="4"></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            Confirm Booking
                        </button>
                        <a
                                href="${pageContext.request.contextPath}/doctors?action=view&id=${doctor.id}"
                                class="btn btn-secondary"
                        >Cancel</a
                        >
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="form-actions">
                    <button class="btn disabled-btn" disabled>
                        Time Slot Unavailable
                    </button>
                    <a
                            href="${pageContext.request.contextPath}/doctors?action=view&id=${doctor.doctorId}"
                            class="btn btn-secondary"
                    >Select Different Time</a
                    >
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
</body>
</html>