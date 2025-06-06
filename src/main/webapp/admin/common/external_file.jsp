<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
    
   <!-- ✅ jQuery 먼저 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- ✅ Bootstrap CSS/JS (선택사항) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
  body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background-color: #f5f5f5;
  }

  .topbar {
    height: 60px;
    background-color: #ffffff;
    border-bottom: 1px solid #dee2e6;
    padding: 0 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .topbar h4 {
    margin: 0;
  }

  .sidebar {
    height: 100vh;
    background-color: #1f1f1f;
    color: #fff;
    padding-top: 20px;
    position: fixed;
    width: 220px;
  }

  .sidebar a {
    display: block;
    padding: 12px 20px;
    color: #ccc;
    text-decoration: none;
    font-size: 15px;
  }

  .sidebar a:hover {
    background-color: #343a40;
    color: white;
  }

  .main {
    margin-left: 220px;
    padding: 30px;
  }

  .card-box {
    border-radius: 10px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    text-align: center;
    padding: 20px;
    background-color: white;
    height: 100%;
  }

  .card-icon {
    font-size: 32px;
    margin-bottom: 10px;
    color: #007bff;
  }

  .card-title {
    font-size: 14px;
    color: #555;
  }

  .card-value {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 5px;
  }

  h3.section-title {
    margin-top: 40px;
  }
</style>
