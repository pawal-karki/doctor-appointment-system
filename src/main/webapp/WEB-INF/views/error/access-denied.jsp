<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - Hospital Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --danger-color: #e74c3c;
            --text-color: #333;
            --light-bg: #f8f9fa;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: var(--text-color);
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            min-height: calc(100vh - 160px);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-container {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 40px;
            text-align: center;
            width: 100%;
            max-width: 600px;
            position: relative;
            border-top: 5px solid var(--danger-color);
        }
        
        .error-container h1 {
            color: var(--danger-color);
            margin-bottom: 30px;
            font-size: 2.5rem;
        }
        
        .error-icon {
            font-size: 80px;
            color: var(--danger-color);
            margin-bottom: 30px;
            animation: pulse 2s infinite;
        }
        
        .error-container p {
            font-size: 1.1rem;
            margin-bottom: 20px;
            color: #555;
        }
        
        .error-actions {
            margin-top: 40px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 6px rgba(52, 152, 219, 0.2);
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(52, 152, 219, 0.3);
        }
        
        @keyframes pulse {
            0% {
                transform: scale(1);
                opacity: 1;
            }
            50% {
                transform: scale(1.05);
                opacity: 0.8;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .error-container {
                padding: 30px 20px;
            }
            
            .error-icon {
                font-size: 60px;
            }
            
            .error-container h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container">
        <div class="error-container">
            <h1>Access Denied</h1>
            <div class="error-icon">
                <i class="fas fa-lock"></i>
            </div>
            <p>Sorry, you do not have permission to access this page.</p>
            <p>If you believe this is an error, please contact the system administrator.</p>
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <i class="fas fa-home"></i> Return to Home
                </a>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
</body>
</html>