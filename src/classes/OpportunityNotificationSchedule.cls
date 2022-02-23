global class OpportunityNotificationSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        Date alertDate = date.today().adddays(-30);
        List<Opportunity> updateOppoList = new List<Opportunity>();
        for(Opportunity oppo:[Select id,stageUpdateTime__c,alert__c from Opportunity where stageUpdateTime__c =: alertDate]){
            oppo.alert__c = true;
            updateOppoList.add(oppo);
        }
        if(updateOppoList.size() > 0){
            update updateOppoList;
        }
    }
}