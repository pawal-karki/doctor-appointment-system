<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  :root {
    --header-height: 70px;
  }

  .header {
    background-color: #ffffff;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
    height: var(--header-height);
  }

  .header-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 100%;
  }

  .logo a {
    color: #2c3e50;
    font-size: 22px;
    font-weight: bold;
    text-decoration: none;
    transition: color 0.3s ease;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .logo .nepali-text {
    font-size: 20px;
    color: #3498db;
    font-weight: 500;
  }

  .logo a:hover {
    color: #3498db;
  }

  .nav ul {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
  }

  .nav li {
    margin-left: 30px;
  }

  .nav a {
    color: #2c3e50;
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    transition: color 0.3s ease;
    position: relative;
    display: inline-block;
    padding: 5px 0;
  }

  .nav a:hover {
    color: #3498db;
  }

  .nav a::after {
    content: "";
    position: absolute;
    width: 0;
    height: 2px;
    bottom: -4px;
    left: 0;
    background-color: #3498db;
    transition: width 0.3s ease;
  }

  .nav a:hover::after {
    width: 100%;
  }

  .mobile-menu-toggle {
    display: none;
    flex-direction: column;
    justify-content: space-between;
    width: 30px;
    height: 21px;
    cursor: pointer;
  }

  .mobile-menu-toggle span {
    display: block;
    height: 3px;
    width: 100%;
    background-color: #2c3e50;
    transition: all 0.3s ease;
  }

  /* Add padding to body to prevent content from being hidden under header */
  body {
    padding-top: var(--header-height);
  }

  @media (max-width: 768px) {
    .mobile-menu-toggle {
      display: flex;
    }

    .nav {
      position: absolute;
      top: var(--header-height);
      left: 0;
      right: 0;
      background-color: #ffffff;
      padding: 20px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      display: none;
    }

    .nav.active {
      display: block;
    }

    .nav ul {
      flex-direction: column;
    }

    .nav li {
      margin: 5px 0;
      text-align: center;
    }

    .nav a {
      font-size: 16px;
      padding: 8px 0;
    }
  }
</style>

<header class="header">
  <div class="header-container">
    <div class="logo">
      <a href="${pageContext.request.contextPath}/">
        BookGarauSallah <span class="nepali-text">| बुक गरौं सल्लाह</span>
      </a>
    </div>

    <nav class="nav">
      <ul>
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About</a></li>
        <li>
          <a href="${pageContext.request.contextPath}/departments"
            >Departments</a
          >
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/contact">Contact Us</a>
        </li>

        <c:choose>
          <c:when test="${empty sessionScope.user}">
            <li>
              <a href="${pageContext.request.contextPath}/login">Login</a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/register">Register</a>
            </li>
          </c:when>
          <c:otherwise>
            <c:if test="${sessionScope.user.admin}">
              <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                  >Admin Dashboard</a
                >
              </li>
            </c:if>
            <c:if test="${!sessionScope.user.admin}">
              <li>
                <a href="${pageContext.request.contextPath}/appointments"
                  >My Appointments</a
                >
              </li>
            </c:if>
            <li>
              <a href="${pageContext.request.contextPath}/profile">Profile</a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </nav>

    <div class="mobile-menu-toggle">
      <span></span>
      <span></span>
      <span></span>
    </div>
  </div>
</header>

<script>
  document
    .querySelector(".mobile-menu-toggle")
    .addEventListener("click", function () {
      document.querySelector(".nav").classList.toggle("active");
    });
</script>
