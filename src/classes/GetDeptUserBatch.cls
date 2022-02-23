global class GetDeptUserBatch implements Database.Batchable<String>,Database.AllowsCallouts{
    public List<string> requestIdList;
    public String Token;
    global GetDeptUserBatch(String token,List<string> requestIdList) {
        this.requestIdList = requestIdList;
        this.token = token;
    }

    global Iterable<String> start(Database.BatchableContext bc) {
        return requestIdList;
    }

    global void execute(Database.BatchableContext BC, list<String> deptUserIdList) {
        List<staff__c> staffList = new List<staff__c>();
        for(String deptUser:deptUserIdList){
                Map<String,String> userInfoMap = DingTalkUtil.GetDingTalkUserInfo(token,deptUser);
                System.debug('userInfoMap'+userInfoMap);
                staff__c sta = new staff__c();
                sta.Title__c = userInfoMap.get('title');
                sta.Leave__c = userInfoMap.get('active') == 'true'?'是':'否';
                sta.Email__c = userInfoMap.get('email');
                sta.Department__c = userInfoMap.get('dept_id');
                sta.External_id__c = deptUser;
                sta.name = userInfoMap.get('name');
                staffList.add(sta);
        }
        if(staffList.size() > 0){
            upsert staffList External_id__c;
        }
        
    }

    global void finish(Database.BatchableContext BC) {

    }
}