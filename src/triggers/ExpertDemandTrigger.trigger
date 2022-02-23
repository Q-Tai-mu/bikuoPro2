/**
 * Created by tko18 on 2022/2/14.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/14 15:33
*@Version:1.0.0
**/
trigger ExpertDemandTrigger on Expert_demand__c (before insert, before update, before delete, after insert, after update, after delete) {
    new Triggers()
            .bind(Triggers.Evt.afterinsert, new ExpertDemandTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterupdate, new ExpertDemandTotalAfterTriggerHandler())
            .bind(Triggers.Evt.afterdelete, new ExpertDemandTotalAfterTriggerHandler())
            .manage();
}