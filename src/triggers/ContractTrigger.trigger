trigger ContractTrigger on Contract (before insert, before update, after insert, after update ) {
    new Triggers()
            .bind(Triggers.Evt.beforeInsert, new ContractBeforeTriggerHandler())
            .bind(Triggers.Evt.beforeinsert, new ContractAfterTriggerHandler())
            .bind(Triggers.Evt.beforeupdate, new ContractAfterTriggerHandler())
            .manage();
}