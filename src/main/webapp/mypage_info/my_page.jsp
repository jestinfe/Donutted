<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%@ page import="java.util.*" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="/common/login_chk.jsp" %>

<%
  request.setCharacterEncoding("UTF-8");
  Integer userId = (Integer) session.getAttribute("userId");
  UserService service = new UserService();
  UserDTO user = service.getUserById(userId);
  String[] phoneParts = user.getPhone() != null 
                        ? user.getPhone().split("-") 
                        : new String[]{"","",""};
  // EL에서 참조할 수 있도록 스코프에 올려줍니다
  request.setAttribute("user", user);
  request.setAttribute("phoneParts", phoneParts);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>내 정보 조회 | Donutted</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
  <style>
    :root {
      --primary-color: #2563eb;
      --primary-hover: #1d4ed8;
      --secondary-color: #f8fafc;
      --text-primary: #0f172a;
      --text-secondary: #64748b;
      --border-color: #e2e8f0;
      --success-color: #10b981;
      --warning-color: #f59e0b;
      --danger-color: #ef4444;
      --gradient-bg: linear-gradient(135deg, #334155 0%, #475569 100%);
      --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
      --card-shadow-hover: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
      background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
      min-height: 100vh;
      color: var(--text-primary);
    }

    .mypage-container {
      padding: 2rem 0;
      min-height: 100vh;
    }

    .profile-header {
      background: #EF84A5;
      border-radius: 20px;
      padding: 2rem;
      margin-bottom: 2rem;
      color: white;
      position: relative;
      overflow: hidden;
    }

    .profile-header::before {
      content: '';
      position: absolute;
      top: 0;
      right: 0;
      width: 200px;
      height: 200px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
      transform: translate(50px, -50px);
    }

    .profile-content {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      position: relative;
      z-index: 1;
    }

    .profile-left {
      display: flex;
      align-items: center;
      gap: 1.5rem;
    }

    .profile-avatar {
      width: 80px;
      height: 80px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2rem;
      border: 3px solid rgba(255, 255, 255, 0.3);
    }

    .profile-info h2 {
      font-size: 1.8rem;
      font-weight: 600;
      margin-bottom: 0.5rem;
    }

    .profile-info p {
      opacity: 0.9;
      font-size: 1rem;
      margin-bottom: 0.25rem;
    }

    .profile-right {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 0.75rem;
    }

    .password-change-btn {
      background: rgba(255, 255, 255, 0.15);
      border: 2px solid rgba(255, 255, 255, 0.3);
      color: white;
      padding: 0.75rem 1.5rem;
      border-radius: 12px;
      text-decoration: none;
      font-weight: 500;
      font-size: 0.9rem;
      transition: all 0.3s ease;
      backdrop-filter: blur(10px);
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
    }

    .password-change-btn:hover {
      background: rgba(255, 255, 255, 0.25);
      border-color: rgba(255, 255, 255, 0.5);
      color: white;
      transform: translateY(-2px);
    }

    .join-date {
      font-size: 0.85rem;
      opacity: 0.8;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .info-cards {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      margin-bottom: 2rem;
    }

    .info-card {
      background: white;
      border-radius: 16px;
      padding: 2rem;
      box-shadow: var(--card-shadow);
      transition: all 0.3s ease;
      border: 1px solid var(--border-color);
      display: flex;
      flex-direction: column;
    }

    .info-card:hover {
      box-shadow: var(--card-shadow-hover);
      transform: translateY(-2px);
    }

    .card-header {
      display: flex;
      align-items: center;
      margin-bottom: 1.5rem;
      padding-bottom: 1rem;
      border-bottom: 2px solid var(--secondary-color);
    }

    .card-header i {
      font-size: 1.5rem;
      color: var(--primary-color);
      margin-right: 0.75rem;
    }

    .card-header h3 {
      font-size: 1.25rem;
      font-weight: 600;
      color: var(--text-primary);
      margin: 0;
    }

    .card-content {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    .form-label {
      display: block;
      font-weight: 500;
      color: var(--text-secondary);
      margin-bottom: 0.5rem;
      font-size: 0.875rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .form-control {
      width: 100%;
      padding: 0.75rem 1rem;
      border: 2px solid var(--border-color);
      border-radius: 8px;
      font-size: 1rem;
      transition: all 0.2s ease;
      background: white;
    }

    .form-control:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .form-control[readonly] {
      background: var(--secondary-color);
      cursor: not-allowed;
      color: var(--text-secondary);
    }

    .form-control[readonly]:focus {
      border-color: var(--border-color);
      box-shadow: none;
    }

    .phone-group {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 0.5rem;
    }

    .address-group {
      display: flex;
      gap: 0.5rem;
      align-items: end;
    }

    .address-input {
      flex: 1;
    }

    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 8px;
      font-weight: 500;
      font-size: 0.875rem;
      cursor: pointer;
      transition: all 0.2s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }

    .btn-primary {
      background: var(--primary-color);
      color: white;
    }

    .btn-primary:hover {
      background: var(--primary-hover);
      transform: translateY(-1px);
    }

    .btn-secondary {
      background: var(--text-secondary);
      color: white;
    }

    .btn-secondary:hover {
      background: #475569;
    }

    .btn-outline {
      background: transparent;
      border: 2px solid var(--border-color);
      color: var(--text-secondary);
    }

    .btn-outline:hover {
      background: var(--secondary-color);
      border-color: var(--text-secondary);
    }

    .btn-sm {
      padding: 0.5rem 1rem;
      font-size: 0.8rem;
    }

    .action-buttons {
      background: white;
      border-radius: 16px;
      padding: 2rem;
      box-shadow: var(--card-shadow);
      border: 1px solid var(--border-color);
      text-align: center;
    }

    .button-group {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
    }

    .edit-indicator {
      position: fixed;
      top: 20px;
      right: 20px;
      background: var(--warning-color);
      color: white;
      padding: 0.75rem 1rem;
      border-radius: 50px;
      font-weight: 500;
      display: none;
      align-items: center;
      gap: 0.5rem;
      z-index: 1000;
      box-shadow: var(--card-shadow);
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 0.25rem;
      padding: 0.25rem 0.75rem;
      border-radius: 50px;
      font-size: 0.75rem;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      background: var(--success-color);
      color: white;
    }

    @media (max-width: 768px) {
      .info-cards {
        grid-template-columns: 1fr;
        gap: 1rem;
      }
      
      .phone-group {
        grid-template-columns: 1fr;
      }
      
      .address-group {
        flex-direction: column;
        align-items: stretch;
      }
      
      .button-group {
        flex-direction: column;
      }
      
      .mypage-container {
        padding: 1rem;
      }

      .profile-content {
        flex-direction: column;
        gap: 1rem;
      }

      .profile-left {
        flex-direction: column;
        text-align: center;
      }

      .profile-right {
        align-items: center;
      }
    }

    .fade-in {
      animation: fadeIn 0.5s ease-in;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .pulse {
      animation: pulse 2s infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.7; }
    }
        /* 모달 스타일 */
    .modal-content {
      border-radius: 16px;
      border: none;
      box-shadow: var(--card-shadow-hover);
    }

    .modal-header {
      background: var(--gradient-bg);
      color: white;
      border-radius: 16px 16px 0 0;
      border-bottom: none;
      padding: 1.5rem 2rem;
    }

    .modal-title {
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .modal-body {
      padding: 2rem;
    }

    .modal-footer {
      border-top: 1px solid var(--border-color);
      padding: 1.5rem 2rem;
      background: var(--secondary-color);
      border-radius: 0 0 16px 16px;
    }

    .btn-close {
      filter: brightness(0) invert(1);
    }

    .password-change-btn {
      background: rgba(255, 255, 255, 0.15);
      border: 2px solid rgba(255, 255, 255, 0.3);
      color: white;
      padding: 0.75rem 1.5rem;
      border-radius: 12px;
      font-weight: 500;
      font-size: 0.9rem;
      transition: all 0.3s ease;
      backdrop-filter: blur(10px);
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      cursor: pointer;
    }

    .password-change-btn:hover {
      background: rgba(255, 255, 255, 0.25);
      border-color: rgba(255, 255, 255, 0.5);
      color: white;
      transform: translateY(-2px);
    }

    .password-form .form-group {
      margin-bottom: 1.5rem;
    }

    .password-form .form-label {
      font-weight: 500;
      color: var(--text-primary);
      margin-bottom: 0.5rem;
      font-size: 0.9rem;
    }

    .btn-pink {
      background: linear-gradient(135deg, #ef84a5 0%, #e26c93 100%);
      color: white;
      border: none;
      padding: 0.75rem 2rem;
      border-radius: 8px;
      font-weight: 500;
      transition: all 0.3s ease;
    }

    .btn-pink:hover {
      background: linear-gradient(135deg, #e26c93 0%, #d55a82 100%);
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(226, 108, 147, 0.4);
    }
  </style>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>

  <c:import url="/common/header.jsp"/>
  <c:import url="/common/mypage_sidebar.jsp"/>

  <div class="edit-indicator" id="editIndicator">
    <i class="fas fa-edit pulse"></i>
    수정 모드
  </div>

  <div class="mypage-container" style="padding-left:220px;">
    <div class="container">
      
      <!-- 프로필 헤더 -->
      <div class="profile-header fade-in">
        <div class="profile-content">
          <div class="profile-left">
            <div class="profile-avatar">
              <i class="fas fa-user"></i>
            </div>
            <div class="profile-info">
              <h2>${user.name}님의 프로필</h2>
              <p class="join-date">
                <i class="fas fa-calendar-alt"></i>
                가입일: ${user.createdAt}
              </p>
            </div>
          </div>
          <div class="profile-right">
            <button type="button" class="password-change-btn" data-bs-toggle="modal" data-bs-target="#passwordModal">
			  <i class="fas fa-key"></i>
			  비밀번호 변경
			</button>
          </div>
        </div>
      </div>

      <form id="userForm" action="user_update_ok.jsp" method="post">
        <input type="hidden" name="user_id" value="${user.userId}"/>

        <!-- 정보 카드들 -->
        <div class="info-cards">
          
          <!-- 기본 정보 카드 -->
          <div class="info-card fade-in">
            <div class="card-header">
              <i class="fas fa-id-card"></i>
              <h3>기본 정보</h3>
            </div>
            <div class="card-content">
              <div class="form-group">
                <label class="form-label">이름</label>
                <input class="form-control" value="${user.name}" readonly>
              </div>
              
              <div class="form-group">
                <label class="form-label">아이디</label>
                <input class="form-control" value="${user.username}" readonly>
              </div>
              
              <div class="form-group">
                <label class="form-label">생년월일</label>
                <input type="date" class="form-control" value="${user.birthdate}" readonly>
              </div>
              
              <div class="form-group">
                <label class="form-label">성별</label>
                <select class="form-control" disabled>
                  <option value="M" ${user.gender=='M'?'selected':''}>남성</option>
                  <option value="F" ${user.gender=='F'?'selected':''}>여성</option>
                </select>
              </div>
            </div>
          </div>

          <!-- 연락처 정보 카드 -->
          <div class="info-card fade-in">
            <div class="card-header">
              <i class="fas fa-envelope"></i>
              <h3>연락처 정보</h3>
            </div>
            <div class="card-content">
              <div class="form-group">
                <label class="form-label">이메일 주소</label>
                <input type="email" name="email" class="form-control" value="${user.email}" readonly>
              </div>
              
              <div class="form-group">
                <label class="form-label">휴대폰 번호</label>
                <div class="phone-group">
                  <input type="text" name="phone1" maxlength="3" class="form-control" 
                         value="${phoneParts[0]}" readonly placeholder="010">
                  <input type="text" name="phone2" maxlength="4" class="form-control" 
                         value="${phoneParts[1]}" readonly placeholder="1234">
                  <input type="text" name="phone3" maxlength="4" class="form-control" 
                         value="${phoneParts[2]}" readonly placeholder="5678">
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 주소 정보 카드 (전체 너비) -->
        <div class="info-card fade-in" style="margin-bottom: 2rem;">
          <div class="card-header">
            <i class="fas fa-map-marker-alt"></i>
            <h3>주소 정보</h3>
          </div>
          
          <div class="form-group">
            <label class="form-label">우편번호</label>
            <div class="address-group">
              <input type="text" name="zipcode" id="zipcode" class="form-control address-input" 
                     value="${user.zipcode}" readonly style="max-width:150px;">
              <button type="button" id="btnZipcode" class="btn btn-outline btn-sm" disabled>
                <i class="fas fa-search"></i> 우편번호 검색
              </button>
            </div>
          </div>
          
          <div class="form-group">
            <label class="form-label">기본 주소</label>
            <input type="text" name="addr1" id="addr" class="form-control" 
                   value="${user.address1}" readonly>
          </div>
          
          <div class="form-group">
            <label class="form-label">상세 주소</label>
            <input type="text" name="addr2" id="addr2" class="form-control" 
                   value="${user.address2}" readonly placeholder="상세 주소를 입력해주세요">
          </div>
        </div>

        <!-- 액션 버튼들 -->
        <div class="action-buttons fade-in">
          <div class="button-group" id="edit-buttons">
            <button type="button" id="btnEdit" class="btn btn-primary">
              <i class="fas fa-edit"></i> 정보 수정하기
            </button>
          </div>
          
          <div class="button-group d-none" id="save-buttons">
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-save"></i> 변경사항 저장
            </button>
            <button type="button" id="btnCancel" class="btn btn-secondary">
              <i class="fas fa-times"></i> 취소
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
  <!-- 비밀번호 변경 모달 -->
  <div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="passwordModalLabel">
            <i class="fas fa-key"></i>
            비밀번호 변경
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="passwordForm" class="password-form">
          <div class="modal-body">
            <input type="hidden" name="user_id" value="${user.userId}">
            
            <div class="form-group">
              <label class="form-label">현재 비밀번호</label>
              <input type="password" name="currentPassword" class="form-control" required>
            </div>

            <div class="form-group">
              <label class="form-label">새 비밀번호</label>
              <input type="password" name="newPassword" class="form-control" required>
            </div>

            <div class="form-group">
              <label class="form-label">새 비밀번호 확인</label>
              <input type="password" name="confirmPassword" class="form-control" required>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
              <i class="fas fa-times"></i> 취소
            </button>
            <button type="submit" class="btn btn-pink">
              <i class="fas fa-save"></i> 변경하기
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <c:import url="/common/footer.jsp"/>

  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  
  
  <script>
    $(function(){
      var original = {};
      
      // 우편번호 검색 함수
      function findZipcode() {
        new daum.Postcode({
          oncomplete: function(data) {
            var roadAddr = data.roadAddress;
            var extra = '';
            if (data.bname && /[\uAC00-\uD7A3]+$/.test(data.bname)) extra += data.bname;
            if (data.buildingName && data.apartment === 'Y') extra += (extra? ', ' : '') + data.buildingName;
            if (extra) extra = ' (' + extra + ')';
            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById('addr').value = roadAddr + extra;
            document.getElementById('addr2').focus();
          }
        }).open();
      }
      
      $('#btnZipcode').click(findZipcode);
      
      // 수정하기 버튼
      $('#btnEdit').click(function(){
        ['email','phone1','phone2','phone3','zipcode','addr1','addr2'].forEach(function(name){
          var $f = $('[name="'+name+'"]');
          if($f.prop('readonly')){
            original[name] = $f.val();
            $f.prop('readonly', false);
          }
        });
        
        $('#btnZipcode').prop('disabled', false);
        $('#edit-buttons').addClass('d-none');
        $('#save-buttons').removeClass('d-none');
        $('#editIndicator').fadeIn().css('display', 'flex');
        
        // 첫 번째 수정 가능한 필드에 포커스
        $('[name="email"]').focus();
      });
      
      // 취소 버튼
      $('#btnCancel').click(function(){
        for(var k in original){
          $('[name="'+k+'"]')
            .val(original[k])
            .prop('readonly', true);
        }
        
        $('#btnZipcode').prop('disabled', true);
        $('#save-buttons').addClass('d-none');
        $('#edit-buttons').removeClass('d-none');
        $('#editIndicator').fadeOut();
      });
      
      // 폼 제출 시 확인
      $('#userForm').submit(function(e) {
        if (!confirm('정보를 수정하시겠습니까?')) {
          e.preventDefault();
        }
      });
      
      // 애니메이션 효과
      $('.info-card').each(function(index) {
        $(this).css('animation-delay', (index * 0.1) + 's');
      });
    
   // 비밀번호 변경 폼 처리
      $('#passwordForm').submit(function(e) {
        e.preventDefault();
        
        var currentPassword = $('[name="currentPassword"]').val();
        var newPassword = $('[name="newPassword"]').val();
        var confirmPassword = $('[name="confirmPassword"]').val();
        
        if (newPassword !== confirmPassword) {
          alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
          return;
        }
        
        
        if (confirm('비밀번호를 변경하시겠습니까?')) {
          $.ajax({
            url: 'change_password_process.jsp',
            type: 'POST',
            data: $(this).serialize(),
            success: function(response) {
            	  response = response.trim();
            	  if (response === 'success') {
            		  alert('비밀번호가 성공적으로 변경되었습니다.');

            		  // Bootstrap 5 네이티브 API 로 모달 인스턴스 가져오기 혹은 생성
            		  const modalEl = document.getElementById('passwordModal');
            		  const bsModal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            		  bsModal.hide();

            		  // 남아있는 backdrop(검은 레이어) 강제 제거
            		  document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());

            		  // 폼 초기화
            		  document.getElementById('passwordForm').reset();
            		} else if (response === 'invalid_password') {
            	    alert('현재 비밀번호가 올바르지 않습니다.');
            	  } else if (response === 'invalid_input') {
            	    alert('입력값이 잘못되었습니다.');
            	  } else if (response === 'user_not_found') {
            	    alert('사용자 정보를 찾을 수 없습니다.');
            	  } else if (response === 'same_as_current' ) {
            		  alert('현재 비밀번호와 다른 비밀번호를 입력해주세요.');
            	  }	else {
            	    alert('비밀번호 변경에 실패했습니다. 다시 시도해주세요.');
            	  }
            	}
,
            error: function() {
              alert('서버 오류가 발생했습니다. 다시 시도해주세요.');
            }
          });
        }
      });
      
      // 모달 닫힐 때 폼 초기화
      $('#passwordModal').on('hidden.bs.modal', function () {
        $('#passwordForm')[0].reset();
      });
    });
  </script>
</body>
</html>