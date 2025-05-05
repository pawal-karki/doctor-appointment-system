<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Change Password - Hospital Management System</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
    />
    <style>
      :root {
        --primary: #3b82f6;
        --primary-hover: #2563eb;
        --dark: #1e293b;
        --text: #334155;
        --light-text: #64748b;
        --light-bg: #f8fafc;
        --border: #e2e8f0;
        --error: #ef4444;
        --success: #10b981;
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Segoe UI", "Arial", sans-serif;
        line-height: 1.6;
        color: var(--text);
        background-color: var(--light-bg);
      }

      .container {
        width: 90%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px 15px;
      }

      .header-container {
        width: auto;
        max-width: 1200px;
        padding: 0 20px;
        margin: 0 auto;
      }

      .auth-form {
        max-width: 500px;
        margin: 50px auto;
        padding: 40px;
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
      }

      .auth-form h2 {
        text-align: center;
        margin-bottom: 35px;
        color: var(--dark);
        font-weight: 600;
        font-size: 1.75rem;
      }

      .form-group {
        margin-bottom: 28px;
        position: relative;
      }

      .form-group label {
        display: block;
        margin-bottom: 8px;
        color: var(--text);
        font-weight: 500;
        font-size: 0.95rem;
      }

      .form-group .input-wrapper {
        position: relative;
      }

      .form-group input {
        width: 100%;
        padding: 14px 15px;
        border: 1px solid var(--border);
        border-radius: 10px;
        font-size: 16px;
        transition: all 0.2s ease;
        background-color: #fff;
        color: var(--dark);
      }

      .form-group input:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
      }

      .password-toggle {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        color: var(--light-text);
        font-size: 1rem;
        background: none;
        border: none;
        padding: 5px;
        opacity: 0.7;
        transition: opacity 0.2s ease;
      }

      .password-toggle:hover {
        opacity: 1;
      }

      .btn-group {
        display: flex;
        gap: 15px;
        margin-top: 20px;
      }

      .btn {
        display: inline-block;
        padding: 14px 24px;
        background-color: var(--primary);
        color: #fff;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 600;
        flex: 1;
        transition: all 0.3s ease;
        text-align: center;
        text-decoration: none;
      }

      .btn:hover {
        background-color: var(--primary-hover);
        transform: translateY(-2px);
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .btn:active {
        transform: translateY(0);
      }

      .btn-secondary {
        background-color: white;
        border: 1px solid var(--border);
        color: var(--text);
      }

      .btn-secondary:hover {
        background-color: var(--light-bg);
      }

      .alert {
        padding: 16px;
        margin-bottom: 30px;
        border-radius: 10px;
        font-size: 0.95rem;
        display: flex;
        align-items: center;
      }

      .alert i {
        margin-right: 12px;
        font-size: 1.2rem;
      }

      .alert-danger {
        background-color: #fee2e2;
        color: #b91c1c;
        border: 1px solid #fecaca;
      }

      .alert-success {
        background-color: #d1fae5;
        color: #065f46;
        border: 1px solid #a7f3d0;
      }

      .password-strength {
        height: 6px;
        background: #e5e7eb;
        margin-top: 8px;
        border-radius: 3px;
        overflow: hidden;
        transition: all 0.3s ease;
      }

      .password-strength-indicator {
        height: 100%;
        width: 0%;
        transition: width 0.3s ease, background-color 0.3s ease;
        border-radius: 3px;
      }

      .strength-weak {
        background-color: #ef4444;
        width: 33%;
      }

      .strength-medium {
        background-color: #f59e0b;
        width: 66%;
      }

      .strength-strong {
        background-color: #10b981;
        width: 100%;
      }

      .validation-message {
        font-size: 0.85rem;
        margin-top: 8px;
        display: flex;
        align-items: center;
        transition: all 0.3s ease;
      }

      .validation-message i {
        margin-right: 5px;
      }

      .valid-text {
        color: var(--success);
      }

      .invalid-text {
        color: var(--error);
      }

      .password-label {
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .strength-text {
        font-size: 0.8rem;
        font-weight: normal;
      }

      .weak-text {
        color: #ef4444;
      }

      .medium-text {
        color: #f59e0b;
      }

      .strong-text {
        color: #10b981;
      }
    </style>
  </head>
  <body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
      <div class="auth-form">
        <h2>Change Your Password</h2>

        <c:if test="${not empty errorMessage}">
          <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            ${errorMessage}
          </div>
        </c:if>

        <c:if test="${not empty successMessage}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            ${successMessage}
          </div>
        </c:if>

        <form
          action="${pageContext.request.contextPath}/profile"
          method="post"
          id="passwordChangeForm"
        >
          <input type="hidden" name="action" value="changePassword" />

          <div class="form-group">
            <label for="currentPassword">Current Password</label>
            <div class="input-wrapper">
              <input
                type="password"
                id="currentPassword"
                name="currentPassword"
                required
              />
              <button
                type="button"
                class="password-toggle"
                onclick="togglePasswordVisibility('currentPassword')"
                aria-label="Toggle password visibility"
              >
                <i class="fas fa-eye"></i>
              </button>
            </div>
          </div>

          <div class="form-group">
            <div class="password-label">
              <label for="newPassword">New Password</label>
              <span id="strengthText" class="strength-text"></span>
            </div>
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
                aria-label="Toggle password visibility"
              >
                <i class="fas fa-eye"></i>
              </button>
            </div>
            <div class="password-strength">
              <div
                id="strengthIndicator"
                class="password-strength-indicator"
              ></div>
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
                aria-label="Toggle password visibility"
              >
                <i class="fas fa-eye"></i>
              </button>
            </div>
            <div id="passwordMatch" class="validation-message"></div>
          </div>

          <div class="btn-group">
            <button type="submit" class="btn" id="submitBtn">
              <i class="fas fa-check"></i> Update Password
            </button>
            <a
              href="${pageContext.request.contextPath}/profile"
              class="btn btn-secondary"
            >
              <i class="fas fa-times"></i> Cancel
            </a>
          </div>
        </form>
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
        const password = document.getElementById("newPassword").value;
        const indicator = document.getElementById("strengthIndicator");
        const strengthText = document.getElementById("strengthText");

        // Remove all classes
        indicator.classList.remove(
          "strength-weak",
          "strength-medium",
          "strength-strong"
        );
        strengthText.classList.remove(
          "weak-text",
          "medium-text",
          "strong-text"
        );

        if (password.length === 0) {
          indicator.style.width = "0%";
          strengthText.textContent = "";
          return;
        }

        // Enhanced strength calculation
        let strength = 0;

        // Length check
        if (password.length >= 8) strength += 1;
        if (password.length >= 12) strength += 1;

        // Character variety checks
        if (/[A-Z]/.test(password)) strength += 1;
        if (/[0-9]/.test(password)) strength += 1;
        if (/[^A-Za-z0-9]/.test(password)) strength += 1;

        // Set the appropriate class and text
        if (strength <= 2) {
          indicator.classList.add("strength-weak");
          strengthText.textContent = "Weak";
          strengthText.classList.add("weak-text");
        } else if (strength <= 4) {
          indicator.classList.add("strength-medium");
          strengthText.textContent = "Medium";
          strengthText.classList.add("medium-text");
        } else {
          indicator.classList.add("strength-strong");
          strengthText.textContent = "Strong";
          strengthText.classList.add("strong-text");
        }

        // Trigger match check in case both fields are filled
        if (document.getElementById("confirmPassword").value) {
          checkPasswordsMatch();
        }
      }

      function checkPasswordsMatch() {
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword =
          document.getElementById("confirmPassword").value;
        const matchDisplay = document.getElementById("passwordMatch");

        matchDisplay.innerHTML = "";

        if (confirmPassword.length === 0) {
          return;
        }

        if (newPassword === confirmPassword) {
          matchDisplay.classList.add("valid-text");
          matchDisplay.classList.remove("invalid-text");
          matchDisplay.innerHTML =
            '<i class="fas fa-check-circle"></i> Passwords match';
        } else {
          matchDisplay.classList.add("invalid-text");
          matchDisplay.classList.remove("valid-text");
          matchDisplay.innerHTML =
            '<i class="fas fa-times-circle"></i> Passwords do not match';
        }
      }

      // Form validation before submission
      document
        .getElementById("passwordChangeForm")
        .addEventListener("submit", function (event) {
          const newPassword = document.getElementById("newPassword").value;
          const confirmPassword =
            document.getElementById("confirmPassword").value;

          if (newPassword !== confirmPassword) {
            event.preventDefault();
            const matchDisplay = document.getElementById("passwordMatch");
            matchDisplay.classList.add("invalid-text");
            matchDisplay.innerHTML =
              '<i class="fas fa-exclamation-circle"></i> Passwords must match to proceed';
            document.getElementById("confirmPassword").focus();
          }
        });
    </script>

    <jsp:include page="includes/footer.jsp" />
  </body>
</html>
