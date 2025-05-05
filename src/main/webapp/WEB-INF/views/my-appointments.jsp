<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Appointments - Hospital Management System</title>
    <style>
      :root {
        --primary-color: #3498db;
        --primary-hover: #2980b9;
        --secondary-color: #64748b;
        --background-color: #f8fafc;
        --text-color: #2c3e50;
        --border-color: #e2e8f0;
        --card-bg: #ffffff;
        --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        --success-bg: #dcfce7;
        --success-text: #16a34a;
        --error-bg: #fee2e2;
        --error-text: #dc2626;
        --warning-bg: #fef3c7;
        --warning-text: #d97706;
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

      .section-title {
        color: var(--text-color);
        font-size: 2.2rem;
        margin-bottom: 2rem;
        font-weight: 600;
        position: relative;
        padding-bottom: 1rem;
        text-align: center;
      }

      .section-title::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 60px;
        height: 3px;
        background: var(--primary-color);
        border-radius: 2px;
      }

      .appointments-table {
        background: var(--card-bg);
        border-radius: 16px;
        box-shadow: var(--card-shadow);
        overflow: hidden;
        margin-bottom: 2rem;
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      th,
      td {
        padding: 1.25rem;
        text-align: left;
        border-bottom: 1px solid var(--border-color);
      }

      th {
        background-color: #f1f5f9;
        font-weight: 600;
        color: var(--secondary-color);
        text-transform: uppercase;
        font-size: 0.875rem;
        letter-spacing: 0.05em;
      }

      tr:hover {
        background-color: #f8fafc;
      }

      .status-badge {
        display: inline-block;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.875rem;
        font-weight: 500;
        text-transform: capitalize;
      }

      .status-pending {
        background-color: var(--warning-bg);
        color: var(--warning-text);
      }

      .status-confirmed {
        background-color: #dbeafe;
        color: var(--primary-color);
      }

      .status-completed {
        background-color: var(--success-bg);
        color: var(--success-text);
      }

      .status-cancelled {
        background-color: var(--error-bg);
        color: var(--error-text);
      }

      .action-buttons {
        display: flex;
        gap: 0.75rem;
      }

      .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.5rem 1rem;
        font-size: 0.875rem;
        font-weight: 500;
        text-decoration: none;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .btn-secondary {
        background-color: var(--secondary-color);
        color: white;
      }

      .btn-secondary:hover {
        background-color: #475569;
        transform: translateY(-1px);
      }

      .btn-danger {
        background-color: #ef4444;
        color: white;
      }

      .btn-danger:hover {
        background-color: #dc2626;
        transform: translateY(-1px);
      }

      .alert {
        padding: 1rem;
        margin-bottom: 1.5rem;
        border-radius: 12px;
        font-weight: 500;
      }

      .alert-success {
        background-color: var(--success-bg);
        color: var(--success-text);
      }

      .alert-danger {
        background-color: var(--error-bg);
        color: var(--error-text);
      }

      .no-results {
        text-align: center;
        padding: 3rem;
        color: var(--secondary-color);
        background: var(--card-bg);
        border-radius: 16px;
        box-shadow: var(--card-shadow);
      }

      @media (max-width: 768px) {
        .container {
          padding: 1rem;
        }

        .section-title {
          font-size: 1.8rem;
        }

        .appointments-table {
          border-radius: 12px;
        }

        table {
          display: block;
          overflow-x: auto;
        }

        th,
        td {
          min-width: 120px;
          padding: 1rem;
        }

        .action-buttons {
          flex-direction: column;
          gap: 0.5rem;
        }
      }
    </style>
  </head>

  <body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
      <h1 class="section-title">My Appointments</h1>

      <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
      </c:if>

      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
      </c:if>

      <div class="appointments-table">
        <table>
          <thead>
            <tr>
              <th>SN</th>
              <th>Doctor</th>
              <th>Date</th>
              <th>Time</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach
              var="appointment"
              items="${appointments}"
              varStatus="loop"
            >
              <tr>
                <td>${loop.index + 1}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty doctorMap[appointment.doctorId]}">
                      ${doctorMap[appointment.doctorId].name}
                    </c:when>
                    <c:otherwise> [Doctor info not available] </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <fmt:formatDate
                    value="${appointment.appointmentDate}"
                    pattern="MMMM dd, yyyy"
                  />
                </td>
                <td>
                  <c:choose>
                    <c:when test="${not empty timeSlots[appointment.timeSlot]}">
                      <fmt:formatDate
                        value="${timeSlots[appointment.timeSlot].startTime}"
                        pattern="hh:mm a"
                      />
                      -
                      <fmt:formatDate
                        value="${timeSlots[appointment.timeSlot].endTime}"
                        pattern="hh:mm a"
                      />
                    </c:when>
                    <c:otherwise>
                      Time Slot #${appointment.timeSlot}
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <span class="status-badge status-${appointment.status}">
                    ${appointment.status}
                  </span>
                </td>
                <td>
                  <div class="action-buttons">
                    <c:if
                      test="${appointment.status != 'cancelled' && appointment.status != 'completed'}"
                    >
                      <a
                        href="${pageContext.request.contextPath}/appointments?action=cancel&id=${appointment.appointmentId}"
                        class="btn btn-danger"
                        onclick="return confirm('Are you sure you want to cancel this appointment?')"
                        >Cancel</a
                      >
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty appointments}">
              <tr>
                <td colspan="6" class="no-results">No appointments found.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
  </body>
</html>
