trigger ContractTrigger on Contract (before insert, before update) {
    new Triggers()
    .bind(Triggers.Evt.beforeInsert,new ContractBeforeTriggerHandler())
    .manage();  
}