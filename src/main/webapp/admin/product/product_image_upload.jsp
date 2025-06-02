<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
JSONObject jsonObj = new JSONObject();
boolean resultFlag = false;
String fileName = "";
String error = "";

// ✅ Git 프로젝트 내부 webapp 경로로 직접 지정 (Tomcat 배포 경로가 아닌 원본 경로)
String savePath = "C:/Users/user/git/mall_prj/mall_prj/src/main/webapp/admin/common/upload";
File saveDir = new File(savePath);

// 디렉토리 없으면 생성
if (!saveDir.exists()) {
    saveDir.mkdirs();
}

// 파일 크기 제한 (20MB)
int maxSize = 20 * 1024 * 1024;

try {
    MultipartRequest mr = new MultipartRequest(
        request,
        saveDir.getAbsolutePath(), // 저장 경로
        maxSize,
        "UTF-8",  // 한글 파일명 대응
        new DefaultFileRenamePolicy()  // 중복 파일명 자동 변경
    );

    File file = mr.getFile("productImg");
    if (file != null) {
        fileName = mr.getFilesystemName("productImg");

        // ✅ 확장자 검증 (보안 및 제한)
        String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        if (!ext.matches("jpg|jpeg|png|gif|webp")) {
            file.delete(); // 삭제
            error = "허용되지 않은 확장자입니다.";
        } else {
            resultFlag = true;
        }
    } else {
        error = "파일이 전달되지 않았습니다.";
    }

} catch (Exception e) {
    error = "업로드 오류: " + e.getMessage();
}

// ✅ 클라이언트(AJAX)에게 JSON 응답 반환
jsonObj.put("resultFlag", resultFlag);
jsonObj.put("fileName", fileName);
jsonObj.put("error", error);

out.print(jsonObj.toJSONString());
%>
