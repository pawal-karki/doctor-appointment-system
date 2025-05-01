<%--
  Created by IntelliJ IDEA.
  User: pawal
  Date: 4/22/2025
  Time: 8:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ taglib prefix="c"
                                           uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    :root {
        --primary-color: #2563eb;
        --primary-hover: #1d4ed8;
        --secondary-color: #64748b;
        --background-color: #f8fafc;
        --text-color: #1e293b;
        --sidebar-width: 250px;
        --border-radius: 0.5rem;
        --transition: all 0.3s ease;
        --header-height: 70px;
    }

    .header {
        height: var(--header-height);
        background-color: white;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .header-left {
        display: flex;
        align-items: center;
    }

    .mobile-toggle {
        display: none;
        background: none;
        border: none;
        font-size: 1.5rem;
        color: var(--text-color);
        cursor: pointer;
        margin-right: 1rem;
    }

    .header-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--text-color);
    }

    .header-right {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .header-search {
        position: relative;
    }

    .header-search input {
        padding: 0.5rem 1rem 0.5rem 2.5rem;
        border: 1px solid #e2e8f0;
        border-radius: var(--border-radius);
        font-size: 0.875rem;
        width: 250px;
        transition: var(--transition);
    }

    .header-search input:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .header-search i {
        position: absolute;
        left: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--secondary-color);
    }

    .header-user {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        cursor: pointer;
        position: relative;
    }

    .header-user-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        overflow: hidden;
    }

    .header-user-img img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .header-user-info {
        display: none;
    }

    .header-user-name {
        font-weight: 500;
        color: var(--text-color);
    }

    .header-user-role {
        font-size: 0.75rem;
        color: var(--secondary-color);
    }

    .header-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        background-color: white;
        border-radius: var(--border-radius);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
        0 4px 6px -2px rgba(0, 0, 0, 0.05);
        min-width: 200px;
        z-index: 100;
        display: none;
    }

    .header-dropdown.show {
        display: block;
    }

    .header-dropdown-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem 1rem;
        color: var(--text-color);
        text-decoration: none;
        transition: var(--transition);
    }

    .header-dropdown-item:hover {
        background-color: #f8fafc;
    }

    .header-dropdown-divider {
        border-top: 1px solid #e2e8f0;
        margin: 0.5rem 0;
    }

    @media (min-width: 768px) {
        .header-user-info {
            display: block;
        }
    }

    @media (max-width: 768px) {
        .mobile-toggle {
            display: block;
        }

        .header-search {
            display: none;
        }
    }
</style>

<div class="header">
    <div class="header-left">
        <button class="mobile-toggle" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
        <div class="header-title">
            <c:choose>
                <c:when test="${pageContext.request.servletPath.contains('/dashboard')}"
                >Dashboard</c:when
                >
                <c:when
                        test="${pageContext.request.servletPath.contains('/appointments')}"
                >Appointments</c:when
                >
                <c:when test="${pageContext.request.servletPath.contains('/timeslots')}"
                >Time Slots</c:when
                >
                <c:when
                        test="${pageContext.request.servletPath.contains('/departments')}"
                >Departments</c:when
                >
                <c:when test="${pageContext.request.servletPath.contains('/doctors')}"
                >Doctors</c:when
                >
                <c:when test="${pageContext.request.servletPath.contains('/patients')}"
                >Patients</c:when
                >
                <c:when test="${pageContext.request.servletPath.contains('/profile')}"
                >Profile</c:when
                >
                <c:otherwise>Hospital Management System</c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="header-right">
        <div class="header-user" onclick="toggleUserDropdown()">
            <div class="header-user-img">
                <div class="profile-image">
                    <c:choose>
                        <c:when test="${not empty user.imageUrl}">
                            <img src="${pageContext.request.contextPath}/${user.imageUrl}" alt="${user.name}" id="preview-image">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default-user.jpg" alt="Default User" id="preview-image">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="header-user-info">
                <div class="header-user-name">Admin User</div>
                <div class="header-user-role">Administrator</div>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleUserDropdown() {
        document.getElementById("userDropdown").classList.toggle("show");
    }

    // Close the dropdown if clicked outside
    window.onclick = function (event) {
        if (!event.target.closest(".header-user")) {
            var dropdown = document.getElementById("userDropdown");
            if (dropdown.classList.contains("show")) {
                dropdown.classList.remove("show");
            }
        }
    };
</script>

