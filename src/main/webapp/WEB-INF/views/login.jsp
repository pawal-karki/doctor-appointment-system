<%--
  Created by IntelliJ IDEA.
  User: pawal
  Date: 4/21/2025
  Time: 11:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib prefix="c"
                                           uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - BokGarauSallah</title>
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
            line-height: 1.6;
            color: var(--text);
            background-color: var(--light-gray);
            min-height: 100vh;
        }

        .login-container {
            display: flex;
            min-height: 100vh;
        }

        /* Left image panel */
        .login-image {
            flex: 1;
            background-color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding: 2rem;
            overflow: hidden;
        }

        .login-image::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url("${pageContext.request.contextPath}/resources/images/login.avif");
            background-size: cover;
            background-position: center;
            opacity: 0.75;
            z-index: 0;
        }

        .login-image::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.4);
            z-index: 0;
        }

        .login-image-content {
            position: relative;
            z-index: 1;
            max-width: 480px;
            text-align: center;
            padding: 2rem;
        }

        .login-image-content h1 {
            font-size: 2.25rem;
            font-weight: 700;
            color: white;
            margin-bottom: 1rem;
            line-height: 1.2;
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
        }

        .login-image-content p {
            font-size: 1.1rem;
            color: white;
            line-height: 1.6;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .login-illustration {
            display: none;
        }

        /* Right form panel */
        .login-form-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            background: var(--white);
        }

        .auth-form {
            width: 100%;
            max-width: 420px;
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

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
        }

        .remember-me input {
            margin-right: 0.5rem;
            accent-color: var(--primary);
            width: 16px;
            height: 16px;
        }

        .remember-me label {
            color: var(--gray);
            font-size: 0.9rem;
        }

        .forgot-password {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: color 0.2s ease;
        }

        .forgot-password:hover {
            text-decoration: underline;
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
            font-size: 0.8rem;
            color: var(--error);
            margin-top: 0.375rem;
            display: none;
        }

        .input-error {
            border-color: var(--error) !important;
        }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }

            .login-image {
                display: none;
            }

            .login-form-container {
                padding: 1.5rem;
            }

            .logo {
                text-align: center;
            }

            .auth-form {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-image">
        <div class="login-image-content">
            <h1>Welcome to BookGarauSallah</h1>
            <p>
                Access your account to manage appointments and view your medical
                history with our secure healthcare platform.
            </p>
        </div>
    </div>

    <div class="login-form-container">
        <div class="auth-form">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    BookGarauSallah <span class="nepali-text">| बुक गरौं सल्लाह</span>
                </a>
            </div>

            <h2>Welcome back</h2>
            <p class="subtitle">Please enter your details to sign in</p>

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
                    id="loginForm"
                    action="${pageContext.request.contextPath}/login"
                    method="post"
                    novalidate
            >
                <div class="form-group">
                    <label for="email">Email</label>
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
                    <label for="password">Password</label>
                    <div class="form-input">
                        <i class="fas fa-lock"></i>
                        <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Enter your password"
                                required
                        />
                        <button
                                type="button"
                                class="password-toggle"
                                onclick="togglePasswordVisibility()"
                                aria-label="Toggle password visibility"
                        >
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="passwordError" class="validation-message">
                        Please enter your password
                    </div>
                </div>

                <div class="form-options">
                    <div class="remember-me">
                        <input type="checkbox" id="rememberMe" name="rememberMe" />
                        <label for="rememberMe">Remember me</label>
                    </div>
                    <a
                            href="${pageContext.request.contextPath}/forgot-password"
                            class="forgot-password"
                    >
                        Forgot password?
                    </a>
                </div>

                <button type="submit" class="btn">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>

            <p class="auth-link">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register"
                >Register here</a
                >
            </p>
        </div>
    </div>
</div>

<script>
    // Toggle password visibility
    function togglePasswordVisibility() {
        const passwordInput = document.getElementById("password");
        const passwordToggle = document.querySelector(".password-toggle i");

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            passwordToggle.classList.remove("fa-eye");
            passwordToggle.classList.add("fa-eye-slash");
        } else {
            passwordInput.type = "password";
            passwordToggle.classList.remove("fa-eye-slash");
            passwordToggle.classList.add("fa-eye");
        }
    }

    // Form validation
    document
        .getElementById("loginForm")
        .addEventListener("submit", function (event) {
            let isValid = true;

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

            // Validate password
            const password = document.getElementById("password");
            const passwordError = document.getElementById("passwordError");

            if (!password.value) {
                password.classList.add("input-error");
                passwordError.style.display = "block";
                isValid = false;
            } else {
                password.classList.remove("input-error");
                passwordError.style.display = "none";
            }

            if (!isValid) {
                event.preventDefault();
            }
        });

    // Clear validation errors on input
    document.getElementById("email").addEventListener("input", function () {
        this.classList.remove("input-error");
        document.getElementById("emailError").style.display = "none";
    });

    document
        .getElementById("password")
        .addEventListener("input", function () {
            this.classList.remove("input-error");
            document.getElementById("passwordError").style.display = "none";
        });
</script>
</body>
</html>
