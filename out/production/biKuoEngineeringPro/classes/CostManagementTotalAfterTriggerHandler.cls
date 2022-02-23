/**
 * Created by tko18 on 2022/2/14.
 */
/**
*@ClassName:Lin-Tui
*@Description:代码赋值
 *          1.汇总项目下费用(1.汇总项目下专家费；2.汇总项目下费用，包括每刻同步来的报销费用，和实习生费用等）
 *          2.汇总项目下费用，是否charge客户为真(1.汇总项目下专家费；2.汇总项目下费用，包括每刻同步来的报销费用，和实习生费用等）
 *          3.汇总项目下费用，是否charge客户为假(1.汇总项目下专家费；2.汇总项目下费用，包括每刻同步来的报销费用，和实习生费用等）
 *          4.已访专家小时数，费用-计费时长（分钟）字段创建、更新时的汇总
*@Authortko18
*@Date 2022/2/14 10:42
*@Version:1.0.0
**/
public with sharing class CostManagementTotalAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
//        Map<String, List<Decimal>> costManagementMap = new Map<String, List<Decimal>>();
//        Map<String, List<Decimal>> costManagementIsCustomerMap = new Map<String, List<Decimal>>();
//        Map<String, List<Decimal>> costManagementNotCustomerMap = new Map<String, List<Decimal>>();
//        Map<String, List<Decimal>> costManagementHoursMap = new Map<String, List<Decimal>>();
//        List<adviser__c> adviserList = new List<adviser__c>();
//        List<adviser__c> adviserListChangeOk = new List<adviser__c>();
//        List<adviser__c> adviserListChangeNo = new List<adviser__c>();
//        List<adviser__c> adviserListHours = new List<adviser__c>();
//        if (Trigger.isAfter && Trigger.isInsert) {
//            for (Cost_management__c costManagement : (List<Cost_management__c>) Trigger.new) {
//                if (!costManagementMap.containsKey(costManagement.project__c)) {
//                    costManagementMap.put(costManagement.project__c, new List<Decimal>());
//                }
//                if (!costManagementHoursMap.containsKey(costManagement.project__c)) {
//                    costManagementHoursMap.put(costManagement.project__c, new List<Decimal>());
//                }
//                if (costManagement.status__c == '已审批' && (costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType3' || costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType2')) {
//                    costManagementMap.get(costManagement.project__c).add(costManagement.amount__c);
//                }
//                if (costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType') {
//                    costManagementHoursMap.get(costManagement.project__c).add(costManagement.chargeTimeMinute__c);
//                }
//                if (costManagement.charge_chargeAccount__c == '是') {
//                    if (!costManagementIsCustomerMap.containsKey(costManagement.project__c)) {
//                        costManagementIsCustomerMap.put(costManagement.project__c, new List<Decimal>());
//                    }
//                    costManagementIsCustomerMap.get(costManagement.project__c).add(costManagement.amount__c);
//                } else {
//                    if (!costManagementNotCustomerMap.containsKey(costManagement.project__c)) {
//                        costManagementNotCustomerMap.put(costManagement.project__c, new List<Decimal>());
//                    }
//                    costManagementNotCustomerMap.get(costManagement.project__c).add(costManagement.amount__c);
//                }
//            }
//            if (costManagementMap.size() > 0) {
//                for (adviser__c adviser : [SELECT Id,totalCost__c FROM adviser__c WHERE Id IN:costManagementMap.keySet()]) {
//                    List<Decimal> expDecimals = costManagementMap.get(adviser.Id);
//                    if (expDecimals != null) {
//                        if (expDecimals.size() > 0) {
//                            Decimal dec = 0.0;
//                            for (Decimal deci : expDecimals) {
//                                dec += deci;
//                            }
//                            adviser.totalCost__c += dec;
//                            adviserList.add(adviser);
//                        }
//                    }
//                }
//
//            }
//            if (costManagementHoursMap.size() > 0) {
//                for (adviser__c adviser : [SELECT Id,interviewExpertTime__c FROM adviser__c WHERE Id IN:costManagementHoursMap.keySet()]) {
//                    List<Decimal> expDecimals = costManagementHoursMap.get(adviser.Id);
//                    if (expDecimals != null) {
//                        if (expDecimals.size() > 0) {
//                            Decimal dec = 0.0;
//                            for (Decimal deci : expDecimals) {
//                                dec += deci;
//                            }
//                            adviser.interviewExpertTime__c += dec / 60;
//                            adviserListHours.add(adviser);
//                        }
//                    }
//                }
//            }
//            if (costManagementIsCustomerMap.size() > 0) {
//                for (adviser__c adviser : [SELECT Id,charge_charge__c FROM adviser__c WHERE Id IN:costManagementIsCustomerMap.keySet()]) {
//                    List<Decimal> expDecimals = costManagementMap.get(adviser.Id);
//                    if (expDecimals != null) {
//                        if (expDecimals.size() > 0) {
//                            Decimal dec = 0.0;
//                            for (Decimal deci : expDecimals) {
//                                dec += deci;
//                            }
//                            adviser.charge_charge__c += dec;
//                            adviserListChangeOk.add(adviser);
//                        }
//                    }
//                }
//
//            }
//            if (costManagementNotCustomerMap.size() > 0) {
//                for (adviser__c adviser : [SELECT Id,charge_noCharge__c FROM adviser__c WHERE Id IN:costManagementNotCustomerMap.keySet()]) {
//                    List<Decimal> expDecimals = costManagementMap.get(adviser.Id);
//                    if (expDecimals != null) {
//                        if (expDecimals.size() > 0) {
//                            Decimal dec = 0.0;
//                            for (Decimal deci : expDecimals) {
//                                dec += deci;
//                            }
//                            adviser.charge_noCharge__c += dec;
//                            adviserListChangeNo.add(adviser);
//                        }
//                    }
//                }
//
//            }
//            if (adviserList.size() > 0) {
//                Database.update(adviserList, false);
//            }
//            if (adviserListChangeOk.size() > 0) {
//                Database.update(adviserListChangeOk, false);
//            }
//            if (adviserListChangeNo.size() > 0) {
//                Database.update(adviserListChangeNo, false);
//            }
//
//            if (adviserListHours.size() > 0) {
//                Database.update(adviserListHours, false);
//            }
//
//        }
//        if (Trigger.isAfter && Trigger.isUpdate) {
//            Map<Id, Cost_management__c> costManagementOldMap = (Map<Id, Cost_management__c>) Trigger.oldMap;
//            Map<String, Map<String, Decimal>> costManagementDecMap = new Map<String, Map<String, Decimal>>();
//            Map<String, Map<String, Decimal>> costManagementDec2Map = new Map<String, Map<String, Decimal>>();
//            Map<String, Map<String, Decimal>> costManagementDec3Map = new Map<String, Map<String, Decimal>>();
//            Set<String> costManagementSet = new Set<String>();
//            List<adviser__c> adviserList2 = new List<adviser__c>();
//            for (Cost_management__c costManagement : (List<Cost_management__c>) Trigger.new) {
//                Integer i = 0;
//                if (!costManagementDecMap.containsKey(costManagement.project__c)) {
//                    costManagementDecMap.put(costManagement.project__c, new Map<String, Decimal>());
//                }
//                if (!costManagementDec2Map.containsKey(costManagement.project__c)) {
//                    costManagementDec2Map.put(costManagement.project__c, new Map<String, Decimal>());
//                }
//                if (!costManagementDec3Map.containsKey(costManagement.project__c)) {
//                    costManagementDec3Map.put(costManagement.project__c, new Map<String, Decimal>());
//                }
//
//                if ((costManagement.status__c != costManagementOldMap.get(costManagement.Id).status__c && costManagement.status__c == '已请款') && costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType') {
//                    costManagementDecMap.get(costManagement.project__c).put('add' + i, costManagement.amount__c);
//                }
//                if ((costManagement.status__c != costManagementOldMap.get(costManagement.Id).status__c && costManagement.status__c == '已审批') && (costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType3' || costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType2')) {
//                    costManagementDecMap.get(costManagement.project__c).put('add' + i, costManagement.amount__c);
//                }
//
//                if (costManagement.charge_chargeAccount__c != costManagementOldMap.get(costManagement.Id).charge_chargeAccount__c && costManagement.charge_chargeAccount__c == '是') {
//                    costManagementDec2Map.get(costManagement.project__c).put('add' + i, costManagement.amount__c);
//                } else if (costManagement.charge_chargeAccount__c != costManagementOldMap.get(costManagement.Id).charge_chargeAccount__c && costManagement.charge_chargeAccount__c != '是') {
//                    costManagementDec2Map.get(costManagement.project__c).put('red' + i, costManagement.amount__c);
//                }
//
//                if (costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType' && (costManagement.chargeTimeMinute__c != costManagementOldMap.get(costManagement.Id).chargeTimeMinute__c)) {
//                    if (costManagement.chargeTimeMinute__c > costManagementOldMap.get(costManagement.Id).chargeTimeMinute__c) {
//                        costManagementDec3Map.get(costManagement.project__c).put('add' + i, (costManagement.chargeTimeMinute__c - costManagementOldMap.get(costManagement.Id).chargeTimeMinute__c));
//                    } else {
//                        costManagementDec3Map.get(costManagement.project__c).put('red' + i, (costManagementOldMap.get(costManagement.Id).chargeTimeMinute__c - costManagement.chargeTimeMinute__c));
//                    }
//                }
//                costManagementSet.add(costManagement.project__c);
//            }
//
//
//            for (adviser__c adviser : [SELECT Id,totalCost__c,charge_charge__c,charge_noCharge__c,interviewExpertTime__c FROM adviser__c WHERE Id IN:costManagementSet]) {
//                Map<String, Decimal> action1Map = costManagementDecMap.get(adviser.Id);
//                Map<String, Decimal> action2Map = costManagementDec2Map.get(adviser.Id);
//                Map<String, Decimal> action3Map = costManagementDec3Map.get(adviser.Id);
//                if (action1Map != null) {
//                    for (String action : action1Map.keySet()) {
//                        if (action.substring(0, 3) == 'red') {
//                            adviser.totalCost__c -= action1Map.get(action);
//                        }
//                        if (action.substring(0, 3) == 'add') {
//                            adviser.totalCost__c += action1Map.get(action);
//                        }
//                    }
//                }
//                if (action2Map != null) {
//                    for (String action : action2Map.keySet()) {
//                        if (action.substring(0, 3) == 'red') {
//                            adviser.charge_charge__c -= action2Map.get(action);
//                            adviser.charge_noCharge__c += action2Map.get(action);
//                        }
//                        if (action.substring(0, 3) == 'add') {
//                            adviser.charge_charge__c += action2Map.get(action);
//                            adviser.charge_noCharge__c -= action2Map.get(action);
//                        }
//                    }
//                }
//                if (action3Map != null) {
//                    for (String action : action3Map.keySet()) {
//                        if (action.substring(0, 3) == 'red') {
//                            if (adviser.interviewExpertTime__c == null) {
//                                adviser.interviewExpertTime__c = 0.0;
//                            }
//                            adviser.interviewExpertTime__c -= action3Map.get(action) / 60;
//                        }
//                        if (action.substring(0, 3) == 'add') {
//                            if (adviser.interviewExpertTime__c == null) {
//                                adviser.interviewExpertTime__c = 0.0;
//                            }
//                            adviser.interviewExpertTime__c += action3Map.get(action) / 60;
//                        }
//                    }
//                }
//                adviserList2.add(adviser);
//            }
//            if (adviserList2.size() > 0) {
//                Database.update(adviserList2, false);
//            }
//
//        }
        if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete))) {
            Map<String, List<Decimal>> costManagement1Map = new Map<String, List<Decimal>>();
            Map<String, List<Decimal>> costManagement2Map = new Map<String, List<Decimal>>();
            Map<String, List<Decimal>> costManagement3Map = new Map<String, List<Decimal>>();
            Map<String, List<Decimal>> costManagement4Map = new Map<String, List<Decimal>>();
            Set<String> costManagementSet = new Set<String>();
            List<adviser__c> adviserList = new List<adviser__c>();
            if (Trigger.isDelete) {
                System.debug('删除' + Trigger.old);
                for (Cost_management__c costManagement : (List<Cost_management__c>) Trigger.old) {
                    costManagementSet.add(costManagement.project__c);
                }
            } else {
                for (Cost_management__c costManagement : (List<Cost_management__c>) Trigger.new) {
                    costManagementSet.add(costManagement.project__c);
                }
            }

            for (adviser__c adviser : [
                    SELECT Id,totalCost__c,charge_charge__c,charge_noCharge__c,interviewExpertTime__c, (SELECT Id,project__c,status__c,CostmanagementRecordTypeDevelop__c,charge_chargeAccount__c,chargeTimeMinute__c,amount__c FROM ObjectManagerGgXO__r)
                    FROM adviser__c
                    WHERE Id IN:costManagementSet
            ]) {
                if (adviser.ObjectManagerGgXO__r.size() > 0) {
                    adviser.totalCost__c = 0;
                    adviser.interviewExpertTime__c = 0;
                    adviser.charge_charge__c = 0;
                    adviser.charge_noCharge__c = 0;
                    for (Cost_management__c costManagement : (List<Cost_management__c>) adviser.ObjectManagerGgXO__r) {
                        if (!costManagement1Map.containsKey(adviser.Id)) {
                            costManagement1Map.put(adviser.Id, new List<Decimal>());
                        }
                        if (!costManagement2Map.containsKey(adviser.Id)) {
                            costManagement2Map.put(adviser.Id, new List<Decimal>());
                        }
                        if (!costManagement3Map.containsKey(adviser.Id)) {
                            costManagement3Map.put(adviser.Id, new List<Decimal>());
                        }
                        if (!costManagement4Map.containsKey(adviser.Id)) {
                            costManagement4Map.put(adviser.Id, new List<Decimal>());
                        }
                        if (costManagement.status__c == '已请款' && costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType') {
                            costManagement1Map.get(adviser.Id).add(costManagement.amount__c);
                        }
                        if (costManagement.status__c == '已审批' && (costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType3' || costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType2')) {
                            costManagement1Map.get(adviser.Id).add(costManagement.amount__c);
                        }

                        if (costManagement.CostmanagementRecordTypeDevelop__c == 'RecordType') {
                            costManagement2Map.get(adviser.Id).add(costManagement.chargeTimeMinute__c);
                        }
                        if (costManagement.charge_chargeAccount__c == '是') {
                            if (!costManagement3Map.containsKey(adviser.Id)) {
                                costManagement3Map.put(adviser.Id, new List<Decimal>());
                            }
                            costManagement3Map.get(adviser.Id).add(costManagement.amount__c);
                        } else {
                            if (!costManagement4Map.containsKey(adviser.Id)) {
                                costManagement4Map.put(adviser.Id, new List<Decimal>());
                            }
                            costManagement4Map.get(adviser.Id).add(costManagement.amount__c);
                        }
                    }
                }
                if (adviser.ObjectManagerGgXO__r.size() == 0) {
                    //删除最后一条
                    adviser.totalCost__c = 0;
                    adviser.interviewExpertTime__c = 0;
                    adviser.charge_charge__c = 0;
                    adviser.charge_noCharge__c = 0;
                }
                if (costManagement1Map.size() > 0) {
                    List<Decimal> expDecimals = costManagement1Map.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.totalCost__c = dec;
                        }
                    }
                }
                if (costManagement2Map.size() > 0) {
                    List<Decimal> expDecimals = costManagement2Map.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.interviewExpertTime__c = dec / 60;
                        }
                    }
                }
                if (costManagement3Map.size() > 0) {
                    List<Decimal> expDecimals = costManagement3Map.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.charge_charge__c = dec;
                        }
                    }
                }
                if (costManagement4Map.size() > 0) {
                    List<Decimal> expDecimals = costManagement4Map.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.charge_noCharge__c = dec;
                        }
                    }
                }
                adviserList.add(adviser);
            }
            if (adviserList.size() > 0) {
                Database.update(adviserList, false);
            }
        }


    }
}