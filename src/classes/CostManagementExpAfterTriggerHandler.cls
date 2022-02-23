/**
 * Created by tko18 on 2022/2/11.
 */
/**
*@ClassName:Lin-Tui
*@Description:费用改变后，将费用管理下的所有费用的专家评价份加起来*以项目下费用数，赋值到项目的平均分
*@Authortko18
*@Date 2022/2/11 14:18
*@Version:1.0.0
**/
public with sharing class CostManagementExpAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
        if (Trigger.isAfter && Trigger.isUpdate) {
            Map<String, List<Decimal>> costManagementExpMap = new Map<String, List<Decimal>>();
            List<adviser__c> adviserList = new List<adviser__c>();
            for (Cost_management__c cost : (List<Cost_management__c>) Trigger.new) {
                if (cost.CostmanagementRecordTypeDevelop__c == 'RecordType') {
                    if (!costManagementExpMap.containsKey(cost.project__c)) {
                        costManagementExpMap.put(cost.project__c, new List<Decimal>());
                    }
                    costManagementExpMap.get(cost.project__c).add(cost.mark__c);
                }

            }
            for (adviser__c adviser : [SELECT Id,averageScore__c FROM adviser__c WHERE Id IN:costManagementExpMap.keySet()]) {
                List<Decimal> expDecimals = costManagementExpMap.get(adviser.Id);
                if (expDecimals != null) {
                    if (expDecimals.size() > 0) {
                        Decimal dec = 0.0;
                        for (Decimal deci : expDecimals) {
                            dec += deci;
                        }
                        adviser.averageScore__c = dec / expDecimals.size();
                        adviserList.add(adviser);
                    }
                }

            }
            if (adviserList.size() > 0) {
                Database.update(adviserList, false);
            }
        }
    }
}