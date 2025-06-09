 <%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/external_file.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Welcome to Donutted!!</title>
  
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  
  <style>
#container {
  background-color: white;
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  max-width: 800px;
  margin: 40px auto;
}

h2 {
  text-align: center;
  color: #ff6fa1;
  margin-bottom: 30px;
  font-weight: bold;
}

table {
  width: 100%;
  border-spacing: 15px;
}

th {
  text-align: left;
  color: #ff6fa1;
  font-weight: bold;
  vertical-align: top;
  padding-top: 10px;
  width: 150px;
}

.inputBox {
  border: 1px solid #ffb7d2;
  border-radius: 10px;
  padding: 10px;
  outline: none;
  transition: box-shadow 0.3s;
}

.inputBox:focus {
  box-shadow: 0 0 5px #ffa2cb;
}

.btnBox, input[type="button"], input[type="reset"] {
  background-color: #ffa2cb;
  color: white;
  border: none;
  padding: 10px 16px;
  border-radius: 10px;
  cursor: pointer;
  transition: background-color 0.2s;
  font-weight: bold;
}

.btnBox:hover, input[type="button"]:hover, input[type="reset"]:hover {
  background-color: #ff87bb;
}

select, input[type="radio"], input[type="checkbox"] {
  margin-top: 5px;
  accent-color: #ffa2cb;
}

input[type="radio"] + label, input[type="checkbox"] + label {
  margin-right: 10px;
  font-weight: normal;
}

iframe {
  border-radius: 15px;
  margin-bottom: 30px;
}

#btnConfirm, #btnCancel {
  width: 100px;
  margin: 10px 5px;
} /* 스타일변경 */

</style>

<script>
  function findZipcode() {
    new daum.Postcode({
      oncomplete: function(data) {
        var roadAddr = data.roadAddress;
        var extraRoadAddr = '';
        if (data.bname !== '' && /[\uAC00-\uD7A3]+[동|로|가]$/g.test(data.bname)) {
          extraRoadAddr += data.bname;
        }
        if (data.buildingName !== '' && data.apartment === 'Y') {
          extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
        }
        if (extraRoadAddr !== '') {
          extraRoadAddr = ' (' + extraRoadAddr + ')';
        }
        document.getElementById('zipcode').value = data.zonecode;
        document.getElementById("addr").value = roadAddr;
        document.getElementById("addr2").focus();
      }
    }).open();
  }

  var idChecked = false;

  function chkID() {
    const id = $('#id').val().trim();

    if (!id) {
      alert("아이디를 입력하세요.");
      return;
    }

    const idPattern = /^[A-Za-z]{1,10}$/;
    if (!idPattern.test(id)) {
      alert("아이디는 영문자만 사용하며, 최대 10자까지 가능합니다.");
      return;
    }

    window.open('id_dup.jsp?id=' + encodeURIComponent(id), 'idChk', 'width=512,height=313');
  }

  $(function() {
    $('#chkID').click(chkID);

    $('#id').on('input', function() {
      idChecked = false;
      $(this).removeAttr('readonly');
    });

    $('#chkPass').blur(function() {
      var pass = $('#pass').val();
      var chkPass = $('#chkPass').val();
      if (pass !== chkPass) {
        alert('비밀번호가 일치하지 않습니다.');
        $('#pass, #chkPass').val('').first().focus();
      }
    });

    $('#btnZipcode').click(findZipcode);

    $('#btnConfirm').off('click').on('click', function() {
    	  var fields = [
    	    { selector: '#id', label: '아이디' },
    	    { selector: '#pass', label: '비밀번호' },
    	    { selector: '#chkPass', label: '비밀번호 확인' },
    	    { selector: '[name="name"]', label: '이름' },
    	    { selector: '[name="birth"]', label: '생일' },
    	    { selector: '[name="tel"]', label: '휴대폰' },
    	    { selector: '[name="email"]', label: '이메일' },
    	    { selector: '[name="domain"]', label: '도메인' },
    	    { selector: '#zipcode', label: '우편번호' },
    	    { selector: '#addr', label: '주소' }
    	  ];

    	  console.log('전체 fields:', fields);

    	  for (var i = 0; i < fields.length; i++) {
    	    var field = fields[i];

    	    if (typeof field !== 'object' || field === null) {
    	      console.error('잘못된 field 발견 (index=' + i + '):', field);
    	      continue;
    	    }

    	    console.log('현재 field:', field);
    	    var val = $(field.selector).val();

    	    if (!val || val.trim() === '') {
    	      alert((field.label ? field.label : '(label 없음)') + "는 필수 입력입니다.\n(필드: " + (field.selector ? field.selector : '(selector 없음)') + ")");
    	      if (field.selector && !$(field.selector).prop('readonly')) {
    	        $(field.selector).focus();
    	      }
    	      return;
    	    }
    	  }
      
      if (!idChecked) {
        alert("아이디 중복확인을 해주세요.");
        return;
      }

      const birth = $('[name="birth"]').val().trim();
      const birthRegex = /^\d{4}-\d{2}-\d{2}$/;
      if (birth && birthRegex.test(birth)) {
        const birthYear = parseInt(birth.split('-')[0]);
        if (birthYear < 1920 || birthYear > 2025) {
          alert('생년월일은 1920년부터 2025년 사이여야 합니다.');
          $('[name="birth"]').focus();
          return;
        }
      } else if (birth) {
        alert('생년월일은 YYYY-MM-DD 형식으로 입력해주세요.');
        $('[name="birth"]').focus();
        return;
      }

      const tel = $('[name="tel"]').val().trim();
      const telPattern = /^010-\d{4}-\d{4}$/;
      if (!telPattern.test(tel)) {
        alert('휴대폰 번호는 010-1234-5678 형식으로 입력해주세요.');
        $('[name="tel"]').focus();
        return;
      }
      if (tel.replace(/\D/g, '').length < 11) {
        alert('휴대폰 번호는 숫자 11자리가 필요합니다.');
        $('[name="tel"]').focus();
        return;
      }

      const email = $('[name="email"]').val().trim();
      const emailRegex = /^[A-Za-z0-9]+$/;
      if (!emailRegex.test(email)) {
        alert('이메일 아이디는 영문자와 숫자만 입력 가능합니다.');
        $('[name="email"]').focus();
        return;
      }

      const domain = $('[name="domain"]').val().trim();
      const domainRegex = /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      if (!domainRegex.test(domain)) {
        alert('도메인은 올바른 형식(예: naver.com)으로 입력해주세요.');
        $('[name="domain"]').focus();
        return;
      }

      $('#frm').submit();
    });
  });
</script>


</head>
<body>
<c:import url="../common/header.jsp" />
<main>
  <div id="container">
    <h2>회원가입</h2>
    <iframe src="scrollbar.html" style="border: 0px; width: 100%; height: 200px"></iframe>

    <form action="member_process.jsp" name="frm" id="frm" method="post">
      <table>
<tr>
  <th>* 아이디</th>
  <td>
    <input type="text" name="id" id="id" class="inputBox" style="width:120px" maxlength="10"
  pattern="[A-Za-z]{1,10}" title="영문 10자까지 입력">

    <input type="button" value="ID중복확인" class="btnBox" id="chkID">
  </td>
</tr>

<tr>
  <th>* 비밀번호</th>
  <td>
    <input type="password" id="pass" name="pass" class="inputBox" style="width:200px" 
    maxlength="10" pattern="\d{1,10}" title="숫자 10자까지 입력">
    비밀번호 확인
    <input type="password" id="chkPass" name="chkPass" class="inputBox" style="width:200px" 
    maxlength="10" pattern="\d{1,10}">
  </td>
</tr>
        <tr>
          <th>* 이름</th>
          <td><input type="text" name="name" class="inputBox" 
          maxlength="7" style="width:150px"></td>
        </tr>
<tr>
  <th>생일</th>
  <td><input type="text" name="birth" class="inputBox" 
  maxlength="10" placeholder="1999-01-01"></td>
</tr>

<tr>
  <th>* 휴대폰</th>
  <td>
    <input type="text" name="tel" class="inputBox" placeholder="010-1234-5678" 
    maxlength="14" title="형식: 010-1234-5678">
  </td>
</tr>

<tr>
  <th>* 이메일</th>
  <td>
    <input type="text" name="email" class="inputBox" style="width:250px" 
    maxlength="15">@ 
    <input type="text" name="domain" class="inputBox" list="domainList" style="width:150px">
	<datalist id="domainList">
  		<option value="naver.com">
  		<option value="gmail.com">
  		<option value="daum.net">
  		<option value="nate.com">
  		<option value="hotmail.com">
</datalist>
  </td>
</tr>
        <tr>
          <th>* 성별</th>
          <td>
            <input type="radio" name="gender" value="M" checked><label>남자</label>
            <input type="radio" name="gender" value="F"><label>여자</label>
          </td>
        </tr>
        <tr>
          <th>* 우편번호</th>
          <td>
            <input type="text" name="zipcode" id="zipcode" readonly class="inputBox" style="width:60px">
            <input type="button" value="우편번호검색" id="btnZipcode">
          </td>
        </tr>
        <tr>
          <th>* 주소</th>
          <td>
            <input type="text" name="addr" id="addr" readonly class="inputBox" style="width:500px"><br>
            <input type="text" name="addr2" id="addr2" class="inputBox" 
            style="width:500px" maxlength="20">
          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <input type="button" value="확인" id="btnConfirm">
            <input type="reset" value="취소" id="btnCancel">
          </td>
        </tr>
      </table>
    </form>
  </div>
</main>
<c:import url="../common/footer.jsp" />
</body>
</html>
