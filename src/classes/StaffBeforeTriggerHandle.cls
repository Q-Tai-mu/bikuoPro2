public with sharing class StaffBeforeTriggerHandle implements Triggers.Handler {
    public void handle() {
        List<string> staffTitleList = new List<string>();
        Map<string,string> rateMap = new Map<string,string>();
        if(Trigger.isBefore && Trigger.isInsert){
            for(staff__c staff:(List<staff__c>)Trigger.new){
                if(staff.title__c != null && staff.level__c == null){
                    staffTitleList.add(staff.title__c);
                }
            }
            for(Schedule_Of_rates__c rate:[select id,title__c from Schedule_Of_rates__c ]){
                if(rate.title__c.contains(';')){
                    for(String tittleString:rate.title__c.split(';')){
                        rateMap.put(tittleString,rate.id);
                    }
                }else{
                    rateMap.put(rate.title__c,rate.id);
                }
                
            } 
            for(staff__c staff:(List<staff__c>)Trigger.new){
                if(rateMap.containsKey(staff.title__c) && rateMap.get(staff.title__c) != null){
                    staff.level__c = rateMap.get(staff.title__c);
                }
            }
        }else if(Trigger.isBefore && Trigger.isUpdate){
            for(staff__c staff:(List<staff__c>)Trigger.new){
                staff__c oldStaff = (staff__c)Trigger.oldMap.get(staff.id);
                if(oldStaff.title__c != staff.title__c){
                    staffTitleList.add(staff.title__c);
                }
            }
            for(Schedule_Of_rates__c rate:[select id,title__c from Schedule_Of_rates__c ]){
                if(rate.title__c.contains(';')){
                    for(String tittleString:rate.title__c.split(';')){
                        rateMap.put(tittleString,rate.id);
                    }
                }else{
                    rateMap.put(rate.title__c,rate.id);
                }
            } 
            system.debug('rateMap'+rateMap);
            for(staff__c staff:(List<staff__c>)Trigger.new){
                if(rateMap.containsKey(staff.title__c) && rateMap.get(staff.title__c) != null){
                    staff.level__c = rateMap.get(staff.title__c);
                }
            }
        }
    }
}