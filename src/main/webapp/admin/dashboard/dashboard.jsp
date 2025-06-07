<%@ page import="dashboard.DashBoardService" %>
<%@ page import="dashboard.DailySummaryDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<head>
  <title>대시보드</title>
</head>
<style>
  .main {
    background-color: #f8f9fa;
    min-height: 100vh;
    padding: 20px;
  }

  .dashboard-title {
    color: #2c3e50;
    font-weight: 600;
    margin-bottom: 30px;
    padding-bottom: 15px;
    border-bottom: 3px solid #3498db;
    display: inline-block;
  }

  .section-title {
    color: #34495e;
    font-weight: 500;
    margin: 30px 0 20px 0;
    font-size: 1.2rem;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .chart-container {
    background: white;
    border-radius: 12px;
    padding: 25px;
    margin: 20px 0 30px 0;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    border: 1px solid #e9ecef;
  }

  .card-box {
    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
    border: 1px solid #e9ecef;
    border-radius: 12px;
    height: 140px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }

  .card-box:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.12);
  }

  .card-box::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #3498db, #2980b9);
  }

  .card-value {
    font-size: 2rem;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 8px;
    line-height: 1.2;
  }

  .card-title {
    font-size: 0.9rem;
    color: #7f8c8d;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  /* 매출 카드 스타일링 */
  .revenue-card .card-box::before {
    background: linear-gradient(90deg, #27ae60, #2ecc71);
  }

  .revenue-card .card-value {
    color: #27ae60;
  }

  /* 배송 카드 스타일링 */
  .shipping-card:nth-child(1) .card-box::before {
    background: linear-gradient(90deg, #f39c12, #e67e22);
  }

  .shipping-card:nth-child(2) .card-box::before {
    background: linear-gradient(90deg, #3498db, #2980b9);
  }

  .shipping-card:nth-child(3) .card-box::before {
    background: linear-gradient(90deg, #27ae60, #2ecc71);
  }

  /* 환불/취소 카드 스타일링 */
  .refund-card:nth-child(1) .card-box::before {
    background: linear-gradient(90deg, #95a5a6, #7f8c8d);
  }

  .refund-card:nth-child(2) .card-box::before {
    background: linear-gradient(90deg, #f39c12, #e67e22);
  }

  .refund-card:nth-child(3) .card-box::before {
    background: linear-gradient(90deg, #27ae60, #2ecc71);
  }

  .refund-card:nth-child(4) .card-box::before {
    background: linear-gradient(90deg, #e74c3c, #c0392b);
  }

  .refund-card:nth-child(5) .card-box::before {
    background: linear-gradient(90deg, #9b59b6, #8e44ad);
  }

  /* 반응형 디자인 */
  @media (max-width: 768px) {
    .main {
      padding: 15px;
    }
    
    .card-box {
      height: 120px;
      padding: 15px;
    }
    
    .card-value {
      font-size: 1.6rem;
    }
    
    .card-title {
      font-size: 0.8rem;
    }
  }

  /* 5개 카드 전체 너비 분산 정렬을 위한 컨테이너 */
  .refund-container {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 15px;
  }

  .refund-container .col-md-2 {
    flex: 1;
    min-width: 0;
    max-width: calc(20% - 12px);
  }

  @media (max-width: 992px) {
    .refund-container {
      justify-content: center;
    }
    
    .refund-container .col-md-2 {
      flex: 0 0 48%;
      max-width: 48%;
    }
  }

  @media (max-width: 576px) {
    .refund-container .col-md-2 {
      flex: 0 0 100%;
      max-width: 100%;
    }
  }
</style>

<%
  String adminId = (String) session.getAttribute("adminId");

  DashBoardService service = new DashBoardService();
  java.util.List<DailySummaryDTO> summaryList = service.getRecentDailySummary();
  if (summaryList == null) {
      out.println("⚠️ 관리자 통계 데이터를 불러오지 못했습니다.");
      return;
  }
  summaryList.sort(java.util.Comparator.comparing(DailySummaryDTO::getStatDate));

  StringBuilder labels = new StringBuilder();
  StringBuilder salesData = new StringBuilder();
  StringBuilder ordersData = new StringBuilder();

  for (int i = 0; i < summaryList.size(); i++) {
      DailySummaryDTO dto = summaryList.get(i);
      String label = dto.getStatDate().toString();
      labels.append("'").append(label).append("'").append(i < summaryList.size() - 1 ? ", " : "");
      salesData.append(dto.getTotalSales()).append(i < summaryList.size() - 1 ? ", " : "");
      ordersData.append(dto.getTotalOrders()).append(i < summaryList.size() - 1 ? ", " : "");
  }

  java.time.LocalDate today = java.time.LocalDate.now();
  DailySummaryDTO todayData = summaryList.stream()
      .filter(d -> d.getStatDate().toLocalDate().equals(today))
      .findFirst()
      .orElse(new DailySummaryDTO());

  java.util.Map<String, Integer> summaryMap = service.getWeeklyMonthlySummary();
  int weeklySales = summaryMap.getOrDefault("weekly_sales", 0);
  int monthlySales = summaryMap.getOrDefault("monthly_sales", 0);
  int weeklyOrders = summaryMap.getOrDefault("weekly_orders", 0);
  int monthlyOrders = summaryMap.getOrDefault("monthly_orders", 0);
%>

<div class="main">
  <h2 class="dashboard-title">📊 관리자 대시보드</h2>

  <!-- 📈 매출 및 구매건수 그래프 -->
  <div class="chart-container">
    <h4 style="color: #2c3e50; margin-bottom: 20px; font-weight: 500;">📈 매출 및 주문 현황</h4>
    <canvas id="salesChart" height="100"></canvas>
  </div>

  <script>
    const ctx = document.getElementById('salesChart').getContext('2d');
    const chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: [<%= labels.toString() %>],
        datasets: [
          {
            type: 'bar',
            label: '매출액 (원)',
            data: [<%= salesData.toString() %>],
            backgroundColor: 'rgba(52, 152, 219, 0.6)',
            borderColor: 'rgba(52, 152, 219, 1)',
            borderWidth: 2,
            borderRadius: 4,
            yAxisID: 'y'
          },
          {
            type: 'line',
            label: '구매건수',
            data: [<%= ordersData.toString() %>],
            borderColor: 'rgba(231, 76, 60, 1)',
            backgroundColor: 'rgba(231, 76, 60, 0.1)',
            borderWidth: 3,
            pointBackgroundColor: 'rgba(231, 76, 60, 1)',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 5,
            pointHoverRadius: 8,
            fill: false,
            tension: 0.4,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        stacked: false,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              usePointStyle: true,
              padding: 20,
              font: { size: 12, weight: '500' }
            }
          },
          tooltip: {
            backgroundColor: 'rgba(0,0,0,0.8)',
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: 'rgba(255,255,255,0.1)',
            borderWidth: 1,
            cornerRadius: 8,
            callbacks: {
              title: function(context) {
                return '📅 ' + context[0].label;
              },
              label: function(context) {
                const label = context.dataset.label || '';
                const value = context.raw ?? 0;
                return label === '매출액 (원)'
                  ? label + ': ₩' + Number(value).toLocaleString()
                  : label + ': ' + Number(value).toLocaleString() + '건';
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            title: { 
              display: true, 
              text: '매출액 (원)',
              font: { weight: '500' }
            },
            ticks: {
              callback: function(value) {
                return value.toLocaleString() + '원';
              }
            },
            grid: {
              color: 'rgba(0,0,0,0.05)'
            }
          },
          y1: {
            beginAtZero: true,
            position: 'right',
            title: { 
              display: true, 
              text: '구매건수',
              font: { weight: '500' }
            },
            grid: { drawOnChartArea: false }
          },
          x: {
            grid: {
              color: 'rgba(0,0,0,0.05)'
            }
          }
        }
      }
    });
  </script>

  <!-- 📦 주문 건수 -->
  <h3 class="section-title">📦 주문 건수</h3>
  <div class="row">
    <div class="col-md-4 mb-3">
      <div class="card-box">
        <div class="card-value"><%= todayData.getTotalOrders() %>건</div>
        <div class="card-title">오늘</div>
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <div class="card-box">
        <div class="card-value"><%= weeklyOrders %>건</div>
        <div class="card-title">이번 주</div>
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <div class="card-box">
        <div class="card-value"><%= monthlyOrders %>건</div>
        <div class="card-title">이번 달</div>
      </div>
    </div>
  </div>

  <!-- 💰 매출 -->
  <h3 class="section-title">💰 매출 현황</h3>
  <div class="row revenue-card">
    <div class="col-md-6 mb-3">
      <div class="card-box">
        <div class="card-value">₩<%= String.format("%,d", todayData.getTotalSales()) %></div>
        <div class="card-title">총매출 (오늘)</div>
      </div>
    </div>
    <div class="col-md-6 mb-3">
      <div class="card-box">
        <div class="card-value">₩<%= String.format("%,d", todayData.getNetSales()) %></div>
        <div class="card-title">순매출 (환불 + 취소 차감)</div>
      </div>
    </div>
  </div>

  <!-- 🚚 배송 현황 -->
  <h3 class="section-title">🚚 오늘 배송 현황</h3>
  <div class="row">
    <div class="col-md-4 mb-3 shipping-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getBeforeShipping() %>건</div>
        <div class="card-title">배송 준비 중</div>
      </div>
    </div>
    <div class="col-md-4 mb-3 shipping-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getShipping() %>건</div>
        <div class="card-title">배송 중</div>
      </div>
    </div>
    <div class="col-md-4 mb-3 shipping-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getShippingDone() %>건</div>
        <div class="card-title">배송 완료</div>
      </div>
    </div>
  </div>

  <!-- 🔁 환불/취소 현황 -->
  <h3 class="section-title">🔁 환불 / 취소 현황</h3>
  <div class="refund-container">
    <div class="col-md-2 mb-3 refund-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getRefundRequested() + todayData.getRefundApproved() + todayData.getRefundRejected() %>건</div>
        <div class="card-title">전체 환불 요청</div>
      </div>
    </div>
    <div class="col-md-2 mb-3 refund-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getRefundRequested() %>건</div>
        <div class="card-title">승인 대기</div>
      </div>
    </div>
    <div class="col-md-2 mb-3 refund-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getRefundApproved() %>건</div>
        <div class="card-title">승인 완료</div>
      </div>
    </div>
    <div class="col-md-2 mb-3 refund-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getRefundRejected() %>건</div>
        <div class="card-title">반려</div>
      </div>
    </div>
    <div class="col-md-2 mb-3 refund-card">
      <div class="card-box">
        <div class="card-value"><%= todayData.getOrderCanceled() %>건</div>
        <div class="card-title">주문 취소</div>
      </div>
    </div>
  </div>
</div>