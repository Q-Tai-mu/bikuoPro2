global class WorkDayHandleSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
    	for(Integer i=0;i<10;i++){
           generateWorkDay();
    	}
    }  
    global static void generateWorkDay(){
    	WorkDaySetting__c setting = [select id,WorkNumber__c,WorkStartDate__c,WorkEndDate__c from WorkDaySetting__c where name ='setWordDay' limit 1];
    	WorkDayObject__c workDay = new WorkDayObject__c();
    	workDay.weekStart__c = setting.WorkStartDate__c;
    	workDay.weekClose__c = setting.WorkEndDate__c;
    	if(setting.WorkNumber__c < 10){
    		workDay.WorkNumber__c = 'W0'+string.valueOf(setting.WorkNumber__c);
    	}else{
    		workDay.WorkNumber__c = 'W'+string.valueOf(setting.WorkNumber__c);
    	}
    	
    	workDay.year__c = String.valueOf(setting.WorkStartDate__c.year());
    	workDay.month__c = String.valueOf(setting.WorkStartDate__c.month());
    	workDay.name = workDay.year__c+'-'+workDay.WorkNumber__c+'('+workDay.weekStart__c.format()+'~'+workDay.weekClose__c.format()+')';
    	workDay.External_id__c = workDay.weekStart__c.format()+'_'+workDay.weekClose__c.format();
    	upsert workDay External_id__c;
    	setting.WorkNumber__c = setting.WorkNumber__c+1;
    	setting.WorkStartDate__c = setting.WorkStartDate__c+7;
    	setting.WorkEndDate__c = setting.WorkEndDate__c+7;
    	update setting;

    }
    //for(Integer i=0,i<10,i++){

    //}
    
}