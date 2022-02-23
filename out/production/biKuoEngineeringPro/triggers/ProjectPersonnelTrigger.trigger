trigger ProjectPersonnelTrigger on Project_personnel__c (Before insert, Before update, After insert) {
    new Triggers()
            .bind(Triggers.Evt.beforeinsert, new ProjectPersonnelBeforeTriggerHandler())
            .bind(Triggers.Evt.AfterInsert, new ProjectPersonnelAfterTriggerHandler())
            .manage();
}