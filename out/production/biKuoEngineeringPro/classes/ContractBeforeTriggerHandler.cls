/*
* Author : Jerry Sun
* Date: 2022.2.7
* Function : 1 根据合同记录类型字段 改正 合同记录类型
 */

public with sharing class ContractBeforeTriggerHandler implements Triggers.Handler {
    public void handle() {
    	if(Trigger.isInsert && Trigger.isBefore){
    		for(Contract con:(List<Contract>)trigger.new){
                if(con.ContractRecordType__c == 'Master'){
                   con.RecordTypeid = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Master').getRecordTypeId();
                }else if(con.ContractRecordType__c == 'Package'){
                   con.RecordTypeid = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Package').getRecordTypeId();
                }else{
                    con.RecordTypeid = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId();
                }
    		}

    	}
    	if(Trigger.isUpdate && Trigger.isBefore){
    	/*
    	   Map<ID, RecordType> RecordTypeMap = new Map<ID, RecordType>([SELECT Id,Name,DeveloperName FROM RecordType where SobjectType = 'Contract' LIMIT 10]);
           for(Contract con:(List<Contract>)trigger.new){
           	  Contract oldCon = (Contract)trigger.oldMap.get(con.id);
           	  if(con.RecordTypeid != oldCon.RecordTypeid){
                 con.ContractRecordType__c = RecordTypeMap.get(con.RecordTypeid).DeveloperName;
           	  }
           }*/

    	}
        
    }
}