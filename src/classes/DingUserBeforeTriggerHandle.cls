public with sharing class DingUserBeforeTriggerHandle implements Triggers.Handler {
    public void handle() {
    	List<string> dingIdList = new List<string>();
        Map<string,string> staffMap = new Map<string,string>();
        if(Trigger.isBefore && Trigger.isInsert){
        	for(vlink__DING_User__c dingUser:(List<vlink__DING_User__c>)Trigger.new){
                if(dingUser.Staff__c == null){
                    dingIdList.add(dingUser.vlink__User_ID__c);
                }
        	}
        	for(staff__c staff:[select id,External_id__c from staff__c where External_id__c in: dingIdList]){
                staffMap.put(staff.External_id__c,staff.id);
        	} 
        	for(vlink__DING_User__c dingUser:(List<vlink__DING_User__c>)Trigger.new){
	            if(staffMap.containsKey(dingUser.vlink__User_ID__c) && staffMap.get(dingUser.vlink__User_ID__c) != null){
                    dingUser.Staff__c = staffMap.get(dingUser.vlink__User_ID__c);
	            }
        	}
        }else if(Trigger.isBefore && Trigger.isUpdate){
            for(vlink__DING_User__c dingUser:(List<vlink__DING_User__c>)Trigger.new){
                if(dingUser.Staff__c == null){
                    dingIdList.add(dingUser.vlink__User_ID__c);
                }
        	}
        	for(staff__c staff:[select id,External_id__c from staff__c where External_id__c in: dingIdList]){
                staffMap.put(staff.External_id__c,staff.id);
        	} 
        	for(vlink__DING_User__c dingUser:(List<vlink__DING_User__c>)Trigger.new){
	            if(staffMap.containsKey(dingUser.vlink__User_ID__c) && staffMap.get(dingUser.vlink__User_ID__c) != null){
                    dingUser.Staff__c = staffMap.get(dingUser.vlink__User_ID__c);
	            }
        	}
        }
    }
}