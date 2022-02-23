/**
 * Created by tko18 on 2022/2/15.
 */
/**
*@ClassName:Lin-Tui
*@Description:T
 *             1.Revenue汇总，provision所有Revenue字段数据汇总
 *             2.Provision汇总，provision所有Provision字段数据汇总
 *             3.收入汇总，provision所有本月收入字段数据汇总
*@Authortko18
*@Date 2022/2/15 22:12
*@Version:1.0.0
**/
public with sharing class ProvisionTotalAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
        if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete))) {
            Set<String> ProvisionSet = new Set<String>();
            List<adviser__c> adviserListDec = new List<adviser__c>();
            Map<String, List<Decimal>> provisionDec1Map = new Map<String, List<Decimal>>();
            Map<String, List<Decimal>> provisionDec2Map = new Map<String, List<Decimal>>();
            Map<String, List<Decimal>> provisionDec3Map = new Map<String, List<Decimal>>();
            if (Trigger.isDelete) {
                for (Provision__c provision : (List<Provision__c>) Trigger.old) {
                    ProvisionSet.add(provision.project__c);
                }
            } else {
                for (Provision__c provision : (List<Provision__c>) Trigger.new) {
                    ProvisionSet.add(provision.project__c);
                }
            }

            for (adviser__c adviser : [SELECT Id,revenue__c,provision__c,incomeTotal__c, (SELECT Id,Revenue__c,Provision__c,income__c FROM Provision_Project__r) FROM adviser__c WHERE Id IN:ProvisionSet]) {

                if (!provisionDec1Map.containsKey(adviser.Id)) {
                    provisionDec1Map.put(adviser.Id, new List<Decimal>());
                }
                if (!provisionDec2Map.containsKey(adviser.Id)) {
                    provisionDec2Map.put(adviser.Id, new List<Decimal>());
                }
                if (!provisionDec3Map.containsKey(adviser.Id)) {
                    provisionDec3Map.put(adviser.Id, new List<Decimal>());
                }
                if (adviser.Provision_Project__r.size() > 0) {
                    adviser.revenue__c = 0;
                    adviser.provision__c = 0;
                    adviser.incomeTotal__c = 0;
                    for (Provision__c provision : (List<Provision__c>) adviser.Provision_Project__r) {
                        provisionDec1Map.get(adviser.Id).add(provision.Revenue__c);
                        provisionDec2Map.get(adviser.Id).add(provision.Provision__c);
                        provisionDec3Map.get(adviser.Id).add(provision.income__c);
                    }
                }
                if (adviser.Provision_Project__r.size() == 0) {
                    adviser.revenue__c = 0;
                    adviser.provision__c = 0;
                    adviser.incomeTotal__c = 0;
                }


                if (provisionDec1Map.size() > 0) {
                    List<Decimal> expDecimals = provisionDec1Map.get(adviser.Id);
                    System.debug('本月revenue' + expDecimals);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }

                            }
                            adviser.revenue__c = dec;
                        }
                    }
                }
                if (provisionDec2Map.size() > 0) {
                    List<Decimal> expDecimals = provisionDec2Map.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.provision__c = dec;
                        }
                    }
                }

                if (provisionDec3Map.size() > 0) {
                    List<Decimal> expDecimals = provisionDec3Map.get(adviser.Id);
                    if (expDecimals != null) {
                        if (expDecimals.size() > 0) {
                            Decimal dec = 0.0;
                            for (Decimal deci : expDecimals) {
                                if (deci != null) {
                                    dec += deci;
                                }
                            }
                            adviser.incomeTotal__c = dec;
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