/**
 * Created by tko18 on 2022/2/14.
 */
/**
*@ClassName:Lin-Tui
*@Description:代码汇总
 *              1.已选专家数量，项目专家数
 *              2.已访专家数量,项目专家-访谈状态-已访谈
*@Authortko18
*@Date 2022/2/14 15:06
*@Version:1.0.0
**/
public with sharing class ProjectExpertTotalAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
//        if (Trigger.isAfter && Trigger.isInsert) {
//            Map<String, Decimal> projectExpertTotalMap = new Map<String, Decimal>();
//            Map<String, Decimal> projectExpertTotal2Map = new Map<String, Decimal>();
//            List<adviser__c> adviserList = new List<adviser__c>();
//            for (Project_expert__c projectExpert : (List<Project_expert__c>) Trigger.new) {
//                if (!projectExpertTotalMap.containsKey(projectExpert.projectName__c)) {
//                    projectExpertTotalMap.put(projectExpert.projectName__c, 0);
//                }
//                if (!projectExpertTotal2Map.containsKey(projectExpert.projectName__c)) {
//                    projectExpertTotal2Map.put(projectExpert.projectName__c, 0);
//                }
//                if (projectExpert.interviewStatus__c == '已访谈') {
//                    projectExpertTotal2Map.put(projectExpert.projectName__c, (projectExpertTotal2Map.get(projectExpert.projectName__c) + 1));
//                }
//                projectExpertTotalMap.put(projectExpert.projectName__c, (projectExpertTotalMap.get(projectExpert.projectName__c) + 1));
//            }
//            for (adviser__c adviser : [SELECT Id,chooseExpert__c,interviewExpert__c FROM adviser__c WHERE Id IN:projectExpertTotalMap.keySet()]) {
//                Decimal expDecimal = projectExpertTotalMap.get(adviser.Id);
//                Decimal expDecimal2 = projectExpertTotal2Map.get(adviser.Id);
//                if (expDecimal != null) {
//                    adviser.chooseExpert__c += expDecimal;
//                }
//                if (expDecimal2 != null) {
//                    adviser.interviewExpert__c += expDecimal2;
//                }
//                adviserList.add(adviser);
//            }
//            if (adviserList.size() > 0) {
//                Database.update(adviserList, false);
//            }
//        }
//        if (Trigger.isAfter && Trigger.isUpdate) {
//            Map<Id, Project_expert__c> projectExpertOldMap = (Map<Id, Project_expert__c>) Trigger.oldMap;
//            Map<String, Map<String, Decimal>> projectExpertTotal2Map = new Map<String, Map<String, Decimal>>();
//            List<adviser__c> adviserList = new List<adviser__c>();
//            for (Project_expert__c projectExpert : (List<Project_expert__c>) Trigger.new) {
//                Integer i = 0;
//                if (!projectExpertTotal2Map.containsKey(projectExpert.projectName__c)) {
//                    projectExpertTotal2Map.put(projectExpert.projectName__c, new Map<String, Decimal>());
//                }
//                if (projectExpert.interviewStatus__c != projectExpertOldMap.get(projectExpert.Id).interviewStatus__c && projectExpert.interviewStatus__c == '已访谈') {
//                    projectExpertTotal2Map.get(projectExpert.projectName__c).put('add' + i, 1);
//                } if (projectExpert.interviewStatus__c != '已访谈') {
//                    projectExpertTotal2Map.get(projectExpert.projectName__c).put('red' + i, 1);
//                }
//            }
//            for (adviser__c adviser : [SELECT Id,interviewExpert__c FROM adviser__c WHERE Id IN:projectExpertTotal2Map.keySet()]) {
//                Map<String, Decimal> actionMap = projectExpertTotal2Map.get(adviser.Id);
//                System.debug('未操作前' + adviser.interviewExpert__c);
//                if (actionMap != null) {
//                    for (String action : actionMap.keySet()) {
//                        if (action.substring(0, 3) == 'red') {
//                            System.debug('删除');
//                            if (adviser.interviewExpert__c > 0) {
//                                adviser.interviewExpert__c -= actionMap.get(action);
//                            }
//
//                        }
//                        if (action.substring(0, 3) == 'add') {
//                            System.debug('新增');
//                            adviser.interviewExpert__c += actionMap.get(action);
//                        }
//                    }
//                    System.debug('操作后' + adviser.interviewExpert__c);
//                    adviserList.add(adviser);
//                }
//            }
//            if (adviserList.size() > 0) {
//                Database.update(adviserList, false);
//            }
//        }
        if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete))) {
            Map<String, Decimal> projectExpertTotalDecMap = new Map<String, Decimal>();
            Map<String, Decimal> projectExpertTotalDec2Map = new Map<String, Decimal>();
            List<adviser__c> adviserListDec = new List<adviser__c>();
            Set<String> projectExpertSet = new Set<String>();
            if (Trigger.isDelete) {
                for (Project_expert__c projectExpert : (List<Project_expert__c>) Trigger.old) {
                    projectExpertSet.add(projectExpert.projectName__c);
                }
            } else {
                for (Project_expert__c projectExpert : (List<Project_expert__c>) Trigger.new) {
                    projectExpertSet.add(projectExpert.projectName__c);
                }
            }

            for (adviser__c adviser : [SELECT Id,chooseExpert__c,interviewExpert__c, (SELECT Id,interviewStatus__c FROM projectNameGgra__r) FROM adviser__c WHERE Id IN:projectExpertSet]) {

                if (!projectExpertTotalDecMap.containsKey(adviser.Id)) {
                    projectExpertTotalDecMap.put(adviser.Id, 0);
                }
                if (!projectExpertTotalDec2Map.containsKey(adviser.Id)) {
                    projectExpertTotalDec2Map.put(adviser.Id, 0);
                }

                if (adviser.projectNameGgra__r.size() > 0) {
                    adviser.chooseExpert__c = 0.0;
                    adviser.interviewExpert__c = 0.0;
                    for (Project_expert__c projectExpert : (List<Project_expert__c>) adviser.projectNameGgra__r) {
                        if (projectExpert.interviewStatus__c == '已访谈') {
                            projectExpertTotalDec2Map.put(adviser.Id, (projectExpertTotalDec2Map.get(adviser.Id) + 1));
                        }
                        projectExpertTotalDecMap.put(adviser.Id, (projectExpertTotalDecMap.get(adviser.Id) + 1));
                    }
                }
                if (adviser.projectNameGgra__r.size() == 0) {
                    adviser.chooseExpert__c = 0.0;
                    adviser.interviewExpert__c = 0.0;
                }
                if (projectExpertTotalDecMap.size() > 0) {
                    Decimal expDecimals = projectExpertTotalDecMap.get(adviser.Id);
                    adviser.chooseExpert__c = expDecimals;
                }

                if (projectExpertTotalDec2Map.size() > 0) {
                    Decimal expDecimals = projectExpertTotalDec2Map.get(adviser.Id);
                    adviser.interviewExpert__c = expDecimals;
                }
                adviserListDec.add(adviser);
            }
            if (adviserListDec.size() > 0) {
                Database.update(adviserListDec, false);
            }
        }

    }
}