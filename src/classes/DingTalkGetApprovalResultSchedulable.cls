//String sch = '0 10 * * * ?';
//DingTalkGetApprovalResultSchedulable schedulable = new DingTalkGetApprovalResultSchedulable();
//system.schedule('每5分钟获取审批状态', sch, sh1);
global class DingTalkGetApprovalResultSchedulable implements Schedulable,Database.AllowsCallouts {
    global void execute(SchedulableContext sc) {
        DingTalkGetApprovalResultBatch batch = new DingTalkGetApprovalResultBatch();
        database.executeBatch(batch,1);
    }
}