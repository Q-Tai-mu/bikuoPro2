public with sharing class ProjectPersonDaysAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
        List<Project_person_days__Share> InsertList = new List<Project_person_days__Share>();
        if(Trigger.isAfter && Trigger.isInsert){
            for(Project_person_days__c ppd:(List<Project_person_days__c>)Trigger.new){
            	if(ppd.projectManageruser__c != null){
                    Project_person_days__Share ppds = new Project_person_days__Share();
                    ppds.ParentId = ppd.id;
                    ppds.UserOrGroupId = ppd.projectManageruser__c;
                    ppds.AccessLevel = 'Edit';
                    ppds.RowCause = 'Manual';
                    InsertList.add(ppds);
            	}
            }
            
        }else if(Trigger.isAfter && Trigger.isUpdate){
            for(Project_person_days__c ppd:(List<Project_person_days__c>)Trigger.new){
                Project_person_days__c oldppd = (Project_person_days__c)Trigger.oldMap.get(ppd.id);
                if(ppd.projectManageruser__c != oldppd.projectManageruser__c && ppd.projectManageruser__c != null){
                    Project_person_days__Share ppds = new Project_person_days__Share();
                    ppds.ParentId = ppd.id;
                    ppds.UserOrGroupId = ppd.projectManageruser__c;
                    ppds.AccessLevel = 'Edit';
                    ppds.RowCause = 'Manual';
                    InsertList.add(ppds);
                }
            }
        }
        if(InsertList.size() > 0){
            Insert InsertList;
        }
    }
}