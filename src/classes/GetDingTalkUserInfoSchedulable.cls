global class GetDingTalkUserInfoSchedulable implements Schedulable {
    public String token;
    global void execute(SchedulableContext sc) {
    	List<String> deptUseridList = new List<String>();
        token = DingTalkUtil.GetDingTalkToken();
        List<String> deptIdList = new List<String>{'117679169','117522279','117557330'};
        for(String deptId:deptIdList){
            List<String> deptUserList = DingTalkUtil.GetDingTalkDeptInfo(token,deptId);
            deptUseridList.addAll(deptUserList);
             
        }
        if(deptUseridList.size() > 0){
        	system.debug('deptUseridList'+deptUseridList);
            GetDeptUserBatch DeptUser = new GetDeptUserBatch(token,deptUseridList);
            database.executeBatch(DeptUser,20);
        }

    	
        String query = 'Select id,name,vlink__Active__c,vlink__Head_Image_Url__c,vlink__Mobile__c,'+
                        'vlink__Email__c,Department__c,vlink__User_ID__c,vlink_Title__c from vlink__DING_User__c';
        GetDingTalkUserInfoBatch userInfo = new GetDingTalkUserInfoBatch(query,token);
     	database.executeBatch(userInfo,10);
     	
    }
    
}