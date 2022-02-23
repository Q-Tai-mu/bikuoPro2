global class ContractReportSchedula implements Schedulable {
    global void execute(SchedulableContext sc) {
    	Date drafReportDate = date.today().adddays(2);
    	Date frameReportDate = date.today().adddays(5);
    	List<Contract> updateContractList = new List<Contract>();
        List<Contract> contractList = [Select id,alertDraft__c,alert__c,endDate__c from Contract where 
                                        ( alert__c = false      and endDate__c =: frameReportDate and FrameReportStatus__c = '草稿') or
                                        ( alertDraft__c = false and endDate__c =: drafReportDate  and DraftReportStatus__c = '草稿')];
       for(Contract con:contractList){
            if(con.endDate__c == frameReportDate){
                con.alert__c = true;
            }
            if(con.endDate__c == drafReportDate){
                con.alertDraft__c = true;
            }
       	    updateContractList.add(con);  
       }
       if(updateContractList.size() > 0){
            update updateContractList;
       }
    }
}