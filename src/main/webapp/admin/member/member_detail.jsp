<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="user.UserDTO" %>

<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<head>
  <title>회원관리 - 상세조회</title>
</head>
<%
int userId = Integer.parseInt(request.getParameter("user_id"));
UserService service = new UserService();
UserDTO user = service.getUserById(userId);
%>

<style>
 .main-container {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 2rem 2rem 2rem 260px; /* sidebar 여백 고려 */
  }



.content-wrapper {
    max-width: 1200px;
    margin: 0 auto;
}

.page-header {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(20px);
    border-radius: 20px;
    padding: 2rem;
    margin-bottom: 2rem;
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
}

.page-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: white;
    margin: 0;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.page-subtitle {
    color: rgba(255, 255, 255, 0.8);
    font-size: 1.1rem;
    margin: 0.5rem 0;
}

.alert-modern {
    background: rgba(220, 53, 69, 0.1);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(220, 53, 69, 0.3);
    border-radius: 15px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    color: #dc3545;
    box-shadow: 0 8px 32px rgba(220, 53, 69, 0.2);
}

.info-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 3rem;
    margin-bottom: 2rem;
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.info-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
}

.section-title {
    font-size: 1.8rem;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 2rem;
    position: relative;
    padding-bottom: 1rem;
}

.section-title::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 60px;
    height: 3px;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border-radius: 2px;
}

.form-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
    margin-bottom: 2rem;
}

.form-group {
    position: relative;
}

.form-label {
    font-weight: 600;
    color: #34495e;
    margin-bottom: 0.8rem;
    display: block;
    font-size: 0.95rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.form-input {
    width: 100%;
    padding: 1rem 1.5rem;
    border: 2px solid #e1e8ed;
    border-radius: 15px;
    font-size: 1rem;
    background: #f8f9fa;
    transition: all 0.3s ease;
    color: #2c3e50;
    font-weight: 500;
}

.form-input:focus {
    outline: none;
    border-color: #667eea;
    background: white;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    transform: translateY(-2px);
}

.gender-group {
    display: flex;
    gap: 2rem;
    align-items: center;
    padding: 1rem 0;
}

.radio-wrapper {
    display: flex;
    align-items: center;
    position: relative;
    cursor: pointer;
}

.radio-input {
    width: 20px;
    height: 20px;
    margin-right: 0.8rem;
    accent-color: #667eea;
}

.radio-label {
    font-weight: 500;
    color: #2c3e50;
    cursor: pointer;
}

.address-group {
    grid-column: 1 / -1;
}

.button-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem 0;
    gap: 1rem;
}

.btn-modern {
    padding: 1rem 2.5rem;
    border: none;
    border-radius: 50px;
    font-weight: 600;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.btn-secondary {
    background: linear-gradient(135deg, #95a5a6, #7f8c8d);
    color: white;
}

.btn-secondary:hover {
    background: linear-gradient(135deg, #7f8c8d, #95a5a6);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.btn-danger {
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    color: white;
}

.btn-danger:hover {
    background: linear-gradient(135deg, #c0392b, #e74c3c);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(231, 76, 60, 0.3);
}

.status-badge {
    display: inline-block;
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.status-active {
    background: linear-gradient(135deg, #2ecc71, #27ae60);
    color: white;
}

.status-inactive {
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    color: white;
}

  @media (max-width: 992px) {
    .main-container {
      padding-left: 1rem !important;
    }
    
    .info-card {
        padding: 2rem;
    }
    
    .form-row {
        grid-template-columns: 1fr;
        gap: 1.5rem;
    }
    
    .button-container {
        flex-direction: column;
        gap: 1rem;
    }
    
    .btn-modern {
        width: 100%;
        justify-content: center;
    }
}
</style>


<div class="main-container">
  <div class="content-wrapper">
    <!-- 페이지 헤더 -->
    <div class="page-header">
      <h1 class="page-title">회원 관리</h1>
      <p class="page-subtitle">회원 정보 상세 조회</p>
    </div>

    <!-- 회원 정보 카드 -->
    <div class="info-card">
      <h2 class="section-title">기본 정보</h2>
     <!-- 이름 / 아이디 -->
<div class="form-row">
  <div class="form-group">
    <label class="form-label">이름</label>
    <input type="text" readonly class="form-input" value="<%= user.getName() %>">
  </div>
  <div class="form-group">
    <label class="form-label">아이디</label>
    <input type="text" readonly class="form-input" value="<%= user.getUsername() %>">
  </div>
</div>

<!-- 생년월일 / 성별 -->
<div class="form-row">
 <div class="form-group">
    <label class="form-label">성별</label>
    <div class="gender-group">
      <div class="radio-wrapper">
        <input class="radio-input" type="radio" name="gender" <%= "M".equals(user.getGender()) ? "checked" : "" %> disabled>
        <label class="radio-label">남성</label>
      </div>
      <div class="radio-wrapper">
        <input class="radio-input" type="radio" name="gender" <%= "F".equals(user.getGender()) ? "checked" : "" %> disabled>
        <label class="radio-label">여성</label>
      </div>
    </div>
  </div>
  <div class="form-group">
    <label class="form-label">생년월일</label>
    <input type="date" readonly class="form-input" value="<%= user.getBirthdate() != null ? user.getBirthdate().toString() : "" %>">
  </div>
 
</div>

<!-- 가입일자 / 이메일 -->
<div class="form-row">
  <div class="form-group">
    <label class="form-label">가입일자</label>
    <input type="text" readonly class="form-input" value="<%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "" %>">
  </div>
  <div class="form-group">
    <label class="form-label">이메일</label>
    <input type="email" readonly class="form-input" value="<%= user.getEmail() %>">
  </div>
</div>

<!-- 휴대전화 / 우편번호 -->
<div class="form-row">
  <div class="form-group">
    <label class="form-label">휴대전화</label>
    <input type="tel" readonly class="form-input" value="<%= user.getPhone() %>">
  </div>
  <div class="form-group">
    <label class="form-label">우편번호</label>
    <input type="text" readonly class="form-input" value="<%= user.getZipcode() != null ? user.getZipcode() : "" %>">
  </div>
</div>

<!-- 주소 -->
<div class="form-row">
  <div class="form-group address-group">
    <label class="form-label">주소</label>
    <input type="text" readonly class="form-input" value="<%= user.getAddress1() != null ? user.getAddress1() : "" %> <%= user.getAddress2() != null ? user.getAddress2() : "" %>">
  </div>
</div>

    </div>

    <!-- 버튼 영역 -->
    <div class="button-container">
      <button class="btn-modern btn-secondary" onclick="history.back()">← 뒤로 가기</button>
      <% if (!"U2".equals(user.getUserStatus())) { %>
        <button class="btn-modern btn-danger" onclick="location.href='member_withdraw_confirm.jsp?user_id=<%= user.getUserId() %>&username=<%= user.getName() %>'">
          🗑️ 탈퇴 처리
        </button>
      <% } %>
    </div>
  </div>
</div>