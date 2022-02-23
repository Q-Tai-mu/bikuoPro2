/**
 * Created by tko18 on 2022/2/10.
 */
/**
*@ClassName:Lin-Tui
*@Description:在钉钉对项目专家评价后SF 根据项目专家的评分和比重算出总评分
*@Authortko18
*@Date 2022/2/10 12:04
*@Version:1.0.0
**/
public with sharing class CostManagementPoBeforeTriggerHandler implements Triggers.Handler {
    public void handle() {
        if (Trigger.isBefore && Trigger.isUpdate) {
            Map<String, score__c> mcs = score__c.getAll();
            Map<String, SObjectField> maps = Schema.SObjectType.Cost_management__c.fields.getMap();
            Map<String, Decimal> mcsWeightName = new Map<String, Decimal>();
            Map<String, Integer> mcsApiMap = new Map<String, Integer>();
            Map<String, Integer> mcsApi2Map = new Map<String, Integer>();
            Map<String, String> mcsApi3Map = new Map<String, String>();
            for (String key : mcs.keySet()) {
                mcsWeightName.put(mcs.get(key).name__c, mcs.get(key).rate__c);
                if (maps.containsKey(mcs.get(key).API__c + '__c')) {
                    SObjectField educationField = maps.get(mcs.get(key).API__c + '__c');
                    Schema.DescribeFieldResult educationFieldResult = educationField.getDescribe();
                    mcsApiMap.put(educationFieldResult.getLabel(), 0);
                    mcsApi2Map.put(mcs.get(key).API__c + '__c', 0);
                    mcsApi3Map.put(mcs.get(key).API__c + '__c', educationFieldResult.getLabel());
                }
            }

            for (Cost_management__c cost : (List<Cost_management__c>) Trigger.new) {
                if (cost.CostmanagementRecordTypeDevelop__c == 'RecordType') {
                    Map<String, Decimal> mcsCostMap1 = new Map<String, Decimal>();
                    Map<String, Decimal> mcsCostMap2 = new Map<String, Decimal>();

                    for (String keyMcsApi : mcsApiMap.keySet()) {
                        mcsCostMap1.put(keyMcsApi, mcsWeightName.get(keyMcsApi));
                    }
                    for (String keyMcsApi2 : mcsApi2Map.keySet()) {
                        mcsCostMap2.put(keyMcsApi2, mcsWeightName.get((String) cost.get(keyMcsApi2)));
                    }
                    Decimal dciTotal = 0.0;
                    if (mcsCostMap2.size() > 0) {
                        for (String keyMcsApiCost : mcsCostMap2.keySet()) {
                            Decimal dci1 = (Decimal) mcsCostMap2.get(keyMcsApiCost) ;
                            Decimal dci2 = ((Decimal) mcsCostMap1.get(mcsApi3Map.get(keyMcsApiCost)) / 100);
                            dciTotal += dci1 * dci2;
                        }
                        cost.mark__c = dciTotal;
                    }
                }


            }

        }
    }
}