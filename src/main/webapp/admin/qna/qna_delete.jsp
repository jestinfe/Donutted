<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryService" %>

<%
String idParam = request.getParameter("inquiry_id");

if (idParam == null) {
%>
  <script>
    alert("잘못된 요청입니다.");
    history.back();
  </script>
<%
  return;
}

int inquiryId = Integer.parseInt(idParam);

try {
    InquiryService.getInstance().deleteInquiry(inquiryId);
%>
  <script>
    alert("해당 문의가 삭제되었습니다.");
    location.href = "qna_list.jsp";
  </script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
  <script>
    alert("삭제 중 오류가 발생했습니다.");
    history.back();
  </script>
<%
}
%>
