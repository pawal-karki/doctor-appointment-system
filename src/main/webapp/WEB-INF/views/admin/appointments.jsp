<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Appointments - Admin Dashboard</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
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
        --warning-bg: #fef3c7;
        --warning-text: #d97706;
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
        padding: 2rem;
        margin-left: var(--sidebar-width);
      }

      .content-container {
        max-width: 1200px;
        margin: 0 auto;
      }

      .content-container h1 {
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 2rem;
        color: var(--text-color);
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

      .table-responsive {
        background: var(--card-bg);
        border-radius: var(--border-radius);
        box-shadow: var(--card-shadow);
        padding: 1.5rem;
      }

      .table-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
        gap: 1rem;
      }

      .table-filter {
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .table-filter label {
        font-weight: 500;
        color: var(--secondary-color);
      }

      .table-filter select,
      .table-search input {
        padding: 0.5rem 1rem;
        border: 1px solid #e2e8f0;
        border-radius: var(--border-radius);
        font-size: 0.875rem;
        color: var(--text-color);
        background-color: white;
        transition: var(--transition);
      }

      .table-filter select:focus,
      .table-search input:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
      }

      .table-search {
        flex: 1;
        max-width: 300px;
      }

      .table-search input {
        width: 100%;
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      th,
      td {
        padding: 1rem;
        text-align: left;
        border-bottom: 1px solid #e2e8f0;
      }

      th {
        background-color: #f8fafc;
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
        padding: 0.25rem 0.75rem;
        border-radius: var(--border-radius);
        font-size: 0.875rem;
        font-weight: 500;
        text-transform: capitalize;
      }

      .status-pending {
        background-color: var(--warning-bg);
        color: var(--warning-text);
      }

      .status-confirmed {
        background-color: var(--success-bg);
        color: var(--success-text);
      }

      .status-completed {
        background-color: var(--success-bg);
        color: var(--success-text);
      }

      .status-cancelled {
        background-color: var(--error-bg);
        color: var(--error-text);
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
      }

      .btn-sm {
        padding: 0.375rem 0.75rem;
        font-size: 0.75rem;
      }

      .btn-secondary {
        background-color: var(--secondary-color);
        color: white;
      }

      .btn-secondary:hover {
        background-color: #475569;
        transform: translateY(-1px);
      }

      .no-results {
        text-align: center;
        padding: 2rem;
        color: var(--secondary-color);
      }

      @media (max-width: 768px) {
        .admin-content {
          margin-left: 0;
          padding: 1rem;
        }

        .table-actions {
          flex-direction: column;
          align-items: stretch;
        }

        .table-search {
          max-width: none;
        }

        .content-container h1 {
          font-size: 1.5rem;
        }

        .table-responsive {
          overflow-x: auto;
        }

        table {
          min-width: 800px;
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
          <h1>Appointments</h1>

          <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
          </c:if>

          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
          </c:if>

          <div class="table-responsive">
            <div class="table-actions">
              <div class="table-filter">
                <label for="status-filter">Filter by Status:</label>
                <select id="status-filter">
                  <option value="all">All</option>
                  <option value="pending">Pending</option>
                  <option value="confirmed">Confirmed</option>
                  <option value="completed">Completed</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </div>

              <div class="table-search">
                <input type="text" id="search-input" placeholder="Search..." />
              </div>
            </div>

            <table id="appointments-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Patient Name</th>
                  <th>Email</th>
                  <th>Phone</th>
                  <th>Doctor</th>
                  <th>Date</th>
                  <th>Time</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="appointment" items="${appointments}">
                  <tr data-status="${appointment.status}">
                    <td>${appointment.id}</td>
                    <td>${patientMap[appointment.userId].name}</td>
                    <td>${patientMap[appointment.userId].email}</td>
                    <td>${patientMap[appointment.userId].phone}</td>
                    <td>${doctorMap[appointment.doctorId].name}</td>
                    <td>
                      <fmt:formatDate
                        value="${appointment.appointmentDate}"
                        pattern="MMM dd, yyyy"
                      />
                    </td>
                    <td>
                      <c:choose>
                        <c:when
                          test="${not empty timeSlots[appointment.timeSlot]}"
                        >
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
                      <a
                        href="${pageContext.request.contextPath}/admin/appointments?action=view&id=${appointment.id}"
                        class="btn btn-sm btn-secondary"
                        >View</a
                      >
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty appointments}">
                  <tr>
                    <td colspan="9" class="no-results">
                      No appointments found.
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <script>
      // Filter appointments by status
      document
        .getElementById("status-filter")
        .addEventListener("change", function () {
          const status = this.value;
          const rows = document.querySelectorAll(
            "#appointments-table tbody tr"
          );

          rows.forEach((row) => {
            if (
              status === "all" ||
              row.getAttribute("data-status") === status
            ) {
              row.style.display = "";
            } else {
              row.style.display = "none";
            }
          });
        });

      // Search functionality
      document
        .getElementById("search-input")
        .addEventListener("keyup", function () {
          const searchText = this.value.toLowerCase();
          const rows = document.querySelectorAll(
            "#appointments-table tbody tr"
          );

          rows.forEach((row) => {
            const text = row.textContent.toLowerCase();
            if (text.includes(searchText)) {
              row.style.display = "";
            } else {
              row.style.display = "none";
            }
          });
        });
    </script>
  </body>
</html>
