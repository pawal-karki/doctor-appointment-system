<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Home - Hospital Management System</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      :root {
        --primary: #2563eb;
        --primary-light: #f0f7ff;
        --dark: #1e293b;
        --gray: #64748b;
        --light-gray: #f8fafc;
        --border: #e2e8f0;
        --white: #ffffff;
        --shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        --shadow-hover: 0 8px 15px rgba(0, 0, 0, 0.1);
      }

      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Inter", sans-serif;
        line-height: 1.6;
        color: var(--dark);
        background-color: var(--white);
      }

      .main-container {
        width: 90%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 2rem 1rem;
      }

      /* Hero Section */
      .hero-section {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 4rem;
        align-items: center;
        padding: 6rem 0;
        position: relative;
        overflow: hidden;
        border-radius: 30px;
        background: linear-gradient(
          to right,
          var(--white) 50%,
          var(--primary-light) 50%
        );
      }

      .hero-section::before {
        content: "";
        position: absolute;
        top: -50%;
        right: -20%;
        width: 80%;
        height: 200%;
        background: radial-gradient(
          circle,
          rgba(37, 99, 235, 0.03) 0%,
          transparent 70%
        );
        transform: rotate(-20deg);
        pointer-events: none;
      }

      .hero-content {
        max-width: 600px;
        padding-left: 2rem;
        position: relative;
        z-index: 1;
      }

      .hero-content h1 {
        font-size: 3.8rem;
        font-weight: 700;
        line-height: 1.1;
        margin-bottom: 1.5rem;
        color: var(--dark);
        letter-spacing: -0.02em;
        background: linear-gradient(
          to right,
          var(--dark) 0%,
          var(--primary) 100%
        );
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        animation: fadeInUp 0.8s ease-out;
      }

      .hero-content p {
        color: var(--gray);
        margin-bottom: 2.5rem;
        font-size: 1.2rem;
        line-height: 1.8;
        opacity: 0.9;
        animation: fadeInUp 0.8s ease-out 0.2s backwards;
      }

      .hero-image {
        position: relative;
        padding: 2rem;
        animation: fadeInRight 1s ease-out;
      }

      .hero-image img {
        width: 100%;
        height: auto;
        border-radius: 30px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
      }

      .hero-image:hover img {
        transform: translateY(-5px);
      }

      .stats-badge {
        position: absolute;
        bottom: 3rem;
        right: 3rem;
        background: var(--white);
        padding: 1.5rem;
        border-radius: 50%;
        width: 110px;
        height: 110px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        animation: fadeInUp 0.8s ease-out 0.4s backwards;
        transition: transform 0.3s ease;
      }

      .stats-badge:hover {
        transform: scale(1.05);
      }

      .stats-badge::before {
        content: "";
        position: absolute;
        inset: 5px;
        border: 2px dashed var(--primary);
        border-radius: 50%;
        opacity: 0.2;
      }

      .stats-badge span:first-child {
        font-size: 2.2rem;
        font-weight: 700;
        color: var(--primary);
        line-height: 1;
        margin-bottom: 0.2rem;
      }

      .stats-badge span:last-child {
        font-size: 1rem;
        color: var(--gray);
        font-weight: 500;
      }

      .btn {
        display: inline-flex;
        align-items: center;
        padding: 1rem 2rem;
        border-radius: 12px;
        font-weight: 600;
        font-size: 1.1rem;
        text-decoration: none;
        transition: all 0.3s ease;
        cursor: pointer;
        gap: 0.5rem;
        animation: fadeInUp 0.8s ease-out 0.4s backwards;
      }

      .btn-primary {
        background-color: var(--primary);
        color: var(--white);
        box-shadow: 0 10px 20px rgba(37, 99, 235, 0.15);
      }

      .btn-primary:hover {
        background-color: #1d4ed8;
        transform: translateY(-2px);
        box-shadow: 0 15px 30px rgba(37, 99, 235, 0.2);
      }

      @keyframes fadeInUp {
        from {
          opacity: 0;
          transform: translateY(20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      @keyframes fadeInRight {
        from {
          opacity: 0;
          transform: translateX(20px);
        }
        to {
          opacity: 1;
          transform: translateX(0);
        }
      }

      @media (max-width: 1024px) {
        .hero-section {
          padding: 4rem 0;
          gap: 3rem;
          border-radius: 20px;
        }

        .hero-content {
          padding-left: 1.5rem;
        }

        .hero-content h1 {
          font-size: 3.2rem;
        }

        .hero-content p {
          font-size: 1.1rem;
        }

        .stats-badge {
          width: 100px;
          height: 100px;
          bottom: 2rem;
          right: 2rem;
        }

        .stats-badge span:first-child {
          font-size: 2rem;
        }
      }

      @media (max-width: 768px) {
        .hero-section {
          grid-template-columns: 1fr;
          padding: 3rem 0;
          background: var(--white);
          gap: 2rem;
          border-radius: 15px;
          text-align: center;
        }

        .hero-content {
          padding: 0 1.5rem;
        }

        .hero-content h1 {
          font-size: 2.8rem;
        }

        .hero-image {
          order: -1;
          padding: 1.5rem;
        }

        .stats-badge {
          width: 90px;
          height: 90px;
          bottom: 1.5rem;
          right: 1.5rem;
        }

        .stats-badge span:first-child {
          font-size: 1.8rem;
        }

        .stats-badge span:last-child {
          font-size: 0.9rem;
        }

        .btn {
          padding: 0.9rem 1.8rem;
          font-size: 1rem;
        }
      }

      /* Categories Section */
      .categories-section {
        padding: 6rem 0;
        background-color: var(--light-gray);
        border-radius: 30px;
        margin: 2rem 0;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
        overflow: hidden;
        width: 100%;
      }

      .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 3rem;
        padding: 0 2rem;
        max-width: 1400px;
        margin-left: auto;
        margin-right: auto;
      }

      .section-title {
        font-size: 2.2rem;
        color: var(--dark);
        font-weight: 700;
        position: relative;
        padding-bottom: 1rem;
      }

      .section-title::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 0;
        width: 80px;
        height: 4px;
        background: linear-gradient(to right, var(--primary), #60a5fa);
        border-radius: 2px;
      }

      .categories-grid {
        display: flex;
        gap: 1.5rem;
        padding: 0 2rem;
        overflow-x: auto;
        scroll-behavior: smooth;
        -ms-overflow-style: none;
        scrollbar-width: none;
        scroll-snap-type: x mandatory;
        position: relative;
        -webkit-overflow-scrolling: touch;
        max-width: 1400px;
        margin: 0 auto;
      }

      .categories-grid::-webkit-scrollbar {
        display: none;
      }

      .category-card {
        min-width: calc((100% - 4.5rem) / 4); /* Show 4 cards with gaps */
        flex: 0 0 calc((100% - 4.5rem) / 4);
        scroll-snap-align: start;
        background: var(--white);
        border-radius: 20px;
        padding: 2.5rem 1.5rem;
        text-align: center;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        cursor: pointer;
        border: 1px solid var(--border);
        text-decoration: none;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.5rem;
      }

      .category-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.1);
        border-color: var(--primary);
      }

      .category-icon {
        width: 90px;
        height: 90px;
        background: var(--primary-light);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto;
        transition: all 0.3s ease;
        position: relative;
      }

      .category-icon::after {
        content: "";
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: 50%;
        border: 2px dashed var(--primary);
        opacity: 0.3;
        animation: spin 30s linear infinite;
      }

      @keyframes spin {
        from {
          transform: rotate(0deg);
        }
        to {
          transform: rotate(360deg);
        }
      }

      .category-card:hover .category-icon {
        background: var(--primary);
        transform: scale(1.1);
      }

      .category-card:hover .category-icon i {
        color: var(--white);
        transform: scale(1.1);
      }

      .category-icon i {
        font-size: 2.2rem;
        color: var(--primary);
        transition: all 0.3s ease;
      }

      .category-name {
        font-weight: 600;
        color: var(--dark);
        margin: 0;
        font-size: 1.3rem;
        transition: all 0.3s ease;
      }

      .category-card:hover .category-name {
        color: var(--primary);
      }

      .category-count {
        color: var(--gray);
        font-size: 0.95rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        margin: 0;
      }

      .category-count i {
        font-size: 0.9rem;
        color: var(--primary);
      }

      .navigation-buttons {
        display: flex;
        gap: 1rem;
      }

      .nav-btn {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: 2px solid var(--border);
        background: var(--white);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      }

      .nav-btn:hover {
        border-color: var(--primary);
        background: var(--primary);
      }

      .nav-btn:hover i {
        color: var(--white);
      }

      .nav-btn i {
        font-size: 1.2rem;
        color: var(--gray);
        transition: all 0.3s ease;
      }

      @media (max-width: 1200px) {
        .category-card {
          min-width: calc((100% - 3rem) / 3); /* Show 3 cards */
          flex: 0 0 calc((100% - 3rem) / 3);
        }
      }

      @media (max-width: 992px) {
        .category-card {
          min-width: calc((100% - 1.5rem) / 2); /* Show 2 cards */
          flex: 0 0 calc((100% - 1.5rem) / 2);
        }
      }

      @media (max-width: 576px) {
        .category-card {
          min-width: calc(100% - 2rem); /* Show 1 card */
          flex: 0 0 calc(100% - 2rem);
        }

        .categories-grid {
          padding: 0 1rem;
        }
      }

      /* Hide original departments for mapping */
      .hidden-department {
        display: none;
      }

      /* Add padding to the container to show partial next card */
      .categories-section .container {
        padding-right: 0;
        padding-left: 0;
      }

      /* Medical Services Section */
      .services-section {
        padding: 6rem 0;
        background-color: var(--white);
        position: relative;
      }

      .services-header {
        text-align: center;
        margin-bottom: 4rem;
      }

      .services-title {
        font-size: 2.8rem;
        color: var(--dark);
        font-weight: 700;
        margin-bottom: 2rem;
      }

      .services-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 2rem;
      }

      .service-card {
        background: var(--white);
        border-radius: 15px;
        padding: 2rem;
        transition: all 0.3s ease;
        border: 1px solid var(--border);
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
      }

      .service-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.1);
        border-color: var(--primary);
      }

      .service-icon {
        width: 60px;
        height: 60px;
        background: var(--primary);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1.5rem;
      }

      .service-icon i {
        color: var(--white);
        font-size: 1.5rem;
      }

      .service-title {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--dark);
        margin-bottom: 1rem;
      }

      .service-description {
        color: var(--gray);
        font-size: 1rem;
        line-height: 1.6;
        margin-bottom: 1.5rem;
      }

      .service-link {
        color: var(--primary);
        text-decoration: none;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        margin-top: auto;
        transition: gap 0.3s ease;
      }

      .service-link:hover {
        gap: 0.75rem;
      }

      .service-link i {
        font-size: 1rem;
        transition: transform 0.3s ease;
      }

      .service-card:hover .service-link i {
        transform: translateX(3px);
      }

      @media (max-width: 1200px) {
        .services-grid {
          grid-template-columns: repeat(2, 1fr);
          gap: 2rem;
        }
      }

      @media (max-width: 768px) {
        .services-grid {
          grid-template-columns: 1fr;
          gap: 1.5rem;
        }

        .services-title {
          font-size: 2.2rem;
        }

        .service-card {
          padding: 1.5rem;
        }
      }
    </style>
  </head>
  <body>
    <jsp:include page="includes/header.jsp" />

    <div class="main-container">
      <section class="hero-section">
        <div class="hero-content">
          <h1>Expert Healthcare at Your Service</h1>
          <p>
            Experience world-class medical care with our team of dedicated
            professionals. Your health and well-being are our top priorities.
          </p>
          <a
            href="${pageContext.request.contextPath}/departments"
            class="btn btn-primary"
            >Book an Appointment</a
          >
        </div>
        <div class="hero-image">
          <img
            src="https://img.freepik.com/free-photo/young-handsome-physician-medical-robe-with-stethoscope_1303-17818.jpg"
            alt="Doctor with patient"
          />
          <div class="stats-badge">
            <span>92%</span>
            <span>Success</span>
          </div>
        </div>
      </section>

      <section class="categories-section">
        <div class="section-header">
          <h2 class="section-title">Browse By Categories</h2>
          <div class="navigation-buttons">
            <button class="nav-btn prev-btn">
              <i class="fas fa-chevron-left"></i>
            </button>
            <button class="nav-btn next-btn">
              <i class="fas fa-chevron-right"></i>
            </button>
          </div>
        </div>

        <!-- Store departments in hidden divs for mapping -->
        <c:forEach var="department" items="${departments}">
          <div
            class="hidden-department"
            data-id="${department.id}"
            data-name="${department.name}"
          ></div>
        </c:forEach>

        <div class="categories-grid">
          <!-- Urology -->
          <a
            href="javascript:void(0)"
            onclick="redirectToDepartment('Urology')"
            class="category-card"
          >
            <div class="category-icon">
              <i class="fas fa-procedures"></i>
            </div>
            <h3 class="category-name">Urology</h3>
            <p class="category-count">
              <i class="fas fa-user-md"></i>
              <span id="urology-count">(Specialists Available)</span>
            </p>
          </a>

          <!-- Dentistry -->
          <a
            href="javascript:void(0)"
            onclick="redirectToDepartment('Dental')"
            class="category-card"
          >
            <div class="category-icon">
              <i class="fas fa-tooth"></i>
            </div>
            <h3 class="category-name">Dentist</h3>
            <p class="category-count">
              <i class="fas fa-user-md"></i>
              <span id="dental-count">(Specialists Available)</span>
            </p>
          </a>

          <!-- Medicine -->
          <a
            href="javascript:void(0)"
            onclick="redirectToDepartment('General Medicine')"
            class="category-card"
          >
            <div class="category-icon">
              <i class="fas fa-stethoscope"></i>
            </div>
            <h3 class="category-name">Medicine</h3>
            <p class="category-count">
              <i class="fas fa-user-md"></i>
              <span id="medicine-count">(Specialists Available)</span>
            </p>
          </a>

          <!-- Pediatrics -->
          <a
            href="javascript:void(0)"
            onclick="redirectToDepartment('Pediatrics')"
            class="category-card"
          >
            <div class="category-icon">
              <i class="fas fa-baby"></i>
            </div>
            <h3 class="category-name">Child Care</h3>
            <p class="category-count">
              <i class="fas fa-user-md"></i>
              <span id="pediatrics-count">(Specialists Available)</span>
            </p>
          </a>

          <!-- Cardiology -->
          <a
            href="javascript:void(0)"
            onclick="redirectToDepartment('Cardiology')"
            class="category-card"
          >
            <div class="category-icon">
              <i class="fas fa-heartbeat"></i>
            </div>
            <h3 class="category-name">Cancer</h3>
            <p class="category-count">
              <i class="fas fa-user-md"></i>
              <span id="cardiology-count">(Specialists Available)</span>
            </p>
          </a>

          <!-- Dermatology -->
          <a
            href="javascript:void(0)"
            onclick="redirectToDepartment('Dermatology')"
            class="category-card"
          >
            <div class="category-icon">
              <i class="fas fa-allergies"></i>
            </div>
            <h3 class="category-name">Skin</h3>
            <p class="category-count">
              <i class="fas fa-user-md"></i>
              <span id="dermatology-count">(Specialists Available)</span>
            </p>
          </a>
        </div>
      </section>

      <section class="services-section">
        <div class="services-header">
          <h2 class="services-title">Our Medical Services</h2>
        </div>

        <div class="services-grid">
          <!-- Online Monitoring -->
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-laptop-medical"></i>
            </div>
            <h3 class="service-title">Online Monitoring</h3>
            <p class="service-description">
              24/7 remote patient monitoring and virtual consultations for
              continuous care.
            </p>
            <a href="#" class="service-link">
              Read More <i class="fas fa-arrow-right"></i>
            </a>
          </div>

          <!-- Heart Surgery -->
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-heartbeat"></i>
            </div>
            <h3 class="service-title">Heart Surgery</h3>
            <p class="service-description">
              Advanced cardiac procedures with state-of-the-art technology and
              expert care.
            </p>
            <a href="#" class="service-link">
              Read More <i class="fas fa-arrow-right"></i>
            </a>
          </div>

          <!-- Diagnosis & Research -->
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-microscope"></i>
            </div>
            <h3 class="service-title">Diagnosis & Research</h3>
            <p class="service-description">
              Comprehensive diagnostic services and cutting-edge medical
              research.
            </p>
            <a href="#" class="service-link">
              Read More <i class="fas fa-arrow-right"></i>
            </a>
          </div>

          <!-- X-Ray Imaging -->
          <div class="service-card">
            <div class="service-icon">
              <i class="fas fa-x-ray"></i>
            </div>
            <h3 class="service-title">X-Ray Imaging</h3>
            <p class="service-description">
              Advanced imaging services with latest technology for accurate
              diagnosis.
            </p>
            <a href="#" class="service-link">
              Read More <i class="fas fa-arrow-right"></i>
            </a>
          </div>
        </div>
      </section>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <script>
      // Department mapping
      const departmentMapping = {
        Urology: "Urology",
        Dental: "Dental",
        "General Medicine": "General Medicine",
        Pediatrics: "Pediatrics",
        Cardiology: "Cardiology",
        Dermatology: "Dermatology",
      };

      // Get all hidden departments
      const hiddenDepartments = document.querySelectorAll(".hidden-department");
      const departmentData = {};

      // Create a map of department data
      hiddenDepartments.forEach((dept) => {
        departmentData[dept.dataset.name] = {
          id: dept.dataset.id,
        };
      });

      // Redirect to department
      function redirectToDepartment(specialtyName) {
        const departmentName = departmentMapping[specialtyName];
        if (departmentData[departmentName]) {
          window.location.href =
            "${pageContext.request.contextPath}/departments?action=view&id=" +
            departmentData[departmentName].id;
        }
      }

      // Category navigation
      const categoriesGrid = document.querySelector(".categories-grid");
      const prevBtn = document.querySelector(".prev-btn");
      const nextBtn = document.querySelector(".next-btn");
      const cardWidth = 300; // Approximate width of each card including gap
      let autoScrollInterval;
      let isHovered = false;

      // Function to scroll to the next set of cards
      function scrollNext() {
        if (
          categoriesGrid.scrollLeft + categoriesGrid.clientWidth >=
          categoriesGrid.scrollWidth
        ) {
          // If we're at the end, scroll back to start
          categoriesGrid.scrollTo({
            left: 0,
            behavior: "smooth",
          });
        } else {
          categoriesGrid.scrollBy({
            left: cardWidth,
            behavior: "smooth",
          });
        }
      }

      // Function to scroll to the previous set of cards
      function scrollPrev() {
        if (categoriesGrid.scrollLeft === 0) {
          // If we're at the start, scroll to end
          categoriesGrid.scrollTo({
            left: categoriesGrid.scrollWidth,
            behavior: "smooth",
          });
        } else {
          categoriesGrid.scrollBy({
            left: -cardWidth,
            behavior: "smooth",
          });
        }
      }

      // Start auto-scrolling
      function startAutoScroll() {
        autoScrollInterval = setInterval(() => {
          if (!isHovered) {
            scrollNext();
          }
        }, 3000); // Scroll every 3 seconds
      }

      // Stop auto-scrolling
      function stopAutoScroll() {
        clearInterval(autoScrollInterval);
      }

      // Event listeners for manual navigation
      prevBtn.addEventListener("click", () => {
        scrollPrev();
        stopAutoScroll();
        startAutoScroll(); // Reset the timer
      });

      nextBtn.addEventListener("click", () => {
        scrollNext();
        stopAutoScroll();
        startAutoScroll(); // Reset the timer
      });

      // Pause auto-scroll when hovering over the categories
      categoriesGrid.addEventListener("mouseenter", () => {
        isHovered = true;
      });

      categoriesGrid.addEventListener("mouseleave", () => {
        isHovered = false;
      });

      // Start the auto-scroll when the page loads
      startAutoScroll();

      // Clean up the interval when the page is hidden/inactive
      document.addEventListener("visibilitychange", () => {
        if (document.hidden) {
          stopAutoScroll();
        } else {
          startAutoScroll();
        }
      });
    </script>
  </body>
</html>
