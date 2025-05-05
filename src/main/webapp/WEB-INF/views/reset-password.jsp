<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reset Password - Hospital Management System</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
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
        --border-radius: 0.75rem;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        --card-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1),
          0 8px 10px -6px rgb(0 0 0 / 0.1);
        --header-height: 70px;
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
        padding-top: var(--header-height);
      }

      .container {
        max-width: 1200px;
        width: 90%;
        margin: 0 auto;
        padding: 2rem 1rem;
        flex: 1;
      }

      /* Override header container styles */
      .header-container {
        width: auto;
        max-width: 1200px;
        padding: 0 20px;
        margin: 0 auto;
      }

      .auth-form {
        max-width: 480px;
        margin: 2rem auto;
        padding: 2.5rem;
        background: #fff;
        border-radius: var(--border-radius);
        box-shadow: var(--card-shadow);
      }

      .auth-form h2 {
        text-align: center;
        margin-bottom: 1.5rem;
        color: var(--text-color);
        font-size: 1.75rem;
        font-weight: 700;
      }

      .auth-form p {
        margin-bottom: 1.5rem;
        color: var(--secondary-color);
        text-align: center;
      }

      .form-group {
        margin-bottom: 1.5rem;
      }

      .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        color: var(--secondary-color);
        font-weight: 500;
        font-size: 0.875rem;
      }

      .form-group input {
        width: 100%;
        padding: 0.875rem 1rem;
        border: 2px solid #e2e8f0;
        border-radius: var(--border-radius);
        font-size: 1rem;
        transition: var(--transition);
        background-color: #f8fafc;
      }

      .form-group input:focus {
        outline: none;
        border-color: var(--primary-color);
        background-color: white;
        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
      }

      .input-wrapper {
        position: relative;
      }

      .password-toggle {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        color: var(--secondary-color);
        background: none;
        border: none;
      }

      .otp-input {
        font-size: 1.25rem;
        text-align: center;
        letter-spacing: 4px;
      }

      .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.875rem 1.5rem;
        background-color: var(--primary-color);
        color: white;
        border: none;
        border-radius: var(--border-radius);
        cursor: pointer;
        font-size: 1rem;
        font-weight: 600;
        width: 100%;
        transition: var(--transition);
        text-decoration: none;
      }

      .btn:hover {
        background-color: var(--primary-hover);
        transform: translateY(-1px);
      }

      .btn i {
        margin-right: 0.5rem;
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
      }

      .alert-success {
        background-color: var(--success-bg);
        color: var(--success-text);
      }

      .auth-footer {
        text-align: center;
        margin-top: 1.5rem;
      }

      .auth-footer a {
        color: var(--primary-color);
        text-decoration: none;
        font-weight: 500;
        transition: var(--transition);
      }

      .auth-footer a:hover {
        text-decoration: underline;
      }

      .password-requirements {
        margin-top: 1.5rem;
        padding: 1rem;
        background-color: #f8fafc;
        border-radius: var(--border-radius);
        border: 1px solid #e2e8f0;
      }

      .password-requirements h4 {
        color: var(--text-color);
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
        font-weight: 600;
      }

      .password-requirements ul {
        list-style: none;
        padding-left: 0;
      }

      .password-requirements li {
        color: var(--secondary-color);
        margin-bottom: 0.25rem;
        font-size: 0.8rem;
        display: flex;
        align-items: center;
      }

      .password-requirements li i {
        margin-right: 0.5rem;
        font-size: 0.8rem;
        color: var(--primary-color);
      }

      .form-section {
        margin-bottom: 2rem;
        padding-bottom: 1.5rem;
        border-bottom: 1px solid #e2e8f0;
      }

      .section-title {
        font-size: 1rem;
        color: var(--text-color);
        margin-bottom: 1rem;
        font-weight: 600;
      }
    </style>
  </head>
  <body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
      <div class="auth-form">
        <h2>Reset Your Password</h2>
        <p>
          Enter the one-time password (OTP) sent to your email and create a new
          password.
        </p>

        <c:if test="${not empty errorMessage}">
          <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <c:if test="${not empty successMessage}">
          <div class="alert alert-success">${successMessage}</div>
        </c:if>

        <form
          action="${pageContext.request.contextPath}/reset-password"
          method="post"
        >
          <div class="form-section">
            <div class="section-title">
              <i class="fas fa-key"></i> Verification
            </div>
            <div class="form-group">
              <label for="otp">One-Time Password (OTP)</label>
              <input
                type="text"
                id="otp"
                name="otp"
                class="otp-input"
                maxlength="6"
                placeholder="Enter 6-digit OTP"
                required
              />
            </div>
          </div>

          <div class="section-title">
            <i class="fas fa-lock"></i> New Password
          </div>
          <div class="form-group">
            <label for="newPassword">New Password</label>
            <div class="input-wrapper">
              <input
                type="password"
                id="newPassword"
                name="newPassword"
                required
                oninput="checkPasswordStrength()"
              />
              <button
                type="button"
                class="password-toggle"
                onclick="togglePasswordVisibility('newPassword')"
              >
                <i class="fas fa-eye"></i>
              </button>
            </div>
          </div>

          <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <div class="input-wrapper">
              <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                required
                oninput="checkPasswordsMatch()"
              />
              <button
                type="button"
                class="password-toggle"
                onclick="togglePasswordVisibility('confirmPassword')"
              >
                <i class="fas fa-eye"></i>
              </button>
            </div>
            <div
              id="passwordMatch"
              style="font-size: 0.8rem; margin-top: 0.5rem"
            ></div>
          </div>

          <div class="password-requirements">
            <h4>Password Requirements</h4>
            <ul>
              <li>
                <i class="fas fa-check-circle"></i> At least 8 characters long
              </li>
              <li>
                <i class="fas fa-check-circle"></i> Include at least one
                uppercase letter
              </li>
              <li>
                <i class="fas fa-check-circle"></i> Include at least one number
              </li>
              <li>
                <i class="fas fa-check-circle"></i> Include at least one special
                character
              </li>
            </ul>
          </div>

          <button type="submit" class="btn">
            <i class="fas fa-save"></i> Reset Password
          </button>
        </form>

        <div class="auth-footer">
          <p>
            <a href="${pageContext.request.contextPath}/login">
              <i class="fas fa-arrow-left"></i> Back to Login
            </a>
          </p>
        </div>
      </div>
    </div>

    <script>
      function togglePasswordVisibility(inputId) {
        const input = document.getElementById(inputId);
        const icon = input.nextElementSibling.querySelector("i");

        if (input.type === "password") {
          input.type = "text";
          icon.classList.remove("fa-eye");
          icon.classList.add("fa-eye-slash");
        } else {
          input.type = "password";
          icon.classList.remove("fa-eye-slash");
          icon.classList.add("fa-eye");
        }
      }

      function checkPasswordStrength() {
        // This could be expanded with a visual strength indicator
      }

      function checkPasswordsMatch() {
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword =
          document.getElementById("confirmPassword").value;
        const matchDisplay = document.getElementById("passwordMatch");

        if (confirmPassword.length === 0) {
          matchDisplay.textContent = "";
          matchDisplay.style.color = "";
          return;
        }

        if (newPassword === confirmPassword) {
          matchDisplay.textContent = "Passwords match";
          matchDisplay.style.color = "#16a34a";
        } else {
          matchDisplay.textContent = "Passwords do not match";
          matchDisplay.style.color = "#dc2626";
        }
      }
    </script>

    <jsp:include page="includes/footer.jsp" />
  </body>
</html>
