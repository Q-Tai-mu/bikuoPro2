public with sharing class ManDaysInputController {

    @RemoteAction
    // 初始化查询人天信息
    public static String getManDaysInfoService() {
      try {
        List<WorkDayObject__c> queryResult= [SELECT Id,(Select id From workDay44IF__r) FROM WorkDayObject__c];
        for (WorkDayObject__c obj : queryResult) {
            
        }
        return null;
      } catch (Exception e) {
        return null;
        
      }
    }
    public class returnValue {
    }
}