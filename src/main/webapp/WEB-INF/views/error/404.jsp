<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isErrorPage="true" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>404 - Page Not Found</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Arial", sans-serif;
        line-height: 1.6;
        color: #333;
        background-color: #f8f9fa;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .error-container {
        text-align: center;
        padding: 40px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        max-width: 600px;
        width: 90%;
      }

      .error-code {
        font-size: 120px;
        font-weight: bold;
        color: #007bff;
        margin-bottom: 20px;
        line-height: 1;
      }

      .error-title {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 15px;
      }

      .error-message {
        color: #666;
        margin-bottom: 30px;
      }

      .btn {
        display: inline-block;
        padding: 12px 24px;
        background-color: #007bff;
        color: #fff;
        text-decoration: none;
        border-radius: 4px;
        transition: background-color 0.3s ease;
      }

      .btn:hover {
        background-color: #0056b3;
      }
    </style>
  </head>
  <body>
    <jsp:include page="../includes/header.jsp" />

    <div class="container">
      <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-message">
          The page you are looking for might have been removed, had its name
          changed, or is temporarily unavailable.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn"
          >Go to Homepage</a
        >
      </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />
  </body>
</html>
