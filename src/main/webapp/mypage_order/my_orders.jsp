<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/common/login_chk.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <c:import url="../common/external_file.jsp"/>
  <title>주문목록/배송조회 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
  
  <style>
    :root {
      --primary-pink: #f8bbd9;
      --primary-pink-light: #fdd7e4;
      --primary-pink-dark: #e2a2c7;
      --secondary-pink: #f5a6cd;
      --accent-rose: #f4c2c2;
      --accent-cream: #fef7f7;
      --background-cream: #fefafa;
      --text-pink: #8b4a6b;
      --text-soft: #a86b7a;
      --text-light: #c4859a;
      --border-pink: #f2d7dd;
      --shadow-pink: rgba(248, 187, 217, 0.15);
      --card-bg: linear-gradient(135deg, #ffffff 0%, #fef9fb 100%);
    }

    body { 
      font-family: 'Pretendard', sans-serif; 
      background: linear-gradient(135deg, var(--background-cream) 0%, #fef4f6 100%);
      margin: 0; 
      color: var(--text-pink);
    }

    .content-wrapper {
      margin-left: 240px;
      padding: 40px 20px;
      display: flex;
      justify-content: center;
    }

    .orders-container {
      width: 100%;
      max-width: 1000px;
    }

    h3 {
      font-weight: 700;
      margin-bottom: 30px;
      border-left: 5px solid var(--primary-pink);
      padding-left: 10px;
      color: var(--text-pink);
      position: relative;
    }

    h3::after {
      content: '📦';
      position: absolute;
      right: 0;
      top: 50%;
      transform: translateY(-50%);
      font-size: 1.5rem;
      opacity: 0.7;
    }

    .order-box {
      background: var(--card-bg);
      border: 2px solid var(--border-pink);
      border-radius: 20px;
      padding: 25px 30px;
      margin-bottom: 35px;
      box-shadow: 
        0 8px 32px var(--shadow-pink),
        0 2px 8px rgba(0, 0, 0, 0.05);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
    }

    .order-box::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--primary-pink), var(--secondary-pink), var(--accent-rose));
    }

    .order-box:hover {
      transform: translateY(-5px);
      box-shadow: 
        0 16px 48px var(--shadow-pink),
        0 4px 16px rgba(0, 0, 0, 0.1);
      border-color: var(--primary-pink-light);
    }

    .order-date { 
      font-weight: bold; 
      font-size: 16px; 
      margin-bottom: 15px; 
      color: var(--text-pink);
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .order-date::before {
      content: '📅';
      font-size: 1.1rem;
    }

    .order-status-bar {
      display: flex;
      justify-content: space-between;
      padding: 12px 18px;
      margin-bottom: 20px;
      background: linear-gradient(135deg, var(--accent-cream), #fdf0f2);
      border-radius: 15px;
      font-size: 15px;
      font-weight: 500;
      border: 1px solid var(--border-pink);
    }

    .order-status-bar span {
      flex: 1;
      text-align: center;
      color: var(--text-soft);
      padding: 8px 4px;
      border-radius: 10px;
      transition: all 0.3s ease;
    }

    .order-status-bar span.active {
      font-weight: bold;
      color: #fff;
      background: linear-gradient(135deg, var(--primary-pink), var(--secondary-pink));
      box-shadow: 0 4px 12px rgba(248, 187, 217, 0.3);
      transform: scale(1.05);
    }

    .product-list {
      display: flex;
      flex-wrap: wrap;
      gap: 25px;
      margin-bottom: 25px;
      padding: 20px;
      background: linear-gradient(135deg, var(--accent-cream), #fff);
      border-radius: 15px;
      border: 1px solid var(--border-pink);
    }

    .product-item {
      width: 120px;
      text-align: center;
      font-size: 14px;
      transition: transform 0.3s ease;
    }

    .product-item:hover {
      transform: translateY(-5px);
    }

    .product-item img {
      width: 110px;
      height: 110px;
      border-radius: 15px;
      object-fit: cover;
      box-shadow: 
        0 8px 25px rgba(248, 187, 217, 0.2),
        0 2px 10px rgba(0,0,0,0.05);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      border: 3px solid transparent;
    }

    .product-item img:hover { 
      transform: scale(1.05) rotate(1deg);
      border-color: var(--primary-pink-light);
      box-shadow: 
        0 12px 35px rgba(248, 187, 217, 0.3),
        0 4px 15px rgba(0,0,0,0.1);
    }

    .text-end { 
      text-align: right; 
      padding: 20px 0;
      border-top: 2px dashed var(--border-pink);
      margin-top: 20px;
    }

    .btn-review {
      background: linear-gradient(135deg, var(--primary-pink), var(--secondary-pink));
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 25px;
      margin-right: 10px;
      font-weight: 600;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 15px rgba(248, 187, 217, 0.4);
    }

    .btn-refund {
      background: linear-gradient(135deg, var(--accent-rose), #f2b3c4);
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 25px;
      font-weight: 600;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 15px rgba(244, 194, 194, 0.4);
    }

    .btn-review:hover { 
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(248, 187, 217, 0.5);
      background: linear-gradient(135deg, var(--secondary-pink), var(--primary-pink));
    }

    .btn-refund:hover { 
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(244, 194, 194, 0.5);
      background: linear-gradient(135deg, #f2b3c4, var(--accent-rose));
    }

    .alert-box {
      background: linear-gradient(135deg, var(--accent-cream), #fff2e6);
      padding: 20px 25px;
      border-left: 4px solid var(--primary-pink);
      margin-bottom: 30px;
      color: var(--text-soft);
      border-radius: 12px;
      border: 1px solid var(--border-pink);
      position: relative;
    }

    .alert-box::before {
      content: '💡';
      position: absolute;
      top: 20px;
      right: 20px;
      font-size: 1.5rem;
      opacity: 0.7;
    }

    .text-danger { 
      color: #e28ba8; 
      font-weight: bold; 
    }

    #loading {
      text-align: center;
      padding: 20px;
      color: var(--text-soft);
      font-size: 1.1rem;
      display: none;
    }

    /* 로딩 애니메이션 */
    .loading-spinner {
      display: inline-block;
      width: 20px;
      height: 20px;
      border: 2px solid var(--border-pink);
      border-radius: 50%;
      border-top-color: var(--primary-pink);
      animation: spin 1s ease-in-out infinite;
      margin-right: 10px;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    /* 페이드인 애니메이션 */
    .order-box {
      opacity: 0;
      transform: translateY(20px);
      animation: fadeInUp 0.6s ease-out forwards;
    }

    @keyframes fadeInUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media (max-width: 768px) {
      .content-wrapper {
        margin-left: 0;
        padding: 30px 16px;
      }

      .orders-container {
        max-width: 100%;
      }

      .order-box {
        padding: 20px;
        margin-bottom: 25px;
      }

      .order-status-bar { 
        flex-direction: column; 
        gap: 8px; 
        padding: 15px;
      }
      
      .order-status-bar span {
        text-align: center;
        padding: 10px;
      }
      
      .product-list { 
        justify-content: center; 
        gap: 15px;
        padding: 15px;
      }
      
      .product-item { 
        width: 45%; 
        max-width: 100px;
      }
      
      .product-item img {
        width: 90px;
        height: 90px;
      }
      
      .text-end { 
        text-align: center; 
        padding: 15px 0;
      }
      
      .btn-review, .btn-refund { 
        margin: 5px; 
        padding: 8px 16px;
        font-size: 0.9rem;
      }

      h3 {
        font-size: 1.8rem;
        margin-bottom: 25px;
      }
    }

    /* 스크롤바 스타일링 */
    ::-webkit-scrollbar {
      width: 8px;
    }

    ::-webkit-scrollbar-track {
      background: var(--accent-cream);
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb {
      background: var(--primary-pink-light);
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: var(--primary-pink);
    }
  </style>
</head>
<body>
  <c:import url="/common/header.jsp" />
  <c:import url="/common/mypage_sidebar.jsp" />
<%
  request.setCharacterEncoding("UTF-8");
  if (session.getAttribute("userId") == null) {
    response.sendRedirect("/mall_prj/UserLogin/login.jsp");
    return;
  }
  Integer userId = (Integer) session.getAttribute("userId");
%>

  <div class="content-wrapper">
    <div class="orders-container">
      <h3>주문배송 조회</h3>
      <div id="orderList"></div>
      <div id="loading" style="display: none;">
        <div class="loading-spinner"></div>
        주문 정보를 불러오는 중...
      </div>
    </div>
  </div>

  <c:import url="/common/footer.jsp" />

  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script>
    let page = 1;
    let loading = false;
    const limit = 10;
    let endOfData = false;

    function loadMoreOrders() {
      if (loading || endOfData) return;
      loading = true;
      $('#loading').show();

      $.ajax({
        url: 'order_list_ajax.jsp',
        type: 'GET',
        data: {
          userId: '<%= userId %>',
          page: page,
          limit: limit
        },
        success: function (html) {
          const trimmed = $.trim(html);
          if (trimmed !== '') {
            $('#orderList').append(html);
            
            // 새로 추가된 요소들에 애니메이션 적용
            $('#orderList .order-box').each(function(index) {
              $(this).css('animation-delay', `${index * 0.1}s`);
            });
            
            if ($(html).find('#no-more-orders').length > 0) {
              endOfData = true;
              $('#loading').html('<div style="color: var(--text-soft); font-size: 1.1rem;">📦 모든 주문을 확인했습니다</div>').show();
            } else {
              page++;
              $('#loading').hide();
            }
          } else {
            endOfData = true;
            $('#loading').html('<div style="color: var(--text-soft); font-size: 1.1rem;">📦 모든 주문을 확인했습니다</div>').show();
          }
          loading = false;
        },
        error: function () {
          $('#loading').hide();
          loading = false;
          alert('주문 데이터를 불러오는 중 오류가 발생했습니다.');
        }
      });
    }

    $(window).scroll(function () {
      if ($(window).scrollTop() + $(window).height() >= $(document).height() - 150) {
        loadMoreOrders();
      }
    });

    $(document).ready(function () {
      loadMoreOrders();
    });

    // 버튼 클릭 효과
    $(document).on('click', '.btn-review, .btn-refund', function() {
      $(this).css('transform', 'scale(0.95)');
      setTimeout(() => {
        $(this).css('transform', '');
      }, 200);
    });
  </script>
</body>
</html>