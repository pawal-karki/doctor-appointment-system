<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .footer {
    background-color: #1a202c;
    color: #ffffff;
    padding: 4rem 0 2rem;
    margin-top: 4rem;
    position: relative;
  }

  .footer::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(to right, #3498db, #2ecc71, #9b59b6);
  }

  .footer-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 2rem;
  }

  .footer-grid {
    display: grid;
    grid-template-columns: 2fr 1fr 1.5fr;
    gap: 4rem;
    margin-bottom: 3rem;
  }

  .footer-section h3 {
    color: #ffffff;
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 1.5rem;
    position: relative;
    padding-bottom: 0.75rem;
  }

  .footer-section h3::after {
    content: "";
    position: absolute;
    left: 0;
    bottom: 0;
    width: 40px;
    height: 2px;
    background: #3498db;
  }

  .footer-about p {
    color: #cbd5e1;
    line-height: 1.7;
    margin-bottom: 1.5rem;
  }

  .footer-links {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .footer-links li {
    margin-bottom: 0.75rem;
  }

  .footer-links a {
    color: #cbd5e1;
    text-decoration: none;
    transition: color 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
  }

  .footer-links a:hover {
    color: #3498db;
  }

  .footer-contact p {
    color: #cbd5e1;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
  }

  .footer-contact i {
    color: #3498db;
    font-size: 1.1rem;
  }

  .social-links {
    display: flex;
    gap: 1rem;
    margin-top: 1.5rem;
  }

  .social-links a {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
    color: #ffffff;
    transition: all 0.3s ease;
  }

  .social-links a:hover {
    background: #3498db;
    transform: translateY(-3px);
  }

  .footer-bottom {
    text-align: center;
    padding-top: 2rem;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
  }

  .footer-bottom p {
    color: #cbd5e1;
    font-size: 0.95rem;
  }

  @media (max-width: 768px) {
    .footer {
      padding: 3rem 0 2rem;
    }

    .footer-grid {
      grid-template-columns: 1fr;
      gap: 2rem;
    }

    .footer-section h3 {
      margin-bottom: 1rem;
    }
  }
</style>

<!-- Add Font Awesome for icons -->
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
/>

<footer class="footer">
  <div class="footer-container">
    <div class="footer-grid">
      <div class="footer-section footer-about">
        <h3>About BookGarauSallah</h3>
        <p>
          Your trusted platform for booking medical consultations and
          appointments. We connect you with qualified healthcare professionals
          to ensure you receive the best possible care.
        </p>
        <div class="social-links">
          <a href="#"><i class="fab fa-facebook-f"></i></a>
          <a href="#"><i class="fab fa-twitter"></i></a>
          <a href="#"><i class="fab fa-instagram"></i></a>
          <a href="#"><i class="fab fa-linkedin-in"></i></a>
        </div>
      </div>

      <div class="footer-section">
        <h3>Quick Links</h3>
        <ul class="footer-links">
          <li>
            <a href="${pageContext.request.contextPath}/"
              ><i class="fas fa-chevron-right"></i> Home</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/about"
              ><i class="fas fa-chevron-right"></i> About Us</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/departments"
              ><i class="fas fa-chevron-right"></i> Departments</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/doctors"
              ><i class="fas fa-chevron-right"></i> Doctors</a
            >
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/contact"
              ><i class="fas fa-chevron-right"></i> Contact</a
            >
          </li>
        </ul>
      </div>

      <div class="footer-section footer-contact">
        <h3>Contact Info</h3>
        <p><i class="fas fa-map-marker-alt"></i> Kathmandu, Nepal</p>
        <p><i class="fas fa-phone"></i> +977 1234567890</p>
        <p><i class="fas fa-envelope"></i> info@bookgarausallah.com</p>
        <p><i class="fas fa-clock"></i> Mon - Sat: 9:00 AM - 6:00 PM</p>
      </div>
    </div>

    <div class="footer-bottom">
      <p>
        &copy;
        <script>
          document.write(new Date().getFullYear());
        </script>
        BookGarauSallah. All rights reserved.
      </p>
    </div>
  </div>
</footer>

<script>
  // Set current year in copyright
  document.addEventListener("DOMContentLoaded", function () {
    const yearElement = document.querySelector(".footer-copyright");
    if (yearElement) {
      const currentYear = new Date().getFullYear();
      yearElement.innerHTML = yearElement.innerHTML.replace(
        "${currentYear}",
        currentYear
      );
    }
  });
</script>
