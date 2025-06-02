<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryService" %>

<%
request.setCharacterEncoding("UTF-8");

String idParam = request.getParameter("inquiry_id");
String replyContent = request.getParameter("reply_content");

if (idParam == null || replyContent == null || replyContent.trim().equals("")) {
%>
  <script>
    alert("답변 내용을 입력해 주세요.");
    history.back();
  </script>
<%
  return;
}

int inquiryId = Integer.parseInt(idParam);

try {
    InquiryService.getInstance().updateReply(inquiryId, replyContent.trim());
%>
  <script>
    alert("답변이 등록되었습니다.");
    location.href = "qna_list.jsp";
  </script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
  <script>
    alert("답변 등록 중 오류가 발생했습니다.");
    history.back();
  </script>
<%
}
%>
<%
System.out.println(">>>> DEBUG inquiry_id = " + inquiryId);
System.out.println(">>>> DEBUG reply_content = " + replyContent);
%>


