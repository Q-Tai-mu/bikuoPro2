public with sharing class ExpertManagementAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
    	if(trigger.isAfter && trigger.isUpdate){
    		List<String> expertidList = new List<String>();
            for(Expert_management__c em:(List<Expert_management__c>)trigger.new){
                Expert_management__c oldem =(Expert_management__c)trigger.oldMap.get(em.id);
                if(oldem.status__c != em.status__c && em.status__c == '审批中'){
                    expertidList.add(em.id);
                }
            }
            if(expertidList.size() > 0){
            	//String Token = DingTalkUtil.GetDingTalkToken();
                DingTalkUtil.sendDingTalkApprovel(expertidList);
            }
    	}
        
    }
}