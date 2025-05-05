<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile - Hospital Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
      :root {
        --primary-color: #3b82f6;
        --primary-hover: #2563eb;
        --primary-light: #eff6ff;
        --secondary-color: #64748b;
        --background-color: #f1f5f9;
        --text-color: #1e293b;
        --text-light: #64748b;
        --surface-color: #ffffff;
        --error-color: #ef4444;
        --success-color: #22c55e;
        --warning-color: #f59e0b;
        --border-radius: 0.75rem;
        --border-radius-lg: 1rem;
        --border-radius-full: 9999px;
        --card-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        --transition: all 0.3s ease;
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
        width: 95%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 1.5rem 1rem 3rem;
        flex: 1;
      }

      /* Override header container styles to avoid conflicts */
      .header-container {
        width: auto;
        max-width: 1200px;
        padding: 0 20px;
        margin: 0 auto;
      }

      .profile-page-title {
        margin-bottom: 1.5rem;
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--text-color);
      }

      .profile-layout {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 2rem;
      }

      .card {
        background: var(--surface-color);
        border-radius: var(--border-radius-lg);
        box-shadow: var(--card-shadow);
        overflow: hidden;
      }

      .profile-sidebar {
        display: flex;
        flex-direction: column;
        height: fit-content;
      }

      .profile-avatar-section {
        padding: 2rem;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        background: linear-gradient(to bottom, var(--primary-light), var(--surface-color));
      }

      .profile-avatar {
        width: 150px;
        height: 150px;
        border-radius: var(--border-radius-full);
        border: 5px solid var(--surface-color);
        overflow: hidden;
        margin-bottom: 1.5rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        position: relative;
      }

      .profile-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }

      .profile-avatar-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0, 0, 0, 0.6);
        color: #fff;
        text-align: center;
        padding: 0.5rem 0;
        font-size: 0.8rem;
        opacity: 0;
        transition: opacity 0.3s ease;
        cursor: pointer;
      }

      .profile-avatar:hover .profile-avatar-overlay {
        opacity: 1;
      }

      .profile-avatar input[type="file"] {
        display: none;
      }

      .profile-info {
        margin-bottom: 1rem;
      }

      .profile-name {
        font-size: 1.5rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
        color: var(--text-color);
      }

      .profile-email, .profile-phone {
        color: var(--text-light);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        margin-bottom: 0.25rem;
        font-size: 0.9rem;
      }

      .profile-tabs {
        margin-top: 1rem;
        border-top: 1px solid #e5e7eb;
      }

      .profile-tab {
        padding: 1rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        text-decoration: none;
        color: var(--text-color);
        transition: background-color 0.3s ease;
        cursor: pointer;
      }

      .profile-tab:hover {
        background-color: var(--primary-light);
      }

      .profile-tab.active {
        background-color: var(--primary-light);
        border-left: 4px solid var(--primary-color);
      }

      .profile-tab-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 2rem;
        height: 2rem;
        border-radius: var(--border-radius);
        background-color: var(--primary-light);
        color: var(--primary-color);
      }

      .profile-main {
        display: flex;
        flex-direction: column;
        gap: 2rem;
      }

      .profile-section {
        padding: 2rem;
      }

      .section-title {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        color: var(--text-color);
        display: flex;
        align-items: center;
        gap: 0.75rem;
      }

      .section-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 2rem;
        height: 2rem;
        border-radius: var(--border-radius);
        background-color: var(--primary-light);
        color: var(--primary-color);
      }

      .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.5rem;
        margin-bottom: 1.5rem;
      }

      @media (max-width: 768px) {
        .form-row {
          grid-template-columns: 1fr;
        }
      }

      .form-group {
        margin-bottom: 1.5rem;
      }

      .form-group:last-child {
        margin-bottom: 0;
      }

      .form-label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: 500;
        color: var(--text-color);
      }

      .form-control {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 1px solid #e5e7eb;
        border-radius: var(--border-radius);
        font-size: 0.95rem;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
        background-color: var(--surface-color);
      }

      .form-control:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
      }

      .form-error {
        margin-top: 0.5rem;
        color: var(--error-color);
        font-size: 0.875rem;
      }

      .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 0.75rem 1.5rem;
        background-color: var(--primary-color);
        color: white;
        border: none;
        border-radius: var(--border-radius);
        cursor: pointer;
        font-size: 0.95rem;
        font-weight: 500;
        text-decoration: none;
        transition: background-color 0.3s ease, transform 0.3s ease;
      }

      .btn:hover {
        background-color: var(--primary-hover);
        transform: translateY(-1px);
      }

      .btn-secondary {
        background-color: var(--text-light);
      }

      .btn-secondary:hover {
        background-color: var(--text-color);
      }

      .btn-outline {
        background-color: transparent;
        border: 1px solid var(--primary-color);
        color: var(--primary-color);
      }

      .btn-outline:hover {
        background-color: var(--primary-light);
      }

      .btn-icon {
        width: 2.5rem;
        height: 2.5rem;
        padding: 0;
        border-radius: var(--border-radius-full);
      }

      .button-group {
        display: flex;
        gap: 1rem;
        margin-top: 2rem;
      }

      .alert {
        padding: 1rem;
        margin-bottom: 1.5rem;
        border-radius: var(--border-radius);
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 0.75rem;
      }

      .alert-success {
        background-color: rgba(34, 197, 94, 0.1);
        color: var(--success-color);
        border: 1px solid rgba(34, 197, 94, 0.2);
      }

      .alert-danger {
        background-color: rgba(239, 68, 68, 0.1);
        color: var(--error-color);
        border: 1px solid rgba(239, 68, 68, 0.2);
      }

      @media (max-width: 992px) {
        .profile-layout {
          grid-template-columns: 1fr;
        }
      }

      .security-options {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
      }
      
      .security-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        background-color: var(--primary-color, #2563eb);
        color: white;
        border-radius: 8px;
        font-weight: 600;
        padding: 0.75rem 1.5rem;
        transition: all 0.2s ease;
        width: fit-content;
        text-decoration: none;
      }
      
      .security-btn:hover {
        background-color: var(--primary-color-dark, #1d4ed8);
        transform: translateY(-1px);
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
      }
    </style>
  </head>
  <body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
      <h1 class="profile-page-title">My Profile</h1>
      
      <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
          <i class="fas fa-check-circle"></i>
          ${successMessage}
        </div>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle"></i>
          ${errorMessage}
        </div>
      </c:if>

      <div class="profile-layout">
        <!-- Profile Sidebar -->
        <div class="profile-sidebar card">
          <div class="profile-avatar-section">
            <div class="profile-avatar">
              <c:choose>
                <c:when test="${not empty user.imageUrl}">
                  <img src="${pageContext.request.contextPath}/${user.imageUrl}" alt="${user.name}" id="preview-image">
                </c:when>
                <c:otherwise>
                  <img src="${pageContext.request.contextPath}/images/default-user.jpg" alt="Default User" id="preview-image">
                </c:otherwise>
              </c:choose>
              <label class="profile-avatar-overlay" for="profile-image-upload">
                <i class="fas fa-camera"></i> Change Photo
              </label>
            </div>
            <div class="profile-info">
              <h2 class="profile-name">${user.name}</h2>
              <div class="profile-email"><i class="fas fa-envelope"></i> ${user.email}</div>
              <div class="profile-phone"><i class="fas fa-phone"></i> ${user.phone}</div>
            </div>
          </div>
          
          <div class="profile-tabs">
            <div class="profile-tab active">
              <div class="profile-tab-icon">
                <i class="fas fa-user"></i>
              </div>
              <span>Personal Information</span>
            </div>
            <a href="${pageContext.request.contextPath}/profile?action=changePassword" class="profile-tab">
              <div class="profile-tab-icon">
                <i class="fas fa-lock"></i>
              </div>
              <span>Change Password</span>
            </a>
            <a href="${pageContext.request.contextPath}/appointments" class="profile-tab">
              <div class="profile-tab-icon">
                <i class="fas fa-calendar-check"></i>
              </div>
              <span>My Appointments</span>
            </a>
          </div>
        </div>

        <!-- Profile Main Content -->
        <div class="profile-main">
          <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="card profile-section">
            <input type="hidden" name="action" value="update">
            <input type="file" id="profile-image-upload" name="image" accept="image/*" style="display: none" onchange="previewImage(this)">
            
            <h3 class="section-title">
              <div class="section-icon">
                <i class="fas fa-user-edit"></i>
              </div>
              Personal Information
            </h3>
            
            <div class="form-row">
              <div class="form-group">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" id="name" name="name" value="${user.name}" class="form-control" required>
                <c:if test="${not empty nameError}">
                  <div class="form-error">${nameError}</div>
                </c:if>
              </div>
              
              <div class="form-group">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" id="email" name="email" value="${user.email}" class="form-control" required>
                <c:if test="${not empty emailError}">
                  <div class="form-error">${emailError}</div>
                </c:if>
              </div>
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="phone" class="form-label">Phone Number</label>
                <input type="tel" id="phone" name="phone" value="${user.phone}" class="form-control">
                <c:if test="${not empty phoneError}">
                  <div class="form-error">${phoneError}</div>
                </c:if>
              </div>
            </div>
            
            <div class="button-group">
              <button type="submit" class="btn">
                <i class="fas fa-save"></i> Save Changes
              </button>
              <button type="reset" class="btn btn-outline">
                <i class="fas fa-undo"></i> Reset
              </button>
            </div>
          </form>
          
          <div class="card profile-section">
            <h3 class="section-title">
              <div class="section-icon">
                <i class="fas fa-shield-alt"></i>
              </div>
              Account Security
            </h3>
            
            <p style="margin-bottom: 1.5rem; color: var(--text-light);">
              Protect your account by creating a strong password that you don't use on other websites.
            </p>
            
            <div class="security-options">
              <a href="${pageContext.request.contextPath}/profile?action=changePassword" class="btn security-btn">
                <i class="fas fa-lock"></i> Change Password
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      function previewImage(input) {
        if (input.files && input.files[0]) {
          const reader = new FileReader();
          reader.onload = function(e) {
            document.getElementById('preview-image').src = e.target.result;
          };
          reader.readAsDataURL(input.files[0]);
        }
      }
    </script>

    <jsp:include page="includes/footer.jsp" />
  </body>
</html>
