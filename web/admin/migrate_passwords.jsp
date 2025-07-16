<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Migrate Passwords</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    </head>
    <body>
        <div class="container">
            <h1>Migrate Passwords</h1>
            <p>This will migrate all existing plain text passwords to secure hashed passwords.</p>
            <p><strong>Warning:</strong> This operation should only be performed once during system upgrade.</p>
            
            <form action="${pageContext.request.contextPath}/admin/migratePasswords" method="post">
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Start Migration</button>
                </div>
                <div class="form-group">
                    <a href="${pageContext.request.contextPath}/admin_config.jsp" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </body>
</html> 