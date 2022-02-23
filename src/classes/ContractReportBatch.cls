global class ContractReportBatch implements Database.Batchable<sObject> {
    public String query;

    global ContractReportBatch(String query) {
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Contract> contractList) {
        for(Contract con:contractList){

            ToolUtil.SendEmailTemplate('',con.id,con.id,new List<string>{});
        }
        
    }

    global void finish(Database.BatchableContext BC) {

    }
}