<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Password Migration Result</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    </head>
    <body>
        <div class="container">
            <h1>Password Migration Result</h1>
            
            <div class="alert alert-success">
                <p>Migration completed successfully.</p>
                <p>Number of passwords migrated: <strong>${migratedCount}</strong></p>
            </div>
            
            <div class="form-group">
                <a href="${pageContext.request.contextPath}/admin_config.jsp" class="btn btn-primary">Back to Admin</a>
            </div>
        </div>
    </body>
</html> 