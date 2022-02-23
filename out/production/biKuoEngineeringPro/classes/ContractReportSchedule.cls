global class ContractReportSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
    	String query = '';
    	ContractReportBatch cpBatch = new ContractReportBatch(query);
        Database.executeBatch(cpBatch,200);
    }
}