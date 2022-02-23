/**
 * Created by tko18 on 2022/2/14.
 */
/**
*@ClassName:Lin-Tui
*@Description:
*@Authortko18
*@Date 2022/2/14 15:04
*@Version:1.0.0
**/
trigger ProjectExpertTrigger on Project_expert__c (before insert, before update, before delete, after insert, after update, after delete) {
    new Triggers()
            .bind(Triggers.Evt.afterinsert, new ProjectExpertTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterupdate, new ProjectExpertTotalAfterTriggerHandler())
            .bind(TriggerS.Evt.afterdelete, new ProjectExpertTotalAfterTriggerHandler())
            .manage();
}