/**
 * Created by tko18 on 2022/2/14.
 */
/**
*@ClassName:Lin-Tui
*@Description:
 *             1.需求专家数，代码赋值，汇总相关专家需求所需专家数量。专家需求-需求专家数量
 *             2.项目需求数，代码赋值，汇总相关专家需求数量 专家需求（本身数量）
*@Authortko18
*@Date 2022/2/14 15:36
*@Version:1.0.0
**/
public with sharing class ExpertDemandTotalAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
//        if (Trigger.isAfter && Trigger.isInsert) {
//            Map<String, List<Decimal>> expertDemandMap = new Map<String, List<Decimal>>();
//            Map<String, Decimal> expertDemand2Map = new Map<String, Decimal>();
//            List<adviser__c> adviserList = new List<adviser__c>();
//            for (Expert_demand__c expertDemand : (List<Expert_demand__c>) Trigger.new) {
//                if (!expertDemandMap.containsKey(expertDemand.project_Management__c)) {
//                    expertDemandMap.put(expertDemand.project_Management__c, new List<Decimal>());
//                }
//                if (!expertDemand2Map.containsKey(expertDemand.project_Management__c)) {
//                    expertDemand2Map.put(expertDemand.project_Management__c, 0);
//                }
//                expertDemand2Map.put(expertDemand.project_Management__c, (expertDemand2Map.get(expertDemand.project_Management__c) + 1));
//                expertDemandMap.get(expertDemand.project_Management__c).add(expertDemand.requireExpert__c);
//            }
//            for (adviser__c adviser : [SELECT Id,expertNumber__c,demandNumber__c FROM adviser__c WHERE Id IN:expertDemandMap.keySet()]) {
//                List<Decimal> expDecimals = expertDemandMap.get(adviser.Id);
//                Decimal expDecimal = expertDemand2Map.get(adviser.Id);
//                if (expDecimals != null) {
//                    if (expDecimals.size() > 0) {
//                        Decimal dec = 0.0;
//                        for (Decimal deci : expDecimals) {
//                            dec += deci;
//                        }
//                        adviser.expertNumber__c += dec;
//                    }
//                }
//                if (expDecimal != null) {
//                    adviser.demandNumber__c += expDecimal;
//                }
//                adviserList.add(adviser);
//            }
//            if (adviserList.size() > 0) {
//                Database.update(adviserList, false);
//            }
//        }
//        if (Trigger.isAfter && Trigger.isUpdate) {
//            Map<Id, Expert_demand__c> expertDemandOldMap = (Map<Id, Expert_demand__c>) Trigger.oldMap;
//            Map<String, Map<String, Decimal>>expertArithmeticMap = new Map<String, Map<String, Decimal>>();
//            List<adviser__c> adviserList = new List<adviser__c>();
//            for (Expert_demand__c expertDemand : (List<Expert_demand__c>) Trigger.new) {
//                Integer i = 0;
//                //项目是12  新5 老6 = 6-5 = 1 ,新6 老5= 6-5 = 1
//                if (!expertArithmeticMap.containsKey(expertDemand.project_Management__c)) {
//                    expertArithmeticMap.put(expertDemand.project_Management__c, new Map<String, Decimal>());
//                }
//                if (expertDemand.requireExpert__c > expertDemandOldMap.get(expertDemand.Id).requireExpert__c) {
//                    expertArithmeticMap.get(expertDemand.project_Management__c).put('add' + i, (expertDemand.requireExpert__c - expertDemandOldMap.get(expertDemand.Id).requireExpert__c));
//                } else {
//                    expertArithmeticMap.get(expertDemand.project_Management__c).put('red' + i, (expertDemandOldMap.get(expertDemand.Id).requireExpert__c) - expertDemand.requireExpert__c);
//                }
//            }
//            for (adviser__c adviser : [SELECT Id,expertNumber__c FROM adviser__c WHERE Id IN:expertArithmeticMap.keySet()]) {
//                Map<String, Decimal> actionMap = expertArithmeticMap.get(adviser.Id);
//                if (actionMap != null) {
//                    for (String action : actionMap.keySet()) {
//                        if (action.substring(0, 3) == 'red') {
//                            adviser.expertNumber__c -= actionMap.get(action);
//                        }
//                        if (action.substring(0, 3) == 'add') {
//                            adviser.expertNumber__c += actionMap.get(action);
//                        }
//                    }
//                    adviserList.add(adviser);
//                }
//            }
//
//            if (adviserList.size() > 0) {
//                Database.update(adviserList, false);
//            }
//
//        }
        if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete))) {
            Map<String, List<Decimal>> expertDemandDecMap = new Map<String, List<Decimal>>();
            Map<String, Decimal> expertDemandDec2Map = new Map<String, Decimal>();
            List<adviser__c> adviserListDec = new List<adviser__c>();
            Set<String> expertDemandSet = new Set<String>();
            if (Trigger.isDelete) {
                for (Expert_demand__c expertDemand : (List<Expert_demand__c>) Trigger.old) {
                    expertDemandSet.add(expertDemand.project_Management__c);
                }
            } else {
                for (Expert_demand__c expertDemand : (List<Expert_demand__c>) Trigger.new) {
                    expertDemandSet.add(expertDemand.project_Management__c);
                }
            }

            for (adviser__c adviser : [SELECT Id,expertNumber__c,demandNumber__c, (SELECT Id,requireExpert__c FROM project_ManagementGgrz__r) FROM adviser__c WHERE Id IN:expertDemandSet]) {

                if (!expertDemandDecMap.containsKey(adviser.Id)) {
                    expertDemandDecMap.put(adviser.Id, new List<Decimal>());
                }
                if (!expertDemandDec2Map.containsKey(adviser.Id)) {
                    expertDemandDec2Map.put(adviser.Id, 0);
                }

                if (adviser.project_ManagementGgrz__r.size() > 0) {
                    adviser.expertNumber__c = 0;
                    adviser.demandNumber__c = 0;
                    for (Expert_demand__c expertDemand : (List<Expert_demand__c>) adviser.project_ManagementGgrz__r) {
                        expertDemandDec2Map.put(adviser.Id, (expertDemandDec2Map.get(adviser.Id) + 1));
                        expertDemandDecMap.get(adviser.Id).add(expertDemand.requireExpert__c);
                    }
                }
                if (adviser.project_ManagementGgrz__r.size() == 0) {
                    adviser.expertNumber__c = 0;
                    adviser.demandNumber__c = 0;
                }
                if (expertDemandDec2Map.size() > 0) {
                    Decimal expDecimals = expertDemandDec2Map.get(adviser.Id);
                    adviser.demandNumber__c = expDecimals;
                }
                if (expertDemandDecMap.size() > 0) {
                    List<Decimal> expDecimals = expertDemandDecMap.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.expertNumber__c = dec;
                        }
                    }
                }

                adviserListDec.add(adviser);
            }

            if (adviserListDec.size() > 0) {
                Database.update(adviserListDec, false);
            }
        }


    }
}