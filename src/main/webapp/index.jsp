<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Hospital Management System</title>
    <meta http-equiv="refresh" content="0;url=<c:url value='/home'/>" />
    <script type="text/javascript">
      window.location.href = "<c:url value='/home'/>";
    </script>
  </head>
  <body>
    <h1>Welcome to Hospital Management System</h1>
    <p>
      If you are not redirected automatically, please click
      <a href="<c:url value='/home'/>">here</a> to go to the home page.
    </p>
  </body>
</html>
