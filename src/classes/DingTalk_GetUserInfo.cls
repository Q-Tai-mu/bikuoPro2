/**********************************************************************
 * 
 *
 * @url: /services/apexrest/DingTalk/GetUserInfo
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/DingTalk/GetUserInfo')
global without sharing class DingTalk_GetUserInfo {


	global class AppInput{
        public String userId;
    }
    
    global class AppOutput{
        public String status;             //200成功，500部分失败，501全失败
        public String msg;                //接收失败原因
        public String userName;
        public String userTitle;
        public String userImage;
    }
    @HttpPost
    global static AppOutput doPost() {
    	AppOutput out = new AppOutput();  
        AppInput input = new AppInput(); 
        out.status = '200';
        out.msg = '接收信息成功!'; 
        try{
            RestRequest req = RestContext.request;
            System.debug('req.requestBody'+ req.requestBody.toString()); 
            input = (DingTalk_GetUserInfo.AppInput)JSON.deserialize(req.requestBody.toString(), DingTalk_GetUserInfo.AppInput.class);
            system.debug('input:-->>'+input);     
            if(input.userId == null || input.userId == '' ){
                out.status = '501';
                out.msg = '传输的数据为空，请重新检验传输的json字符串是否正确！';
                System.debug(out);
                return out;  
            }
        }catch(Exception ex){
           out.status = '501';
           out.msg = 'json 字符串解析失败！' + ex.getMessage() ;  
           return out;
        }
        try{
        	for(vlink__DING_User__c dingUser:[select id,Name,vlink__Head_Image_Url__c,vlink_Title__c from vlink__DING_User__c where vlink__User_ID__c =: input.userId]){
                out.userName = dingUser.name;
                out.userImage = dingUser.vlink__Head_Image_Url__c;
                out.userTitle = dingUser.vlink_Title__c;
        	}
        	return out;
        }catch(Exception e){
            out.status = '501';
            out.msg = 'sfdc中DML错误:' + e.getMessage() + e.getLineNumber(); 
            System.debug(out);  
            return out;
        }
        
    }
}