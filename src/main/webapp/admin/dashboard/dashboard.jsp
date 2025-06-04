<%@ page import="dashboard.DashBoardService" %>
<%@ page import="dashboard.DailySummaryDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

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
  <h3>📊 관리자 대시보드</h3>

  <!-- 📈 매출 및 구매건수 그래프 -->
  <canvas id="salesChart" height="100"></canvas>
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
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1,
            yAxisID: 'y'
          },
          {
            type: 'line',
            label: '구매건수',
            data: [<%= ordersData.toString() %>],
            borderColor: 'rgba(255, 99, 132, 1)',
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            borderWidth: 2,
            pointBackgroundColor: 'rgba(255, 99, 132, 1)',
            pointRadius: 4,
            pointHoverRadius: 6,
            fill: false,
            tension: 0.3,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        responsive: true,
        interaction: { mode: 'index', intersect: false },
        stacked: false,
        scales: {
          y: {
            beginAtZero: true,
            title: { display: true, text: '매출액 (원)' },
            ticks: {
              callback: function(value) {
                return value.toLocaleString() + '원';
              }
            }
          },
          y1: {
            beginAtZero: true,
            position: 'right',
            title: { display: true, text: '구매건수' },
            grid: { drawOnChartArea: false }
          }
        },
        plugins: {
          tooltip: {
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
        }
      }
    });
  </script>

  <!-- 📦 주문 건수 -->
  <h3 class="section-title mt-5">📦 주문 건수</h3>
  <div class="row">
    <div class="col-md-3 mb-3">
      <div class="card-box bg-body-tertiary">
        <div class="card-value"><%= todayData.getTotalOrders() %>건</div>
        <div class="card-title">오늘</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-body-tertiary">
        <div class="card-value"><%= weeklyOrders %>건</div>
        <div class="card-title">이번 주</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-body-tertiary">
        <div class="card-value"><%= monthlyOrders %>건</div>
        <div class="card-title">이번 달</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-danger-subtle text-dark">
        <div class="card-value"><%= todayData.getOrderCanceled() %>건</div>
        <div class="card-title">주문 취소</div>
      </div>
    </div>
  </div>

  <!-- 💰 매출 -->
  <h3 class="section-title">💰 매출 현황</h3>
  <div class="row">
    <div class="col-md-6 mb-3">
      <div class="card-box bg-success-subtle text-dark">
        <div class="card-value">₩<%= String.format("%,d", todayData.getTotalSales()) %></div>
        <div class="card-title">총매출 (오늘)</div>
      </div>
    </div>
    <div class="col-md-6 mb-3">
      <div class="card-box bg-info-subtle text-dark">
        <div class="card-value">₩<%= String.format("%,d", todayData.getNetSales()) %></div>
        <div class="card-title">순매출 (환불 차감)</div>
      </div>
    </div>
  </div>

  <!-- 🚚 배송 현황 -->
  <h3 class="section-title">🚚 오늘 배송 현황</h3>
  <div class="row">
    <div class="col-md-3 mb-3">
      <div class="card-box bg-warning-subtle text-dark">
        <div class="card-value"><%= todayData.getOrderCompleted() %>건</div>
        <div class="card-title">주문 완료</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-secondary-subtle text-dark">
        <div class="card-value"><%= todayData.getBeforeShipping() %>건</div>
        <div class="card-title">배송 준비 중</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-info-subtle text-dark">
        <div class="card-value"><%= todayData.getShipping() %>건</div>
        <div class="card-title">배송 중</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-primary-subtle text-dark">
        <div class="card-value"><%= todayData.getShippingDone() %>건</div>
        <div class="card-title">배송 완료</div>
      </div>
    </div>
  </div>

  <!-- 🔁 환불 현황 -->
  <h3 class="section-title">🔁 오늘 환불 현황</h3>
  <div class="row">
    <div class="col-md-3 mb-3">
      <div class="card-box bg-body-tertiary">
        <div class="card-value"><%= todayData.getRefundRequested() + todayData.getRefundApproved() + todayData.getRefundRejected() %>건</div>
        <div class="card-title">전체 요청 수</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-warning-subtle text-dark">
        <div class="card-value"><%= todayData.getRefundRequested() %>건</div>
        <div class="card-title">승인 대기</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-success-subtle text-dark">
        <div class="card-value"><%= todayData.getRefundApproved() %>건</div>
        <div class="card-title">승인 완료</div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card-box bg-danger-subtle text-dark">
        <div class="card-value"><%= todayData.getRefundRejected() %>건</div>
        <div class="card-title">반려</div>
      </div>
    </div>
  </div>
</div>
