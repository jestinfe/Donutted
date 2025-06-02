package dashboard;

import java.util.Collections;
import java.util.List;
import java.util.Map;

public class DashBoardService {

    // ✅ 싱글톤 DAO 사용
    private final DashBoardDAO dashboardDAO = DashBoardDAO.getInstance();

    public List<DailySummaryDTO> getRecentDailySummary() {
        try {
            return dashboardDAO.getDailySummary();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Map<String, Integer> getWeeklyMonthlySummary() {
        try {
            return dashboardDAO.getWeeklyMonthlySummary();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }
}
