trigger staffTrigger on staff__c (before insert,before update) {
     new Triggers()
    .bind(Triggers.Evt.beforeInsert,new StaffBeforeTriggerHandle())
    .bind(Triggers.Evt.beforeUpdate,new StaffBeforeTriggerHandle())
    .manage(); 
}