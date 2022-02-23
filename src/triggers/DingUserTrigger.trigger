trigger DingUserTrigger on vlink__DING_User__c (before insert,before update) {
         new Triggers()
        .bind(Triggers.Evt.beforeinsert, new DingUserBeforeTriggerHandle())
        .bind(Triggers.Evt.beforeupdate, new DingUserBeforeTriggerHandle())
        .manage();
}