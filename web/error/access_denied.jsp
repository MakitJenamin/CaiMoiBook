<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Truy cập bị từ chối</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styleindex.css">
    <style>
        .error-container {
            text-align: center;
            padding: 100px 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .error-icon {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 30px;
        }
        .back-link {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .back-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">🚫</div>
        <h1 class="error-title">Truy cập bị từ chối</h1>
        <p class="error-message">
            Bạn không có quyền truy cập vào trang này. 
            Vui lòng đăng nhập với tài khoản có quyền phù hợp hoặc liên hệ quản trị viên nếu bạn cho rằng đây là lỗi.
        </p>
        <a href="<%= request.getContextPath() %>/index.jsp" class="back-link">Trở về trang chủ</a>
    </div>
</body>
</html> 