# 🛍️ Donutted - JSP 기반 온라인 쇼핑몰

![logo](https://github.com/user-attachments/assets/5acd9fdf-7c58-496e-a42c-b48220a907c9)

<br/>

## 📑 목차  
- [📝 프로젝트 소개](#-프로젝트-소개)
- [🛠 기술 스택](#-기술-스택)
- [💾 ERD](#-erd)
- [✨ 주요 기능 소개](#-주요-기능-소개)  
- [🎬 시연영상](#-시연영상)   
- [💁‍♂️ 팀원 소개](#-팀원-소개)  

<br/>

## 📝 프로젝트 소개
기존 오프라인/문서 기반 상품 판매 방식의 문제점을 해결하고자 개발한 통합 온라인 쇼핑몰 플랫폼입니다.
고객은 다양한 상품을 검색하고 구매할 수 있으며, 관리자는 상품 및 주문을 효율적으로 관리할 수 있습니다.
실시간 주문 처리, 결제 시스템, 리뷰 관리 등 실제 쇼핑몰의 핵심 기능들을 구현하여 완전한 전자상거래 경험을 제공합니다.

**Donutted**는 JSP와 Oracle을 기반으로 구축된 풀스택 전자상거래 플랫폼입니다. 8명의 개발팀이 6주간 협업하여 개발했으며, 사용자와 관리자를 위한 완전한 온라인 쇼핑 경험을 제공합니다.

- **개발 기간**: 2025.04.01 ~ 2025.05.14 (6주)
- **팀 구성**: 8명 
- **아키텍처**: Model1 패턴 기반 웹 애플리케이션

<br/>

## 🛠 기술 스택

### Backend
- **Language**: Java (JDK 11)
- **Framework**: JSP/Servlet
- **Database**: Oracle Database
- **Connection Pool**: DBCP
- **Server**: Apache Tomcat 9

### Frontend
- **Markup**: HTML5, CSS3
- **Template**: JSP, JSTL, EL
- **Scripting**: JavaScript, jQuery
- **Framework**: Bootstrap

### Development Environment
- **IDE**: Eclipse IDE
- **OS**: Windows 10
- **Version Control**: Git

<img src="https://img.shields.io/badge/java-007396?style=for-the-badge&logo=java&logoColor=white"> <img src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white"> <img src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white"> <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"> <img src="https://img.shields.io/badge/jquery-0769AD?style=for-the-badge&logo=jquery&logoColor=white"> <img src="https://img.shields.io/badge/bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white"> <img src="https://img.shields.io/badge/oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white"> <img src="https://img.shields.io/badge/apache tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=white"> <img src="https://img.shields.io/badge/eclipse-2C2255?style=for-the-badge&logo=eclipseide&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white">

<br/>

## 💾 ERD
![4조_erd](https://github.com/user-attachments/assets/dbdf5438-88ba-4158-a790-dc0375807b6d)

<br/>

## ✨ 주요 기능 소개

### 👥 사용자 기능
- 🛒 상품 검색 및 상세 정보 확인
- 📦 장바구니 관리 및 주문 처리
- 💳 실시간 주문 상태 추적
- ⭐ 리뷰 시스템 (작성/수정/삭제)
- 👤 개인정보 관리 및 주문 이력
- 🔄 주문 취소 및 환불 요청

### 👨‍💼 관리자 기능
- 📊 실시간 대시보드 (매출, 주문, 배송 현황)
- 👤 회원 관리 (가입/탈퇴/정보 수정)
- 📦 주문 관리 (상태 변경, 배송 처리)
- 📝 리뷰 관리 및 모니터링
- 💰 환불 승인/거부 처리
- 📈 매출 분석 및 통계
- 💬 FAQ/1대1문의 관리
- 📢 공지사항/이벤트 관리

<br/>

## 🎬 시연영상
[![Video Label](http://img.youtube.com/vi/thmKeS74tDw/0.jpg)](https://youtu.be/thmKeS74tDw)

<br/>

## 💁‍♂️ 팀원 소개
- **김민진** [팀장]<br/>
  ✔ 사용자 : 메인화면, 로그인, 회원가입, 아이디/비밀번호 찾기<br/>
  ✔ 관리자 : 회원 관리<br/>
  
- **김세형** [부팀장/DBA]<br/>
  ✔ 개발 환경 및 디렉터리 구조 설계<br/>
  ✔ Oracle DB 설계 및 구축<br/>
  ✔ 사용자 : 주문 시스템, 환불 요청, 리뷰 기능, 마이페이지 내정보 수정/탈퇴<br/>
  ✔ 관리자 : 주문 관리, 환불 관리, 회원관리, 리뷰관리, 대시보드<br/>
  
- **박선은**<br/>
  ✔ 사용자 : 공지사항, 이벤트 조회<br/>
  ✔ 관리자 : 공지사항 관리, 이벤트 관리<br/>
  
- **심규민**<br/>
  ✔ 사용자 : 찜하기, 장바구니<br/>
  
- **이장훈**<br/>
  ✔ 사용자 : 메인화면, 주문 시스템<br/>
  ✔ 관리자 : 주문관리<br/>
  
- **정성재**<br/>
  ✔ 사용자 : 공통 레이아웃, 상품 목록, 상품 상세, 리뷰 기능<br/>
  ✔ 관리자 : 상품관리, 리뷰관리<br/>
  
- **정제균**<br/>
  ✔ 사용자 : 브랜드 소개, 리뷰 기능<br/>
  ✔ 관리자 : 리뷰 관리<br/>
  
- **최승재**<br/>
  ✔ 사용자 : 1대1 문의하기, FAQ 조회<br/>
  ✔ 관리자 : 1대1 문의 관리, FAQ 관리<br/>

<br/>

---

**© 2025 Donutted Project Team. 본 프로젝트는 교육 목적으로 개발되었습니다.**

> 🙋 README 작성: 김세형
