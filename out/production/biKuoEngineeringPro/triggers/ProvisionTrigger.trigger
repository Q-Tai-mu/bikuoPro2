/**
 * Created by tko18 on 2022/2/14.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/14 14:22
*@Version:1.0.0
**/
trigger ProvisionTrigger on Provision__c (before insert, before update, before delete, after insert, after update, after delete) {
    new Triggers()
            .bind(Triggers.Evt.afterinsert, new ProvisionTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterupdate, new ProvisionTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterdelete, new ProvisionTotalAfterTriggerHandler())
            .manage();
}