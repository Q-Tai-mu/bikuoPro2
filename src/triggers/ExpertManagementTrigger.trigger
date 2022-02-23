trigger ExpertManagementTrigger on Expert_management__c (after update) {
     new Triggers()
    .bind(Triggers.Evt.afterUpdate,new ExpertManagementAfterTriggerHandler())
    .manage();
}