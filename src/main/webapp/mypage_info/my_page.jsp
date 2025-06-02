<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%@ page import="java.util.*" %>
<%
  request.setCharacterEncoding("UTF-8");
  Integer userId = (Integer) session.getAttribute("userId");
  if (userId == null) {
    response.sendRedirect("/login.jsp");
    return;
  }
  UserService service = new UserService();
  UserDTO user = service.getUserById(userId);
  if (user == null) {
    response.sendRedirect("/login.jsp");
    return;
  }
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
  <title>마이페이지 - 내 정보</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet"/>
  <style>
    body { font-family:'Pretendard',sans-serif; background:#f8f9fa; }
    .form-label { font-weight:bold; }
    .btn-pink { background:#ef84a5; color:#fff; border:none; }
    .btn-pink:hover { background:#e26c93; }
    .mypage-form {
      background:#fff; padding:30px; border-radius:10px;
      box-shadow:0 0 10px rgba(0,0,0,0.05);
      max-width:700px; margin:auto;
    }
    .form-phone-group { display:flex; gap:10px; }
    input[readonly], select[disabled] {
      background:#e9ecef!important; cursor:not-allowed;
    }
  </style>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script>
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
    document.addEventListener('DOMContentLoaded', function(){
      document.getElementById('btnZipcode').addEventListener('click', findZipcode);
    });
  </script>
</head>
<body>

  <c:import url="/common/header.jsp"/>
  <c:import url="/common/mypage_sidebar.jsp"/>

  <div class="container my-5" style="padding-left:220px;">
    <div class="mypage-form">
      <form id="userForm" action="user_update_ok.jsp" method="post">
        <input type="hidden" name="user_id" value="${user.userId}"/>

        <!-- 읽기 전용 -->
        <div class="mb-3">
          <label class="form-label">이름</label>
          <input class="form-control" value="${user.name}" readonly>
        </div>
        <div class="mb-3">
          <label class="form-label">아이디</label>
          <input class="form-control" value="${user.username}" readonly>
        </div>
        <div class="mb-3">
          <label class="form-label">생년월일</label>
          <input type="date" class="form-control"
                 value="${user.birthdate}" readonly>
        </div>
        <div class="mb-3">
          <label class="form-label">성별</label>
          <select class="form-control" disabled>
            <option value="M" ${user.gender=='M'?'selected':''}>남성</option>
            <option value="F" ${user.gender=='F'?'selected':''}>여성</option>
          </select>
        </div>

        <!-- 수정 가능 -->
        <div class="mb-3">
          <label class="form-label">이메일</label>
          <input type="email" name="email" class="form-control"
                 value="${user.email}" readonly>
        </div>
        <div class="mb-3">
          <label class="form-label">연락처</label>
          <div class="form-phone-group">
            <input type="text" name="phone1" maxlength="3" class="form-control"
                   value="${phoneParts[0]}" readonly>
            <input type="text" name="phone2" maxlength="4" class="form-control"
                   value="${phoneParts[1]}" readonly>
            <input type="text" name="phone3" maxlength="4" class="form-control"
                   value="${phoneParts[2]}" readonly>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label">우편번호</label>
          <div class="d-flex gap-2">
            <input type="text" name="zipcode" id="zipcode" class="form-control"
                   value="${user.zipcode}" readonly style="max-width:120px;">
            <button type="button" id="btnZipcode"
                    class="btn btn-outline-secondary btn-sm" disabled>
              우편번호 검색
            </button>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label">주소</label>
          <input type="text" name="addr1" id="addr" class="form-control mb-2"
                 value="${user.address1}" readonly>
          <input type="text" name="addr2" id="addr2" class="form-control"
                 value="${user.address2}" readonly>
        </div>

        <!-- 버튼 토글 -->
        <div class="text-center" id="edit-buttons">
          <button type="button" id="btnEdit" class="btn btn-pink px-5">
            수정하기
          </button>
        </div>
        <div class="text-center d-none" id="save-buttons">
          <button type="submit" class="btn btn-pink px-5">확인</button>
          <button type="button" id="btnCancel" class="btn btn-secondary px-5">
            취소
          </button>
        </div>
      </form>

      <div class="text-end mt-3">
        <a href="change_password.jsp"
           class="btn btn-outline-secondary btn-sm">비밀번호 변경</a>
      </div>
    </div>
  </div>

  <c:import url="/common/footer.jsp"/>

  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script>
    $(function(){
      var original = {};
      // 수정하기
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
      });
      // 취소
      $('#btnCancel').click(function(){
        for(var k in original){
          $('[name="'+k+'"]')
            .val(original[k])
            .prop('readonly', true);
        }
        $('#btnZipcode').prop('disabled', true);
        $('#save-buttons').addClass('d-none');
        $('#edit-buttons').removeClass('d-none');
      });
    });
  </script>

</body>
</html>
