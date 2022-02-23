public with sharing class CostManagementAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
        List<Cost_management__Share> InsertList = new List<Cost_management__Share>();
    	if(Trigger.isAfter && Trigger.isInsert){
            for(Cost_management__c cost:(List<Cost_management__c>)Trigger.new){
            	if(cost.ProjectManageruser__c != null){
                    Cost_management__Share costManager = new Cost_management__Share();
                    costManager.ParentId = cost.id;
                    costManager.UserOrGroupId = cost.ProjectManageruser__c;
                    costManager.AccessLevel = 'Edit';
                    costManager.RowCause = 'Manual';
                    InsertList.add(costManager);
            	}
            }
            
        }else if(Trigger.isAfter && Trigger.isUpdate){
            for(Cost_management__c cost:(List<Cost_management__c>)Trigger.new){
                Cost_management__c oldCost = (Cost_management__c)Trigger.oldMap.get(cost.id);
                if(cost.ProjectManageruser__c != oldCost.ProjectManageruser__c && cost.ProjectManageruser__c != null){
                    Cost_management__Share costManager = new Cost_management__Share();
                    costManager.ParentId = cost.id;
                    costManager.UserOrGroupId = cost.ProjectManageruser__c;
                    costManager.AccessLevel = 'Edit';
                    costManager.RowCause = 'Manual';
                    InsertList.add(costManager);
                }
            }
        }
        if(InsertList.size() > 0){
            Insert InsertList;
        }
        
    }
}