/**
 * Created by tko18 on 2022/2/9.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/9 15:59
*@Version:1.0.0
**/
public with sharing class CostManagementBeforeTriggerHandler implements Triggers.Handler {
    public void handle() {
        if (Trigger.isBefore && Trigger.isUpdate) {
            Map<Id, Cost_management__c> costManagementOldMap = (Map<Id, Cost_management__c>) Trigger.oldMap;
            for (Cost_management__c cost : (List<Cost_management__c>) Trigger.new) {
                if (cost.CostmanagementRecordTypeDevelop__c == 'RecordType') {
                    if (cost.status__c != costManagementOldMap.get(cost.Id).status__c && cost.status__c == '待支付') {
                        Approval.LockResult lockResult = Approval.lock(cost.Id);
                        if (!lockResult.isSuccess()) {
                            cost.addError('当前费用 无法锁定记录');
                            for (Database.Error error : lockResult.getErrors()) {
                                System.debug('error message : ' + error.getMessage());
                            }
                        }
                    }
                }
            }
        }
    }
}