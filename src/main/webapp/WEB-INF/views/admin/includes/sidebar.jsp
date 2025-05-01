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
        --sidebar-bg: #1e293b;
        --sidebar-hover: #334155;
        --sidebar-active: #2563eb;
        --sidebar-text: #f8fafc;
        --sidebar-text-muted: #94a3b8;
        --border-radius: 0.5rem;
        --transition: all 0.3s ease;
    }

    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: var(--sidebar-width);
        height: 100vh;
        background-color: var(--sidebar-bg);
        color: var(--sidebar-text);
        overflow-y: auto;
        z-index: 100;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        transition: var(--transition);
    }

    .sidebar-header {
        padding: 1.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .sidebar-logo {
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--sidebar-text);
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .sidebar-logo i {
        font-size: 1.5rem;
    }

    .sidebar-menu {
        padding: 1rem 0;
    }

    .sidebar-title {
        padding: 0.75rem 1.5rem;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: var(--sidebar-text-muted);
        font-weight: 600;
    }

    .sidebar-item {
        position: relative;
    }

    .sidebar-link {
        display: flex;
        align-items: center;
        padding: 0.75rem 1.5rem;
        color: var(--sidebar-text);
        text-decoration: none;
        transition: var(--transition);
        gap: 0.75rem;
    }

    .sidebar-link:hover {
        background-color: var(--sidebar-hover);
    }

    .sidebar-link.active {
        background-color: var(--sidebar-active);
        font-weight: 500;
    }

    .sidebar-link i {
        width: 1.25rem;
        font-size: 1.25rem;
        text-align: center;
    }

    .sidebar-link span {
        flex: 1;
    }

    .sidebar-divider {
        margin: 0.5rem 0;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
        }

        .sidebar.show {
            transform: translateX(0);
        }
    }
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <a
                href="${pageContext.request.contextPath}/admin/dashboard"
                class="sidebar-logo"
        >
            <i class="fas fa-hospital"></i>
            <span>HMS Admin</span>
        </a>
    </div>

    <div class="sidebar-menu">
        <div class="sidebar-title">Main</div>
        <div class="sidebar-item">
            <a
                    href="${pageContext.request.contextPath}/admin/dashboard"
                    class="sidebar-link ${pageContext.request.servletPath.contains('/dashboard') ? 'active' : ''}"
            >
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </div>

        <div class="sidebar-title">Management</div>
        <div class="sidebar-item">
            <a
                    href="${pageContext.request.contextPath}/admin/appointments"
                    class="sidebar-link ${pageContext.request.servletPath.contains('/appointments') ? 'active' : ''}"
            >
                <i class="fas fa-calendar-check"></i>
                <span>Appointments</span>
            </a>
        </div>
        <div class="sidebar-item">
            <a
                    href="${pageContext.request.contextPath}/admin/timeslots"
                    class="sidebar-link ${pageContext.request.servletPath.contains('/timeslots') ? 'active' : ''}"
            >
                <i class="fas fa-clock"></i>
                <span>Time Slots</span>
            </a>
        </div>
        <div class="sidebar-item">
            <a
                    href="${pageContext.request.contextPath}/admin/departments"
                    class="sidebar-link ${pageContext.request.servletPath.contains('/departments') ? 'active' : ''}"
            >
                <i class="fas fa-building"></i>
                <span>Departments</span>
            </a>
        </div>
        <div class="sidebar-item">
            <a
                    href="${pageContext.request.contextPath}/admin/doctors"
                    class="sidebar-link ${pageContext.request.servletPath.contains('/doctors') ? 'active' : ''}"
            >
                <i class="fas fa-user-md"></i>
                <span>Doctors</span>
            </a>
        </div>
        <div class="sidebar-divider"></div>

        <div class="sidebar-title">Settings</div>
        <div class="sidebar-item">
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>

        <div class="sidebar-divider"></div>

        <div class="sidebar-title">Navigation</div>
        <div class="sidebar-item">
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="fas fa-home"></i>
                <span>Back to Homepage</span>
            </a>
        </div>
    </div>
</div>

<script>
    // For mobile toggle
    function toggleSidebar() {
        document.querySelector(".sidebar").classList.toggle("show");
    }
</script>

