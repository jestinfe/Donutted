<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService" %>

<%
request.setCharacterEncoding("UTF-8");

String userIdStr = request.getParameter("userId");
String title = request.getParameter("title");
String content = request.getParameter("content");

try {
    int userId = Integer.parseInt(userIdStr);

    InquiryDTO dto = new InquiryDTO();
    dto.setUserId(userId);
    dto.setTitle(title);
    dto.setContent(content);
    dto.setInquiryStatus("WAIT");


    InquiryService.getInstance().addInquiry(dto);

%>
    <script>
      alert("문의가 등록되었습니다.");
      location.href = "my_inquiry.jsp";
    </script>
<%
} catch (Exception e) {
    e.printStackTrace(); 
%>
    <script>
      alert("문의 등록 중 오류가 발생했습니다.");
      history.back();
    </script>
<%
}
%>
