global class DingTalkGetApprovalResultBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    public String token;

    global DingTalkGetApprovalResultBatch() {
        //this.query = query;
        token = DingTalkUtil.GetDingTalkToken();
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id,Request_Id__c from Expert_management__c where status__c ='审批中' and Request_Id__c != null]);
    }

    global void execute(Database.BatchableContext BC, list<Expert_management__c> expertList) {
        List<Expert_management__c> updateEx = new List<Expert_management__c>();
        for(Expert_management__c expert: expertList){
            Map<String,String> resultMap = DingTalkUtil.getDingApprovalResult(expert.Request_Id__c,token);
            if(resultMap.size() > 0 && resultMap.get('status') == 'COMPLETED'){
                if(resultMap.get('result') == 'agree'){
                    Expert_management__c ex = new Expert_management__c();
                    ex.id = expert.id;
                    ex.status__c = '已审批';
                    updateEx.add(ex);
                }
                if(resultMap.get('result') == 'refuse'){
                    Expert_management__c ex = new Expert_management__c();
                    ex.id = expert.id;
                    ex.status__c = '已拒绝';
                    updateEx.add(ex);
                }

            }
               
        }
        if(updateEx.size() > 0){
            update updateEx;
        }
        
    }

    global void finish(Database.BatchableContext BC) {

    }
}