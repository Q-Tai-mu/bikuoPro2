trigger CostManagementTrigger on Cost_management__c (after insert, before update, after update, after delete ) {
    new Triggers()
            .bind(Triggers.Evt.beforeupdate, new CostManagementPoBeforeTriggerHandler())
            .bind(Triggers.Evt.beforeupdate, new CostManagementBeforeTriggerHandler())
            .bind(Triggers.Evt.afterupdate, new CostManagementExpAfterTriggerHandler())
            .bind(Triggers.Evt.AfterInsert, new CostManagementAfterTriggerHandler())
            .bind(Triggers.Evt.afterinsert, new CostManagementTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterupdate, new CostManagementTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterdelete, new CostManagementTotalAfterTriggerHandler())
            .manage();
}