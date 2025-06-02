<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService, order.OrderItemDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");
    int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));

    OrderService service = new OrderService();
    OrderItemDTO item = service.getOrderItemDetail(orderItemId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            font-size: 24px;
        }

        .star-rating input[type="radio"] {
            display: none;
        }

        .star-rating label {
            color: #ccc;
            cursor: pointer;
        }

        .star-rating input[type="radio"]:checked ~ label {
            color: gold;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: gold;
        }
    </style>
</head>
<body style="padding:20px;">

<h4>리뷰 작성</h4>

<div class="mb-3">
    <img src="/mall_prj/admin/common/upload/<%= item.getThumbnailUrl() %>" alt="상품 이미지"
         style="width:150px; height:150px; object-fit:cover; border-radius:8px;">
    <p class="mt-2 fw-bold"><%= item.getProductName() %></p>
</div>

<form action="review_submit.jsp" method="post" enctype="multipart/form-data">
    <input type="hidden" name="order_item_id" value="<%= item.getOrderItemId() %>">

    <div class="mb-3">
        <label class="form-label">평점</label>
        <div class="star-rating">
            <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
            <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
            <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
            <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
            <input type="radio" id="star1" name="rating" value="1"><label for="star1">★</label>
        </div>
    </div>

    <div class="mb-3">
        <label for="content" class="form-label">리뷰 내용</label>
        <textarea class="form-control" name="content" rows="4" required></textarea>
    </div>

    <div class="mb-3">
        <label for="image" class="form-label">이미지 첨부 (선택)</label>
        <input type="file" class="form-control" name="image" accept="image/*">
    </div>

    <button type="submit" class="btn btn-success">제출</button>
</form>

</body>
</html>
