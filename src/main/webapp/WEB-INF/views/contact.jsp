<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contact Us - Hospital Management System</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <!-- Add EmailJS SDK -->
    <script
      type="text/javascript"
      src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"
    ></script>
    <script type="text/javascript">
      (function () {
        // Initialize EmailJS with your public key
        emailjs.init("f-7jM0yoIuAwVUMFH");
      })();
    </script>
    <style>
      :root {
        --primary: #0ea5e9;
        --primary-dark: #0284c7;
        --secondary: #f8fafc;
        --text-dark: #1e293b;
        --text-light: #64748b;
        --text-muted: #94a3b8;
        --success: #10b981;
        --error: #ef4444;
        --border: #e2e8f0;
        --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
          0 2px 4px -2px rgba(0, 0, 0, 0.1);
        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
          0 4px 6px -4px rgba(0, 0, 0, 0.1);
        --radius-sm: 0.375rem;
        --radius: 0.5rem;
        --radius-lg: 1rem;
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Inter", sans-serif;
        line-height: 1.6;
        color: #333;
        background-color: #f8f9fa;
      }

      .support-message {
        text-align: center;
        padding: 8px 6px;
        background-color: #ffffff;
        border-bottom: 1px solid #e2e8f0;
        margin-bottom: 8px;
      }

      .support-message h2 {
        font-size: 1.5rem;
        color: #2c3e50;
        margin-bottom: 8px;
        font-weight: 600;
      }

      .support-message p {
        font-size: 1.1rem;
        color: #64748b;
        max-width: 600px;
        margin: 0 auto;
      }

      .contact-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
      }

      .contact-hero {
        background: linear-gradient(
          rgba(14, 165, 233, 0.85),
          rgba(2, 132, 199, 0.9)
        );
        padding: 6rem 0;
        color: white;
        text-align: center;
        margin-bottom: 4rem;
        position: relative;
        overflow: hidden;
      }

      .contact-hero::after {
        content: "";
        position: absolute;
        bottom: -5rem;
        left: 0;
        width: 100%;
        height: 6rem;
        background-color: #f1f5f9;
        clip-path: ellipse(50% 60% at 50% 100%);
      }

      .contact-hero h1 {
        font-size: 3rem;
        margin-bottom: 1rem;
        font-weight: 700;
        letter-spacing: -0.025em;
      }

      .contact-hero p {
        font-size: 1.125rem;
        max-width: 36rem;
        margin: 0 auto;
        opacity: 0.9;
        font-weight: 300;
      }

      .container {
        max-width: 45rem;
        margin: 0 auto;
        padding: 0 1.2rem;
      }

      .contact-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2.5rem;
        margin-bottom: 4rem;
      }

      .card {
        background: white;
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-lg);
        overflow: hidden;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
      }

      .contact-form {
        padding: 2.5rem;
      }

      .form-group {
        margin-bottom: 1.5rem;
      }

      .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        color: var(--text-dark);
        font-weight: 500;
        font-size: 0.875rem;
      }

      .form-control {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 1px solid var(--border);
        border-radius: var(--radius);
        font-size: 1rem;
        transition: all 0.2s ease;
        background-color: var(--secondary);
      }

      .form-control:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.15);
        background-color: white;
      }

      textarea.form-control {
        min-height: 6rem;
        resize: vertical;
      }

      .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: var(--radius);
        font-size: 1rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none;
      }

      .btn-primary {
        background-color: var(--primary);
        color: white;
        box-shadow: var(--shadow-sm);
      }

      .btn-primary:hover {
        background-color: var(--primary-dark);
        transform: translateY(-1px);
        box-shadow: var(--shadow);
      }

      .btn-primary:active {
        transform: translateY(0);
      }

      .btn-block {
        width: 100%;
      }

      .contact-info {
        padding: 2.5rem;
        display: flex;
        flex-direction: column;
      }

      .contact-info h2 {
        color: var(--text-dark);
        margin-bottom: 2rem;
        font-size: 1.5rem;
        font-weight: 600;
        position: relative;
        padding-bottom: 0.75rem;
        text-align: left;
      }

      .contact-info h2::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 0;
        width: 3rem;
        height: 0.25rem;
        background-color: var(--primary);
        border-radius: 1rem;
      }

      .info-grid {
        display: grid;
        gap: 2rem;
      }

      .info-item {
        display: flex;
        align-items: flex-start;
        gap: 1rem;
      }

      .info-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 2.5rem;
        height: 2.5rem;
        background-color: rgba(14, 165, 233, 0.1);
        color: var(--primary);
        border-radius: var(--radius);
        flex-shrink: 0;
      }

      .info-content h3 {
        color: var(--text-dark);
        margin-bottom: 0.5rem;
        font-size: 1rem;
        font-weight: 600;
      }

      .info-content p {
        color: var(--text-light);
        line-height: 1.6;
        font-size: 0.9375rem;
      }

      .map-section {
        margin-bottom: 4rem;
        border-radius: var(--radius-lg);
        overflow: hidden;
        box-shadow: var(--shadow-lg);
        position: relative;
        height: 28rem;
      }

      .map-section iframe {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        border: 0;
      }

      .alert {
        padding: 1rem 1.25rem;
        border-radius: var(--radius);
        margin-bottom: 1.5rem;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.9375rem;
      }

      .alert-success {
        background-color: rgba(16, 185, 129, 0.1);
        color: var(--success);
        border: 1px solid rgba(16, 185, 129, 0.2);
      }

      .alert-error {
        background-color: rgba(239, 68, 68, 0.1);
        color: var(--error);
        border: 1px solid rgba(239, 68, 68, 0.2);
      }

      .loading {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(4px);
        display: none;
        justify-content: center;
        align-items: center;
        z-index: 1000;
      }

      .loading-spinner {
        width: 3rem;
        height: 3rem;
        border: 0.25rem solid rgba(14, 165, 233, 0.2);
        border-top: 0.25rem solid var(--primary);
        border-radius: 50%;
        animation: spin 1s linear infinite;
      }

      @keyframes spin {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }

      @media (max-width: 64rem) {
        .contact-hero h1 {
          font-size: 2.5rem;
        }
      }

      @media (max-width: 48rem) {
        .contact-grid {
          grid-template-columns: 1fr;
        }

        .contact-hero {
          padding: 4rem 0;
        }

        .contact-hero h1 {
          font-size: 2.25rem;
        }

        .map-section {
          height: 20rem;
        }
      }

      @media (max-width: 36rem) {
        .contact-form,
        .contact-info {
          padding: 1.5rem;
        }
      }
    </style>
  </head>
  <body>
    <jsp:include page="includes/header.jsp" />

    <!-- Add loading overlay -->
    <div class="loading" id="loadingOverlay">
      <div class="loading-spinner"></div>
    </div>

    <div class="support-message">
      <h2>24/7 Support</h2>
      <p>
        Our dedicated team is here to assist you around the clock. Feel free to
        reach out with any questions or concerns.
      </p>
    </div>

    <div class="contact-container">
      <div class="contact-grid">
        <div class="card contact-form">
          <div
            id="successMessage"
            class="alert alert-success"
            style="display: none"
          >
            <i class="fas fa-check-circle"></i>
            <span>Your message has been sent successfully!</span>
          </div>
          <div
            id="errorMessage"
            class="alert alert-error"
            style="display: none"
          >
            <i class="fas fa-exclamation-circle"></i>
            <span>Failed to send message. Please try again later.</span>
          </div>

          <form id="contactForm" onsubmit="return sendEmail(event)">
            <div class="form-group">
              <label for="name">Full Name</label>
              <input
                type="text"
                id="name"
                name="name"
                class="form-control"
                required
                placeholder="Enter your name"
              />
            </div>

            <div class="form-group">
              <label for="email">Email Address</label>
              <input
                type="email"
                id="email"
                name="email"
                class="form-control"
                required
                placeholder="Enter your email"
              />
            </div>

            <div class="form-group">
              <label for="subject">Subject</label>
              <input
                type="text"
                id="subject"
                name="subject"
                class="form-control"
                required
                placeholder="Enter subject"
              />
            </div>

            <div class="form-group">
              <label for="message">Message</label>
              <textarea
                id="message"
                name="message"
                class="form-control"
                required
                placeholder="Enter your message"
              ></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-block">
              <i class="fas fa-paper-plane"></i>&nbsp; Send Message
            </button>
          </form>
        </div>

        <div class="card contact-info">
          <h2>Get in Touch</h2>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-icon">
                <i class="fas fa-map-marker-alt"></i>
              </div>
              <div class="info-content">
                <h3>Location</h3>
                <p>
                  Teaching Hospital, Maharajgunj<br />Kathmandu 44600, Nepal
                </p>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="fas fa-phone-alt"></i>
              </div>
              <div class="info-content">
                <h3>Phone</h3>
                <p>+977-1-4412505</p>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="fas fa-envelope"></i>
              </div>
              <div class="info-content">
                <h3>Email</h3>
                <p>info@hospital.com</p>
              </div>
            </div>

            <div class="info-item">
              <div class="info-icon">
                <i class="fas fa-clock"></i>
              </div>
              <div class="info-content">
                <h3>Working Hours</h3>
                <p>
                  24/7 Emergency Services<br />OPD: Sun-Fri (8:00 AM - 5:00 PM)
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="map-section">
        <iframe
          src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3531.845645116607!2d85.33015937531936!3d27.736161476165996!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39eb1934f6d6f751%3A0x3ddfa9b7c7e2015e!2sTeaching%20Hospital%2C%20Maharajgunj!5e0!3m2!1sen!2snp!4v1682926841952!5m2!1sen!2snp"
          allowfullscreen=""
          loading="lazy"
          referrerpolicy="no-referrer-when-downgrade"
        >
        </iframe>
      </div>
    </div>
    <script>
      function showLoading() {
        document.getElementById("loadingOverlay").style.display = "flex";
      }

      function hideLoading() {
        document.getElementById("loadingOverlay").style.display = "none";
      }

      function showMessage(isSuccess, message) {
        const successDiv = document.getElementById("successMessage");
        const errorDiv = document.getElementById("errorMessage");
        const messageSpan = isSuccess
          ? successDiv.querySelector("span")
          : errorDiv.querySelector("span");

        if (isSuccess) {
          successDiv.style.display = "flex";
          errorDiv.style.display = "none";
          messageSpan.textContent = message;
        } else {
          successDiv.style.display = "none";
          errorDiv.style.display = "flex";
          messageSpan.textContent = message;
        }

        // Auto-hide after 5 seconds
        setTimeout(() => {
          successDiv.style.display = "none";
          errorDiv.style.display = "none";
        }, 5000);
      }

      function sendEmail(event) {
        event.preventDefault();

        const form = document.getElementById("contactForm");

        // Match template parameters exactly
        const templateParams = {
          to_name: "Admin",
          from_name: form.name.value,
          from_email: form.email.value,
          subject: form.subject.value,
          message: form.message.value,
        };

        showLoading();

        if (!window.emailjs) {
          hideLoading();
          showMessage(
            false,
            "Email service not initialized. Please try again later."
          );
          return false;
        }

        // Log the parameters being sent
        console.log("Sending email with params:", templateParams);

        emailjs
          .send("service_8mlsx2e", "template_zznt6ws", templateParams)
          .then(function (response) {
            console.log("SUCCESS!", response.status, response.text);
            hideLoading();
            showMessage(true, "Your message has been sent successfully!");
            form.reset();
          })
          .catch(function (error) {
            console.error("FAILED...", error);
            hideLoading();
            let errorMessage = "Failed to send message. ";
            if (error.text) {
              errorMessage += error.text;
            } else {
              errorMessage += "Please try again later.";
            }
            showMessage(false, errorMessage);
          });

        return false;
      }
    </script>
  </body>
</html>
