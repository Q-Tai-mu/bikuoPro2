/**
 * Created by tko18 on 2022/2/9.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/9 15:40
*@Version:1.0.0
**/
public with sharing class ProjectPersonDaysBeforeTriggerHandler implements Triggers.Handler {
    public void handle() {
        if (Trigger.isBefore && Trigger.isUpdate) {
            Map<Id, Project_person_days__c> projectPersonDaysByIdsOldMap = (Map<Id, Project_person_days__c>) Trigger.oldMap;
            for (Project_person_days__c ppd : (List<Project_person_days__c>) Trigger.new) {
                if (ppd.status__c != projectPersonDaysByIdsOldMap.get(ppd.Id).status__c && ppd.status__c == '已审批') {
                    Approval.LockResult lockResult = Approval.lock(ppd.Id);
                    if (!lockResult.isSuccess()) {
                        ppd.addError('当前项目人天 无法从待审批转已审批锁定记录');
                        for (Database.Error error : lockResult.getErrors()) {
                            System.debug('error message : ' + error.getMessage());
                        }
                    }
                }
            }
        }
    }
}