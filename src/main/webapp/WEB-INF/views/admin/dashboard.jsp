<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - Hospital Management System</title>
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
        margin-left: var(--sidebar-width);
      }

      .dashboard-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 2rem 2rem;
      }

      .dashboard-container h1 {
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 2rem;
        color: var(--text-color);
      }

      .dashboard-stats {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
      }

      .stat-card {
        background: var(--card-bg);
        padding: 1.5rem;
        border-radius: var(--border-radius);
        box-shadow: var(--card-shadow);
        transition: var(--transition);
      }

      .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1),
          0 4px 6px -4px rgb(0 0 0 / 0.1);
      }

      .stat-card h3 {
        color: var(--secondary-color);
        font-size: 1rem;
        font-weight: 500;
        margin-bottom: 0.5rem;
      }

      .stat-number {
        font-size: 2rem;
        font-weight: 600;
        color: var(--primary-color);
      }

      .dashboard-tables {
        background: var(--card-bg);
        border-radius: var(--border-radius);
        box-shadow: var(--card-shadow);
        padding: 1.5rem;
      }

      .dashboard-table h2 {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        color: var(--text-color);
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

      .table-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
      }

      .table-header h2 {
        margin-bottom: 0;
      }

      .table-actions {
        display: flex;
        align-items: center;
        gap: 1rem;
      }

      .table-filter {
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .table-filter label {
        margin-bottom: 0;
        font-weight: 500;
      }

      .table-filter select {
        padding: 0.375rem 0.75rem;
        border: 1px solid #e2e8f0;
        border-radius: var(--border-radius);
        max-width: 200px;
      }

      .btn-primary {
        background-color: var(--primary-color);
        color: white;
      }

      .btn-primary:hover {
        background-color: var(--primary-hover);
        transform: translateY(-1px);
      }

      @media (max-width: 768px) {
        .admin-content {
          margin-left: 0;
        }

        .dashboard-container {
          padding: 0 1rem 1rem;
        }

        .dashboard-stats {
          grid-template-columns: 1fr;
        }

        .dashboard-container h1 {
          font-size: 1.5rem;
        }

        .stat-number {
          font-size: 1.5rem;
        }

        .dashboard-tables {
          overflow-x: auto;
        }

        table {
          min-width: 600px;
        }
      }
    </style>
  </head>
  <body>
    <div class="admin-layout">
      <jsp:include page="includes/sidebar.jsp" />

      <div class="admin-content">
        <jsp:include page="includes/header.jsp" />

        <div class="dashboard-container">
          <h1>Dashboard</h1>

          <div class="dashboard-stats">
            <div class="stat-card" id="today-stat">
              <h3>Today's Appointments</h3>
              <p class="stat-number">${todayAppointments.size()}</p>
            </div>

            <div class="stat-card" id="future-stat">
              <h3>Future Appointments</h3>
              <p class="stat-number">${futureAppointments.size()}</p>
            </div>

            <div class="stat-card">
              <h3>Total Departments</h3>
              <p class="stat-number">${departmentCount}</p>
            </div>

            <div class="stat-card">
              <h3>Total Doctors</h3>
              <p class="stat-number">${doctorCount}</p>
            </div>

            <div class="stat-card">
              <h3>Total Patients</h3>
              <p class="stat-number">${patientCount}</p>
            </div>
          </div>

          <div class="dashboard-tables">
            <div class="dashboard-table" id="today-appointments">
              <div class="table-header">
                <h2>Today's Appointments</h2>
                <div class="table-actions">
                  <div class="table-filter">
                    <label for="doctor-filter">Filter by Doctor:</label>
                    <select id="doctor-filter" class="form-control">
                      <option value="all">All Doctors</option>
                      <c:forEach var="doctor" items="${doctorMap}">
                        <option value="${doctor.key}">
                          ${doctor.value.name}
                        </option>
                      </c:forEach>
                    </select>
                  </div>
                  <button id="print-today-appointments" class="btn btn-primary">
                    <i class="fas fa-print"></i> Print
                  </button>
                </div>
              </div>
              <table>
                <thead>
                  <tr>
                    <th>SN</th>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach
                    var="appointment"
                    items="${todayAppointments}"
                    varStatus="status"
                  >
                    <tr data-doctor-id="${appointment.doctorId}">
                      <td>${status.index + 1}</td>
                      <td>
                        <c:choose>
                          <c:when
                            test="${not empty patientMap[appointment.userId]}"
                          >
                            ${patientMap[appointment.userId].name}
                          </c:when>
                          <c:otherwise>
                            <span style="color: var(--error-text)"
                              >Patient Not Found</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when
                            test="${not empty doctorMap[appointment.doctorId]}"
                          >
                            ${doctorMap[appointment.doctorId].name}
                          </c:when>
                          <c:otherwise>
                            <span style="color: var(--error-text)"
                              >Doctor Not Found</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when
                            test="${not empty timeSlotsMap[appointment.timeSlot]}"
                          >
                            <fmt:formatDate
                              value="${timeSlotsMap[appointment.timeSlot].startTime}"
                              pattern="hh:mm a"
                            />
                            -
                            <fmt:formatDate
                              value="${timeSlotsMap[appointment.timeSlot].endTime}"
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

                  <c:if test="${empty todayAppointments}">
                    <tr>
                      <td colspan="6" class="no-results">
                        No appointments for today.
                      </td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </div>

            <div
              class="dashboard-table"
              id="future-appointments"
              style="display: none"
            >
              <h2>Future Appointments</h2>
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Patient</th>
                    <th>Doctor</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="appointment" items="${futureAppointments}">
                    <tr data-doctor-id="${appointment.doctorId}">
                      <td>${appointment.id}</td>
                      <td>
                        <c:choose>
                          <c:when
                            test="${not empty patientMap[appointment.userId]}"
                          >
                            ${patientMap[appointment.userId].name}
                          </c:when>
                          <c:otherwise>
                            <span style="color: var(--error-text)"
                              >Patient Not Found</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when
                            test="${not empty doctorMap[appointment.doctorId]}"
                          >
                            Dr. ${doctorMap[appointment.doctorId].name}
                          </c:when>
                          <c:otherwise>
                            <span style="color: var(--error-text)"
                              >Doctor Not Found</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <fmt:formatDate
                          value="${appointment.appointmentDate}"
                          pattern="MMM dd, yyyy"
                        />
                      </td>
                      <td>
                        <c:choose>
                          <c:when
                            test="${not empty timeSlotsMap[appointment.timeSlot]}"
                          >
                            <fmt:formatDate
                              value="${timeSlotsMap[appointment.timeSlot].startTime}"
                              pattern="hh:mm a"
                            />
                            -
                            <fmt:formatDate
                              value="${timeSlotsMap[appointment.timeSlot].endTime}"
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

                  <c:if test="${empty futureAppointments}">
                    <tr>
                      <td colspan="7" class="no-results">
                        No future appointments scheduled.
                      </td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Print-specific styles -->
        <style type="text/css" media="print">
          @page {
            size: portrait;
            margin: 0.5cm;
          }

          body * {
            visibility: hidden;
          }

          #print-container,
          #print-container * {
            visibility: visible;
          }

          #print-container {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
          }

          .no-print {
            display: none !important;
          }

          .print-header {
            text-align: center;
            margin-bottom: 20px;
          }

          .print-header h1 {
            font-size: 24px;
            margin-bottom: 5px;
          }

          .print-header p {
            font-size: 14px;
            color: #555;
          }
        </style>

        <script>
          document.addEventListener("DOMContentLoaded", function () {
            // Function to format current date
            function formatDate(date) {
              const options = {
                weekday: "long",
                year: "numeric",
                month: "long",
                day: "numeric",
              };
              return date.toLocaleDateString(undefined, options);
            }

            // Print functionality for today's appointments
            document
              .getElementById("print-today-appointments")
              .addEventListener("click", function () {
                // Create a container for print content
                const printContainer = document.createElement("div");
                printContainer.id = "print-container";

                // Add header with hospital name and date
                const header = document.createElement("div");
                header.className = "print-header";
                header.innerHTML = `
                <h1>Hospital Management System</h1>
                <p>Today's Appointments - \${formatDate(new Date())}</p>
              `;
                printContainer.appendChild(header);

                // Clone the table and clean it up for printing
                const table = document
                  .querySelector("#today-appointments table")
                  .cloneNode(true);

                // Remove the Actions column and column header
                const headerRow = table.querySelector("thead tr");
                headerRow.removeChild(headerRow.lastElementChild);

                // Get the selected doctor filter
                const selectedDoctorId =
                  document.getElementById("doctor-filter").value;

                // Remove rows that don't match the filter and all action cells
                const rows = table.querySelectorAll("tbody tr");
                rows.forEach((row) => {
                  // Remove action column
                  row.removeChild(row.lastElementChild);

                  // Apply doctor filter if not "all"
                  if (selectedDoctorId !== "all") {
                    const doctorId = row.getAttribute("data-doctor-id");
                    if (doctorId !== selectedDoctorId) {
                      row.style.display = "none"; // Hide non-matching rows
                    }
                  }
                });

                printContainer.appendChild(table);

                // Add to body temporarily
                document.body.appendChild(printContainer);

                // Print and clean up
                window.print();
                document.body.removeChild(printContainer);
              });

            // Filter functionality for today's appointments
            document
              .getElementById("doctor-filter")
              .addEventListener("change", function () {
                const selectedDoctorId = this.value;
                const rows = document.querySelectorAll(
                  "#today-appointments tbody tr"
                );

                rows.forEach((row) => {
                  if (selectedDoctorId === "all") {
                    row.style.display = ""; // Show all rows
                  } else {
                    const doctorId = row.getAttribute("data-doctor-id");
                    row.style.display =
                      doctorId === selectedDoctorId ? "" : "none";
                  }
                });
              });

            // Original table toggle functionality
            const todayStat = document.getElementById("today-stat");
            const futureStat = document.getElementById("future-stat");
            const todayAppointments =
              document.getElementById("today-appointments");
            const futureAppointments = document.getElementById(
              "future-appointments"
            );

            // Make stats appear clickable
            todayStat.style.cursor = "pointer";
            futureStat.style.cursor = "pointer";

            todayStat.addEventListener("click", function () {
              todayAppointments.style.display = "block";
              futureAppointments.style.display = "none";

              // Highlight the selected stat
              todayStat.style.borderLeft = "4px solid var(--primary-color)";
              futureStat.style.borderLeft = "none";
            });

            futureStat.addEventListener("click", function () {
              todayAppointments.style.display = "none";
              futureAppointments.style.display = "block";

              // Highlight the selected stat
              futureStat.style.borderLeft = "4px solid var(--primary-color)";
              todayStat.style.borderLeft = "none";
            });
          });
        </script>
      </div>
    </div>
  </body>
</html>
