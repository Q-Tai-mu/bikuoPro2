/**
 * Created by tko18 on 2022/2/9.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/9 12:55
*@Version:1.0.0
**/
public with sharing class ProjectPersonnelBeforeTriggerHandler implements Triggers.Handler {
    public void handle() {
        if (Trigger.isBefore && Trigger.isInsert) {
            Map<String, String> projectPersonnelMap = new Map<String, String>();
            Set<String> personnelSet = new Set<String>();
            Set<String> projectSet = new Set<String>();
            Map<String, String> staffMap = new Map<String, String>();
            Map<String, List<Cost_management__c>> adviserConstManagementMap = new Map<String, List<Cost_management__c>>();
            Map<String, List<Provision__c>> adviserProvisionMap = new Map<String, List<Provision__c>>();
            Map<String, List<Collection__c>> adviserCollectionMap = new Map<String, List<Collection__c>>();
            List<adviser__Share> adviserShares = new List<adviser__Share>();
            List<Cost_management__Share> costManagementShares = new List<Cost_management__Share>();
            List<Provision__Share> provisionShares = new List<Provision__Share>();
            List<Collection__Share> collectionShares = new List<Collection__Share>();
            for (Project_personnel__c pp : (List<Project_personnel__c>) Trigger.new) {
                if (pp.userName__c != null && pp.project__c != null) {
                    projectPersonnelMap.put(pp.userName__c, pp.project__c);
                    personnelSet.add(pp.userName__c);
                    projectSet.add(pp.project__c);
                } else {
                    pp.addError('当前项目人员“姓名”或“项目“字段未填写：会导致 项目  费用(专家费除外) 无法共享功能无法使用');
                }
            }

            //查询所有项目人员对应的用户,【项目】及其【费用】,【收款】【Provision】
            for (staff__c staff : [SELECT Id,user__c FROM staff__c WHERE Id IN :personnelSet]) {
                staffMap.put(staff.Id, staff.user__c);
            }
            for (adviser__c adviser : [SELECT Id, (SELECT Id FROM ObjectManagerGgXO__r), (SELECT Id FROM Provision_Project__r), (SELECT Id FROM projectGgYv__r) FROM adviser__c WHERE Id IN :projectSet]) {
                if (adviser.ObjectManagerGgXO__r.size() > 0) {

                    if (!adviserConstManagementMap.containsKey(adviser.Id)) {
                        adviserConstManagementMap.put(adviser.Id, new List<Cost_management__c>());
                    }
                    for (Cost_management__c costManagement : adviser.ObjectManagerGgXO__r) {
                        adviserConstManagementMap.get(adviser.Id).add(costManagement);
                    }
                }
                if (adviser.Provision_Project__r.size() > 0) {
                    if (!adviserProvisionMap.containsKey(adviser.Id)) {
                        adviserProvisionMap.put(adviser.Id, new List<Provision__c>());
                    }
                    for (Provision__c provision : adviser.Provision_Project__r) {
                        adviserProvisionMap.get(adviser.Id).add(provision);
                    }
                }
                if (adviser.projectGgYv__r.size() > 0) {
                    if (!adviserCollectionMap.containsKey(adviser.Id)) {
                        adviserCollectionMap.put(adviser.Id, new List<Collection__c>());
                    }
                    for (Collection__c collection : adviser.projectGgYv__r) {
                        adviserCollectionMap.get(adviser.Id).add(collection);
                    }
                }
            }
            for (Project_personnel__c ppl : (List<Project_personnel__c>) Trigger.new) {
                List<Cost_management__c> costManagements = adviserConstManagementMap.get(projectPersonnelMap.get(ppl.userName__c));
                List<Provision__c> provisions = adviserProvisionMap.get(projectPersonnelMap.get(ppl.userName__c));
                List<Collection__c> collections = adviserCollectionMap.get(projectPersonnelMap.get(ppl.userName__c));

                adviser__Share adviserShare = new adviser__Share();
                adviserShare.ParentId = ppl.project__c;
                adviserShare.UserOrGroupId = staffMap.get(ppl.userName__c);
                adviserShare.AccessLevel = 'Read';
                adviserShare.RowCause = 'Manual';
                adviserShares.add(adviserShare);
                if (costManagements != null) {
                    if (costManagements.size() > 0) {
                        for (Cost_management__c costManagement : costManagements) {
                            Cost_management__Share costManagementShare = new Cost_management__Share();
                            costManagementShare.ParentId = costManagement.Id;
                            costManagementShare.UserOrGroupId = staffMap.get(ppl.userName__c);
                            costManagementShare.AccessLevel = 'Read';
                            costManagementShare.RowCause = 'Manual';
                            costManagementShares.add(costManagementShare);
                        }
                    }
                }

                if (provisions != null) {
                    if (provisions.size() > 0) {
                        for (Provision__c provision : provisions) {
                            Provision__Share provisionShare = new Provision__Share();
                            provisionShare.ParentId = provision.Id;
                            provisionShare.UserOrGroupId = staffMap.get(ppl.userName__c);
                            provisionShare.AccessLevel = 'Read';
                            provisionShare.RowCause = 'Manual';
                            provisionShares.add(provisionShare);
                        }
                    }
                }

                if (collections != null) {
                    if (collections.size() > 0) {
                        for (Collection__c collection : collections) {
                            Collection__Share collectionShare = new Collection__Share();
                            collectionShare.ParentId = collection.Id;
                            collectionShare.UserOrGroupId = staffMap.get(ppl.userName__c);
                            collectionShare.AccessLevel = 'Read';
                            collectionShare.RowCause = 'Manual';
                            collectionShares.add(collectionShare);
                        }
                    }
                }

            }

            if (adviserShares.size() > 0) {
                Database.insert(adviserShares, false);
            }

            if (costManagementShares.size() > 0) {
                Database.insert(costManagementShares, false);
            }

            if (provisionShares.size() > 0) {
                Database.insert(provisionShares, false);
            }

            if (collectionShares.size() > 0) {
                Database.insert(collectionShares, false);
            }
        }
    }
}