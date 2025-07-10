<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Book" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    String status = (String) session.getAttribute("status");
    if ("inactive".equalsIgnoreCase(status)) {
        out.println("<div style='text-align:center; padding: 50px; font-size: 24px; color: red;'>🚫 Account was disabled</div>");
        return;
    }
%>
<%
    if (request.getAttribute("bookList") == null) {
        response.sendRedirect("MainController?action=search");
        return;
    }
%>
<% 
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    
%>
<%
    List<Book> books = (List<Book>) request.getAttribute("bookList");
    if (books == null) {
        books = new ArrayList<>();
    }
    Map<Integer, String> bookStatusMap = (Map<Integer, String>) request.getAttribute("bookStatusMap");
    if (bookStatusMap == null) {
        bookStatusMap = new HashMap<>();
    }
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>
<!DOCTYPE html>

<html>

<head>
    <title>Online library</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Library</title>
    <link rel="stylesheet" href="css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="header">
        <div class="header-logo">
            <img src="images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="LibraryOnline Logo" class="logo">
            <span class="titleName">LibraryOnline</span>
        </div>

        <div class="nav-header">
            <a href="index.jsp" class="item-header">Home</a>
            <a href="MainController?action=search" class="item-header">Browse</a>
            <a href="#" class="item-header">Categories</a>
            <a href="#" class="item-header">About</a>
            <a href="#" class="item-header">Contact</a>
            <% if ("user".equals(role)) { %>
                <a href="MainController?action=history" class="item-header">Lịch sử mượn</a>
                <a href="MainController?action=requestHistory" class="item-header">Lịch sử yêu cầu</a>
            <% } else if ("admin".equals(role)) { %>
                <a href="admin/panel.jsp" class="item-header">Admin Panel</a>
            <% } %>
        </div>

        <div class="function-header">
            <form id="headerSearchForm" action="MainController" method="get" style="display: flex; align-items: center;">
                <input type="search" name="title" class="form-search" placeholder="Search for books...">
                <input type="hidden" name="action" value="search">
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
            </form>
            
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='index.jsp'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='MainController?action=logout'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='register.jsp'">Register</button>

            <% } %>

            <a href="search.jsp" class="join">Join Library</a>  
        </div>

    </div>
    <% if (message != null) { %>
        <div style="text-align: center; padding: 10px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 5px; margin: 10px auto; width: 80%;">
            <%= message %>
        </div>
    <% } %>
    <div class="container">
            <% if ("admin".equals(role)) { %>
    <div style="margin: 10px 0;">
        <a href="admin/panel.jsp" style="color: red; font-weight: bold; font-size: 1.2rem;">
            🛠️ Vào trang quản trị
        </a>
    </div>
<% } %>
            <% if ("user".equals(role)) { %>
    <div style="margin: 10px 0;">
        <a href="MainController?action=history" style="color: red; font-weight: bold;">
            📓 History Borrored Book
        </a>
    </div>
<% } %>

        <div class="grid">
            <div class="text-section">
                <h1>Discover Your Next Favorite Book</h1>
                <p>Explore our vast collection of books across all genres. From bestsellers to classics, we have
                    something for everyone.</p>
                <div class="button-group">
                    <button class="primary-btn">Browse Collection</button>
                    <button class="secondary-btn">Learn More</button>
                </div>
            </div>

            <div class="book-card">
                <div class="card-theGreatGatsby">
                    <div class="card-image">
                        <img src="/placeholder.svg?height=600&width=400" alt="The Great Gatsby" />
                    </div>
                    <div class="card-content">
                        <div class="rating">
                            <span class="star filled">★</span>
                            <span class="star filled">★</span>
                            <span class="star filled">★</span>
                            <span class="star filled">★</span>
                            <span class="star">★</span>
                            <span class="rating-value">4.5</span>
                        </div>
                        <h3>The Great Gatsby</h3>
                        <p class="author">by F. Scott Fitzgerald</p>
                        <p class="description">A captivating story that follows the mysterious millionaire Jay Gatsby
                            and his obsession with the beautiful Daisy Buchanan. Set in the summer of 1922, this
                            American classic explores themes of decadence, idealism, and the American Dream.</p>
                        <div class="card-buttons">
                            <button class="primary-btn small">Read Now</button>
                            <button class="secondary-btn small">Add to List</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section class="section">
    <div class="container">
      <div class="section-header">
        <h2>New Arrivals</h2>
        <p>Check out the latest additions to our library collection</p>
      </div>

      <div class="book-grid">
        <% for(Book b : books) { %>
        <!-- Book Card 1 -->
        <div class="book-card">
            <div class="book-image">
              <img src="/placeholder.svg?height=300&width=200" alt="<%= b.getTitle() %>" />
            </div>
            <div class="book-info">
              <h3><%= b.getTitle() %></h3>
              <p class="author">👤 <%= b.getAuthor() %></p>
              <div class="rating">
                <span class="star">★</span><span class="rating-value">4.2</span>
              </div>
              <div class="author">Số Lượng Có Thể Mượn : <%= b.getAvailableCopies() %></div>
              <button class="btn-detail" onclick="window.location.href='MainController?action=detail&id=<%= b.getId() %>'
">Chi tiết</button>
            </div>
            <% if ("user".equals(role)) { 
                String bookStatus = bookStatusMap.getOrDefault(b.getId(), "AVAILABLE");
                if (b.getAvailableCopies() > 0 && "AVAILABLE".equals(bookStatus)) {
            %>
            <form action="MainController" method="post" style="display:inline; width: 100%;">
                <input type="hidden" name="bookId" value="<%= b.getId() %>">
                <input type="hidden" name="userId" value="<%= userId %>">
                <input type="hidden" name="returnTo" value="index.jsp">
                <button type="submit" name="action" value="borrow" class="btn-borrow">📚 Mượn sách</button>
            </form>
            <% } else if ("REQUESTED".equals(bookStatus)) { %>
                <button disabled class="btn-requested">Đã yêu cầu</button>
            <% } else if ("BORROWED".equals(bookStatus)) { %>
                <button disabled class="btn-borrowed">Đã mượn</button>
            <% } else { %>
                <button disabled class="btn-disabled">Hết sách</button>
            <% 
                }
            } %>              
        </div>
    <% } %>

      </div>

      <div class="view-all">
        <button class="view-all-button" onclick="window.location.href='MainController?action=search'">
          View All New Arrivals
          <span class="arrow">→</span>
        </button>
      </div>
    </div>
  </section>

  <section class="popular-categories">
    <div class="container">
      <div class="section-header">
        <h2>Popular Categories</h2>
        <p>Browse books by your favorite genres</p>
      </div>
      <div class="cards">
        <a href="#" class="card">
          <div class="icon">
            📚
          </div>
          <h3>Fiction</h3>
          <p>1243 Books</p>
        </a>
        <a href="#" class="card">
          <div class="icon">
            🧪
          </div>
          <h3>Science & Technology</h3>
          <p>876 Books</p>
        </a>
        <a href="#" class="card">
          <div class="icon">
            ⏰
          </div>
          <h3>History</h3>
          <p>654 Books</p>
        </a>
        <a href="#" class="card">
          <div class="icon">
            🧑‍🏫
          </div>
          <h3>Biography</h3>
          <p>432 Books</p>
        </a>
        <a href="#" class="card">
          <div class="icon">
            💡
          </div>
          <h3>Self-Help</h3>
          <p>321 Books</p>
        </a>
        <a href="#" class="card">
          <div class="icon">
            🏆
          </div>
          <h3>Award Winners</h3>
          <p>198 Books</p>
        </a>
      </div>
    </div>
  </section>

  <section class="newsletter-section">
  <div class="container">
    <div class="newsletter-grid">
      <div class="newsletter-content">
        <div class="tag">Join Our Community</div>
        <h2>Stay Updated with Library Events</h2>
        <p>Subscribe to our newsletter to receive updates on new books, author events, reading clubs, and more.</p>
      </div>
      <form class="newsletter-form">
        <div class="input-row">
          <div class="input-group">
            <label for="first-name">First name</label>
            <input id="first-name" type="text" placeholder="Enter your first name" />
          </div>
          <div class="input-group">
            <label for="last-name">Last name</label>
            <input id="last-name" type="text" placeholder="Enter your last name" />
          </div>
        </div>
        <div class="input-group">
          <label for="email">Email</label>
          <input id="email" type="email" placeholder="Enter your email" />
        </div>
        <button type="submit">Subscribe to Newsletter</button>
      </form>
    </div>
  </div>
</section>

<div class="footer-container">
  <div class="footer-left">
    <div class="footer-brand">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor"
        stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon">
        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
      </svg>
      <span class="footer-title">LibraryOnline</span>
    </div>
    <p class="footer-description">
      Your gateway to knowledge and imagination. Explore our vast collection of books and resources.
    </p>
  </div>

  <div class="footer-links">
    <div class="footer-column">
      <h3>Explore</h3>
      <ul>
        <li><a href="#">Browse Books</a></li>
        <li><a href="#">Categories</a></li>
        <li><a href="#">New Arrivals</a></li>
        <li><a href="#">Best Sellers</a></li>
      </ul>
    </div>
    <div class="footer-column">
      <h3>Resources</h3>
      <ul>
        <li><a href="#">Reading Lists</a></li>
        <li><a href="#">Book Clubs</a></li>
        <li><a href="#">Author Events</a></li>
        <li><a href="#">Blog</a></li>
      </ul>
    </div>
    <div class="footer-column">
      <h3>Company</h3>
      <ul>
        <li><a href="#">About Us</a></li>
        <li><a href="#">Contact</a></li>
        <li><a href="#">Privacy Policy</a></li>
        <li><a href="#">Terms of Service</a></li>
      </ul>
    </div>
  </div>
</div>

<div class="footer-bottom">
  <p class="footer-copy">© 2025 LibraryOnline. All rights reserved.</p>
  <div class="footer-policies">
    <a href="#">Privacy Policy</a>
    <a href="#">Terms of Service</a>
    <a href="#">Cookie Policy</a>
  </div>
</div>  
    <script>
function showDetail(isbn, btn) {
    const popup = btn.nextElementSibling;

    if (popup.style.display === "block") {
        popup.style.display = "none";
        return;
    }

    fetch("<%= request.getContextPath() %>/MainController?action=detail&isbn=" + isbn)
        .then(res => res.json())
        .then(data => {
            console.log(data.title);
            if (data.title) {
                popup.innerHTML = 
                    "<p><strong>Tiêu đề:</strong>" + data.title + "</p>" + 
                    "<p><strong>Tác giả:</strong>" + data.author +"</p>" +
                    "<p><strong>Thể loại:</strong>" + data.category + "</p>" +
                    "<p><strong>Năm:</strong>" + data.year + "</p>" +
                    "<p><strong>Số lượng:</strong>" + data.copies + "</p>" +
                    "<p><strong>Còn lại:</strong>" + data.available + "</p>" +
                    "<p><strong>Trạng thái:</strong>" + data.status + "</p>" 
                ;
                popup.style.display = "block";
            } else {
                popup.innerHTML = "<p>Không tìm thấy thông tin sách.</p>";
                popup.style.display = "block";
            }
        });
}
    </script>

</body>

</html>