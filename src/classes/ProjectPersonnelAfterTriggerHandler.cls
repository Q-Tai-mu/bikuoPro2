public with sharing class ProjectPersonnelAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
        if(Trigger.isAfter && Trigger.isInsert){
            List<adviser__c> updateAdviserList = new List<adviser__c>();
            Map<id,staff__c> staffMap = new Map<id,staff__c>([select id,user__c from staff__c]);
            for(Project_personnel__c pp: (List<Project_personnel__c>)Trigger.new){
                
                if(String.isNotBlank(pp.title__c) && 
                    (pp.title__c == 'Deputy Manager' || 
                     pp.title__c == 'Project Manager'|| 
                     pp.title__c == 'Senior Manager' ||
                     pp.title__c == 'Vice President')){
                    if(staffMap.containsKey(pp.userName__c) && staffMap.get(pp.userName__c).user__c != null){
                        if(pp.title__c == 'Vice President'){
                            adviser__c ad = new adviser__c();
                            ad.id = pp.project__c;
                            ad.VP__c = staffMap.get(pp.userName__c).user__c;
                            updateAdviserList.add(ad); 
                        }
                    }else{
                        pp.addError('当前员工没有关联对应的用户信息');
                    }
                }
            }
            if(updateAdviserList.size() > 0){
                Update updateAdviserList;
            }
        }
        
    }
}