<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - BokGarauSallah</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <style>
      :root {
        --primary: #3498db;
        --primary-dark: #2980b9;
        --primary-light: #eaf2f8;
        --dark: #1e293b;
        --text: #334155;
        --gray: #64748b;
        --light-gray: #f8fafc;
        --border: #e2e8f0;
        --white: #ffffff;
        --error: #ef4444;
        --success: #10b981;
        --shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        --shadow-hover: 0 8px 15px rgba(0, 0, 0, 0.1);
        --font-sans: "Inter", system-ui, -apple-system, "Segoe UI", Roboto,
          sans-serif;
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: var(--font-sans);
        background-color: var(--light-gray);
        color: var(--text);
        line-height: 1.5;
      }

      .register-container {
        display: flex;
        min-height: 100vh;
      }

      .register-image {
        flex: 1;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 2rem;
        background-color: var(--primary);
        color: white;
        overflow: hidden;
      }

      .register-image::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-image: url("${pageContext.request.contextPath}/resources/images/register.avif");
        background-size: cover;
        background-position: center;
        opacity: 0.75;
        z-index: 0;
      }

      .register-image::after {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.4);
        z-index: 0;
      }

      .register-image-content {
        max-width: 480px;
        position: relative;
        z-index: 1;
        text-align: center;
        padding: 2rem;
      }

      .register-image-content h1 {
        font-size: 2.25rem;
        font-weight: 700;
        color: white;
        margin-bottom: 1rem;
        line-height: 1.2;
        text-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
      }

      .register-image-content p {
        font-size: 1.1rem;
        line-height: 1.6;
        color: white;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
      }

      .register-illustration {
        display: none;
      }

      .register-form-container {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 2rem;
        background: var(--white);
        overflow-y: auto;
      }

      .auth-form {
        width: 100%;
        max-width: 440px;
      }

      .logo {
        margin-bottom: 1.5rem;
        display: block;
        text-align: left;
      }

      .logo a {
        color: var(--dark);
        font-size: 1.75rem;
        font-weight: 700;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }

      .logo .nepali-text {
        font-size: 1.5rem;
        color: var(--primary);
        font-weight: 500;
      }

      .auth-form h2 {
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--dark);
        margin-bottom: 0.5rem;
      }

      .auth-form p.subtitle {
        color: var(--gray);
        margin-bottom: 1.5rem;
      }

      .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
      }

      .form-grid .full-width {
        grid-column: span 2;
      }

      .form-group {
        margin-bottom: 1.25rem;
      }

      .form-group label {
        display: block;
        margin-bottom: 0.375rem;
        font-weight: 500;
        color: var(--dark);
        font-size: 0.9rem;
      }

      .form-input {
        position: relative;
      }

      .form-input i {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--gray);
      }

      .form-group input {
        width: 100%;
        padding: 0.75rem 1rem 0.75rem 2.5rem;
        border: 1px solid var(--border);
        border-radius: 6px;
        font-size: 0.95rem;
        color: var(--dark);
        transition: all 0.25s ease;
        background-color: var(--white);
      }

      .form-group input:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
      }

      .password-toggle {
        position: absolute;
        right: 1rem;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: var(--gray);
        cursor: pointer;
        font-size: 0.95rem;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 24px;
        height: 24px;
      }

      .password-toggle:hover {
        color: var(--primary);
      }

      .password-strength {
        margin-top: 0.5rem;
      }

      .password-strength-indicator {
        height: 3px;
        background: var(--border);
        border-radius: 2px;
        overflow: hidden;
        margin-bottom: 0.25rem;
      }

      .strength-text {
        font-size: 0.8rem;
        font-weight: 500;
        float: right;
        margin-top: 0.25rem;
      }

      .weak-text {
        color: var(--error);
      }
      .medium-text {
        color: #f59e0b;
      }
      .strong-text {
        color: var(--success);
      }

      .strength-weak {
        background: var(--error);
        width: 33.33%;
      }
      .strength-medium {
        background: #f59e0b;
        width: 66.66%;
      }
      .strength-strong {
        background: var(--success);
        width: 100%;
      }

      .btn {
        width: 100%;
        padding: 0.75rem;
        background: var(--primary);
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 0.95rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.25s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        box-shadow: var(--shadow);
      }

      .btn:hover {
        background-color: var(--primary-dark);
        transform: translateY(-2px);
        box-shadow: var(--shadow-hover);
      }

      .btn:active {
        transform: translateY(0);
      }

      .auth-link {
        text-align: center;
        margin-top: 1.5rem;
        color: var(--gray);
        font-size: 0.9rem;
      }

      .auth-link a {
        color: var(--primary);
        text-decoration: none;
        font-weight: 600;
      }

      .auth-link a:hover {
        text-decoration: underline;
      }

      .alert {
        padding: 0.75rem 1rem;
        margin-bottom: 1.25rem;
        border-radius: 6px;
        font-weight: 500;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
      }

      .alert-danger {
        background-color: #fef2f2;
        color: var(--error);
        border: 1px solid #fee2e2;
      }

      .alert-success {
        background-color: #f0fdf4;
        color: var(--success);
        border: 1px solid #d1fae5;
      }

      .validation-message {
        color: var(--error);
        font-size: 0.8rem;
        margin-top: 0.375rem;
        display: none;
        padding-left: 0.25rem;
      }

      @media (max-width: 768px) {
        .register-container {
          flex-direction: column;
          height: auto;
          min-height: 100vh;
        }

        .register-image {
          display: none;
        }

        .register-form-container {
          padding: 1.5rem;
        }

        .logo {
          text-align: center;
        }

        .auth-form {
          max-width: 100%;
        }

        .form-grid {
          grid-template-columns: 1fr;
        }

        .form-grid .form-group:nth-child(odd):last-child {
          grid-column: span 1;
        }
      }

      /* Validation styles */
      .input-error {
        border-color: var(--error) !important;
      }

      .input-error:focus {
        box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
      }
    </style>
  </head>
  <body>
    <div class="register-container">
      <div class="register-image">
        <div class="register-image-content">
          <h1>Create Your Account</h1>
          <p>
            Join our healthcare platform for easy and convenient management of
            your medical appointments and health records in one secure place.
          </p>
        </div>
      </div>

      <div class="register-form-container">
        <div class="auth-form">
          <div class="logo">
            <a href="${pageContext.request.contextPath}/">
              BookGarauSallah <span class="nepali-text">| बुक गरौं सल्लाह</span>
            </a>
          </div>

          <h2>Create Account</h2>
          <p class="subtitle">Please fill in your information to register</p>

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
            id="registerForm"
            action="${pageContext.request.contextPath}/register"
            method="post"
            novalidate
          >
            <div class="form-grid">
              <div class="form-group">
                <label for="fullName">Full Name</label>
                <div class="form-input">
                  <i class="fas fa-user"></i>
                  <input
                    type="text"
                    id="fullName"
                    name="name"
                    placeholder="Enter your full name"
                    required
                  />
                </div>
                <div id="fullNameError" class="validation-message">
                  Please enter your full name
                </div>
              </div>

              <div class="form-group">
                <label for="phone">Phone Number</label>
                <div class="form-input">
                  <i class="fas fa-phone"></i>
                  <input
                    type="tel"
                    id="phone"
                    name="phone"
                    placeholder="Enter phone number"
                    required
                  />
                </div>
                <div id="phoneError" class="validation-message">
                  Please enter a valid phone number
                </div>
              </div>

              <div class="form-group full-width">
                <label for="email">Email Address</label>
                <div class="form-input">
                  <i class="fas fa-envelope"></i>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    required
                  />
                </div>
                <div id="emailError" class="validation-message">
                  Please enter a valid email address
                </div>
              </div>

              <div class="form-group">
                <div class="password-label">
                  <label for="password">Password</label>
                </div>
                <div class="form-input">
                  <i class="fas fa-lock"></i>
                  <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Create a password"
                    required
                    oninput="checkPasswordStrength()"
                  />
                  <button
                    type="button"
                    class="password-toggle"
                    onclick="togglePasswordVisibility('password')"
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
                  <span id="strengthText" class="strength-text"></span>
                </div>
                <div id="passwordError" class="validation-message">
                  Password must be at least 8 characters
                </div>
              </div>

              <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <div class="form-input">
                  <i class="fas fa-lock"></i>
                  <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Confirm Password"
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
            </div>

            <button type="submit" class="btn">
              <i class="fas fa-user-plus"></i> Create Account
            </button>
          </form>

          <p class="auth-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Login here</a>
          </p>
        </div>
      </div>
    </div>

    <script>
      // Toggle password visibility
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

      // Check password strength
      function checkPasswordStrength() {
        const password = document.getElementById("password").value;
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

        // Trigger match check if confirm password has a value
        if (document.getElementById("confirmPassword").value) {
          checkPasswordsMatch();
        }
      }

      // Check if passwords match
      function checkPasswordsMatch() {
        const password = document.getElementById("password").value;
        const confirmPassword =
          document.getElementById("confirmPassword").value;
        const matchDisplay = document.getElementById("passwordMatch");

        matchDisplay.style.display = "block";

        if (confirmPassword.length === 0) {
          matchDisplay.style.display = "none";
          return;
        }

        if (password === confirmPassword) {
          matchDisplay.innerHTML =
            '<i class="fas fa-check-circle"></i> Passwords match';
          matchDisplay.style.color = "var(--success)";
          document
            .getElementById("confirmPassword")
            .classList.remove("input-error");
        } else {
          matchDisplay.innerHTML =
            '<i class="fas fa-times-circle"></i> Passwords do not match';
          matchDisplay.style.color = "var(--error)";
          document
            .getElementById("confirmPassword")
            .classList.add("input-error");
        }
      }

      // Form validation
      document
        .getElementById("registerForm")
        .addEventListener("submit", function (event) {
          let isValid = true;

          // Validate full name (no numbers allowed)
          const fullName = document.getElementById("fullName");
          const fullNameError = document.getElementById("fullNameError");
          const namePattern = /^[A-Za-z\s]+$/;

          if (
            !fullName.value ||
            fullName.value.trim().length < 3 ||
            !namePattern.test(fullName.value)
          ) {
            fullName.classList.add("input-error");
            fullNameError.style.display = "block";

            if (
              !namePattern.test(fullName.value) &&
              fullName.value.trim().length > 0
            ) {
              fullNameError.textContent =
                "Name should not contain numbers or special characters";
            } else {
              fullNameError.textContent =
                "Please enter your full name (at least 3 characters)";
            }

            isValid = false;
          } else {
            fullName.classList.remove("input-error");
            fullNameError.style.display = "none";
          }

          // Validate email
          const email = document.getElementById("email");
          const emailError = document.getElementById("emailError");
          const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

          if (!email.value || !emailPattern.test(email.value)) {
            email.classList.add("input-error");
            emailError.style.display = "block";
            isValid = false;
          } else {
            email.classList.remove("input-error");
            emailError.style.display = "none";
          }

          // Validate phone
          const phone = document.getElementById("phone");
          const phoneError = document.getElementById("phoneError");
          const phonePattern = /^[\d\s\+\-]{10,15}$/;

          if (!phone.value || !phonePattern.test(phone.value)) {
            phone.classList.add("input-error");
            phoneError.style.display = "block";
            isValid = false;
          } else {
            phone.classList.remove("input-error");
            phoneError.style.display = "none";
          }

          // Validate password
          const password = document.getElementById("password");
          const passwordError = document.getElementById("passwordError");

          if (!password.value || password.value.length < 8) {
            password.classList.add("input-error");
            passwordError.style.display = "block";
            isValid = false;
          } else {
            password.classList.remove("input-error");
            passwordError.style.display = "none";
          }

          // Validate password confirmation
          const confirmPassword = document.getElementById("confirmPassword");
          const passwordMatch = document.getElementById("passwordMatch");

          if (
            !confirmPassword.value ||
            confirmPassword.value !== password.value
          ) {
            confirmPassword.classList.add("input-error");
            passwordMatch.style.display = "block";
            passwordMatch.innerHTML =
              '<i class="fas fa-times-circle"></i> Passwords do not match';
            passwordMatch.style.color = "var(--error)";
            isValid = false;
          }

          if (!isValid) {
            event.preventDefault();
          }
        });

      // Add input event listeners to clear validation errors
      const inputs = document.querySelectorAll("#registerForm input");
      inputs.forEach((input) => {
        input.addEventListener("input", function () {
          this.classList.remove("input-error");
          const errorElement = document.getElementById(this.id + "Error");
          if (errorElement) {
            errorElement.style.display = "none";
          }

          // Special validation for name field to prevent numbers
          if (this.id === "fullName") {
            const namePattern = /^[A-Za-z\s]+$/;
            const nameError = document.getElementById("fullNameError");

            if (this.value && !namePattern.test(this.value)) {
              this.classList.add("input-error");
              nameError.textContent =
                "Name should not contain numbers or special characters";
              nameError.style.display = "block";
            }
          }
        });
      });
    </script>
  </body>
</html>
