global class GetDingTalkUserInfoBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    public String query;
    public String token;

    global GetDingTalkUserInfoBatch(String query,String token) {
        this.token = token;
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<vlink__DING_User__c> userList) {
        List<vlink__DING_User__c> dingUserList = new List<vlink__DING_User__c>();
        for(vlink__DING_User__c dingUser:userList){
           boolean isUpdate = false;
           Map<String,String> userInfoMap = DingTalkUtil.GetDingTalkUserInfo(token,dingUser.vlink__User_ID__c);
           if(userInfoMap.containsKey('mobile') && userInfoMap.get('mobile') != dingUser.vlink__Mobile__c){
                dingUser.vlink__Mobile__c = userInfoMap.get('mobile');
                isUpdate = true;
           }
           if(userInfoMap.containsKey('avatar') && userInfoMap.get('avatar') != dingUser.vlink__Head_Image_Url__c){
                dingUser.vlink__Head_Image_Url__c = userInfoMap.get('avatar');
                isUpdate = true;
           }
           if(userInfoMap.containsKey('email') && userInfoMap.get('email') != dingUser.vlink__Email__c){
                dingUser.vlink__Email__c = userInfoMap.get('email');
                isUpdate = true;
           }
           if(userInfoMap.containsKey('dept_id') && userInfoMap.get('dept_id') != dingUser.Department__c){
                dingUser.Department__c = userInfoMap.get('dept_id');
                isUpdate = true;
           }
           if(userInfoMap.containsKey('title') && userInfoMap.get('title') != dingUser.vlink_Title__c){
                dingUser.vlink_Title__c = userInfoMap.get('title');
                isUpdate = true;
           }
           if(userInfoMap.containsKey('active') && userInfoMap.get('active') != dingUser.vlink__Mobile__c){
                dingUser.vlink__Active__c = boolean.valueOf(userInfoMap.get('active'));
                isUpdate = true;
           }
           if(isUpdate){
                dingUserList.add(dingUser);
           }
        }
        if(dingUserList.size() > 0){
            update dingUserList;
        }
    }

    global void finish(Database.BatchableContext BC) {

    }

}