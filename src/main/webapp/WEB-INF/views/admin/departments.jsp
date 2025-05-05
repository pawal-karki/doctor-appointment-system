<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Departments - Admin Dashboard</title>
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
        overflow-x: auto;
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

      .department-img-small {
        width: 50px;
        height: 50px;
        border-radius: var(--border-radius);
        overflow: hidden;
      }

      .department-img-small img {
        width: 100%;
        height: 100%;
        object-fit: cover;
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

      .btn-danger {
        background-color: var(--error-text);
        color: white;
      }

      .btn-danger:hover {
        background-color: #b91c1c;
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
        }

        .content-container {
          padding: 0 1rem 1rem;
        }

        .content-header {
          flex-direction: column;
          gap: 1rem;
          align-items: flex-start;
        }

        .content-header h1 {
          font-size: 1.5rem;
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
          <div class="content-header">
            <h1>Departments</h1>
            <a
              href="${pageContext.request.contextPath}/admin/departments?action=add"
              class="btn btn-primary"
              >Add Department</a
            >
          </div>

          <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
          </c:if>

          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
          </c:if>

          <div class="table-responsive">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Image</th>
                  <th>Name</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="department" items="${departments}">
                  <tr>
                    <td>${department.id}</td>
                    <td>
                      <div class="department-img-small">
                        <c:choose>
                          <c:when test="${not empty department.imageUrl}">
                            <img src="${pageContext.request.contextPath}/${department.imageUrl}" alt="${department.name}">
                          </c:when>
                          <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default-department.jpg" alt="${department.name}">
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </td>
                    <td>${department.name}</td>
                    <td>${department.description}</td>
                    <td>
                      <a
                        href="${pageContext.request.contextPath}/admin/departments?action=edit&id=${department.id}"
                        class="btn btn-sm btn-secondary"
                        >Edit</a
                      >
                      <a
                        href="${pageContext.request.contextPath}/admin/departments?action=delete&id=${department.id}"
                        class="btn btn-sm btn-danger"
                        onclick="return confirm('Are you sure you want to delete this department?')"
                        >Delete</a
                      >
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty departments}">
                  <tr>
                    <td colspan="5" class="no-results">
                      No departments found.
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>