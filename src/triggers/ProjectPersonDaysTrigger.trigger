trigger ProjectPersonDaysTrigger on Project_person_days__c (After insert, before update, after delete ) {
    new Triggers()
            .bind(Triggers.Evt.beforeupdate, new ProjectPersonDaysBeforeTriggerHandler())
            .bind(Triggers.Evt.AfterInsert, new ProjectPersonDaysAfterTriggerHandler())

            .manage();
}