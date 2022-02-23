public with sharing class DingTalkUtil {
    public static String appkey = 'dingkadrjngwvsnajvre';
    public static String appsecret = 'ShHWzpzAh6402m6e_n-zn9oaKp0EbLB1P369HCqOvmwLZOw5FieTP0eAJkR_ufB6';
    public static String tokenEndpoint = 'https://oapi.dingtalk.com/gettoken';
    public static String userEndpoint = 'https://oapi.dingtalk.com/topapi/v2/user/get';
    public static String deptEndpoint = 'https://oapi.dingtalk.com/user/getDeptMember';
    public static String approvalEndpoint = 'https://oapi.dingtalk.com/topapi/processinstance/create';
    public static String approvalResultEndpoint = 'https://oapi.dingtalk.com/topapi/processinstance/get';
    public static List<string> nameList = new List<string>{'专家','公司','职位','专家费率/小时','币种','注册人','点击链接查看专家详细信息'};

    public static String GetDingTalkToken(){
    	    String token ='';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            String endPoint_Oauth = tokenEndpoint+'?appkey='+ appkey+'&appsecret='+appsecret;
            request.setEndpoint(endPoint_Oauth);
            request.setMethod('GET');
            request.setTimeout(30000);
            response = http.send(request);
            system.debug('response'+response.getBody());
            if(response.getStatusCode() == 200){
            	JSONParser parser = JSON.createParser(response.getBody());
		        while (parser.nextToken() != null) {
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
		                parser.nextToken();
		                token = String.valueOf(parser.getText());
		            }

		        }
            }
            system.debug('token'+token);
            return token;

    }
    public static Map<String,String> GetDingTalkUserInfo(String token, String userid){
    	    Map<String,String> userInfoMap = new Map<String,String>();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            String endPoint_User = userEndpoint+'?access_token='+ token+'&userid='+userid;
            request.setEndpoint(endPoint_User);
            request.setMethod('GET');
            request.setTimeout(30000);
            response = http.send(request);
            system.debug('response'+response.getBody());
            if(response.getStatusCode() == 200){
            	JSONParser parser = JSON.createParser(response.getBody());
		        while (parser.nextToken() != null) {
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'mobile')) {
		                parser.nextToken();
		                userInfoMap.put('mobile',String.valueOf(parser.getText()));
		            }
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'avatar')) {
		                parser.nextToken();
		                userInfoMap.put('avatar',String.valueOf(parser.getText()));
		            }
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'email')) {
		                parser.nextToken();
		                userInfoMap.put('email',String.valueOf(parser.getText()));
		            }
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'dept_id')) {
		                parser.nextToken();
		                userInfoMap.put('dept_id',String.valueOf(parser.getText()));
		            }
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'title')) {
		                parser.nextToken();
		                userInfoMap.put('title',String.valueOf(parser.getText()));
		            }
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'active')) {
		                parser.nextToken();
		                userInfoMap.put('active',String.valueOf(parser.getText()));
		            }
		            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'name') ) {
		                parser.nextToken();
		                if(!userInfoMap.containsKey('name')){
		                	userInfoMap.put('name',String.valueOf(parser.getText()));
		                }
		                
		            }

		        }
            }
            return userInfoMap;

    }
    public static List<String> GetDingTalkDeptInfo(String token, string deptId){
    	    List<String> deptList = new List<String>();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            String endPoint_Dept = deptEndpoint+'?access_token='+ token+'&deptId='+deptId;
            request.setEndpoint(endPoint_Dept);
            request.setMethod('GET');
            request.setTimeout(30000);
            response = http.send(request);
            system.debug('response'+response.getBody());
            if(response.getStatusCode() == 200){
            	deptInfo deptInfos = (deptInfo)JSON.deserialize(response.getBody(), deptInfo.class);
            	deptList = deptInfos.userIds;

            }
            system.debug('deptList'+deptList);
            return deptList;

    }
    public class deptInfo{
        public Integer errcode;
        public String errmsg;
        public List<string> userIds;


    } 
    @future(callout = true)
    public static void sendDingTalkApprovel(List<string> expertidList){
        String Token = DingTalkUtil.GetDingTalkToken();
        //String Token ='920c2d3f44953fdf9b5173e60c4da4c4';
        List<Expert_management__c> updateEMList = new List<Expert_management__c>();
        for(Expert_management__c em:[select id,name,expertCharge2__c,expertCharge1__c,register__c,register__r.name,title__c,company__c,DingDing_Submitter__c,DingDing_Submitter__r.External_id__c,DingDing_Submitter__r.Department__c from Expert_management__c where id in:expertidList]){
            List<formValue> fromList = new List<formValue>();
            for(string nameStr:nameList){
                formValue form = new formValue();
                form.name = nameStr;
                if(nameStr =='专家'){
                   form.value = em.name; 
                }
                if(nameStr =='公司' ){
                   form.value = em.company__c; 
                }
                if(nameStr =='职位'){
                   form.value = em.title__c; 
                }
                if(nameStr =='注册人'){
                   form.value = em.register__r.name; 
                }
                if(nameStr =='专家费率/小时' ){
                   form.value = string.valueOf(em.expertCharge1__c); 
                }
                if(nameStr =='币种' ){
                   form.value = em.expertCharge2__c; 
                }
                if(nameStr =='点击链接查看专家详细信息'){
                   form.value = 'www.bai.com';
                }
                
                fromList.add(form);
            }
            approvalInfo requestBody = new approvalInfo();
            requestBody.dept_id = em.DingDing_Submitter__r.Department__c;
            requestBody.originator_user_id = em.DingDing_Submitter__r.External_id__c;
            requestBody.form_component_values = fromList;
            system.debug('requestBody'+json.serialize(requestBody).replace('null','""'));
            Map<string,string> approvalResultMap = requestApprovalInfo(json.serialize(requestBody).replace('null','""'),Token);
            if(approvalResultMap.size() > 0){
                system.debug(approvalResultMap);
                Expert_management__c updateEM = new Expert_management__c();
                updateEM.id = em.id;
                updateEM.Request_Id__c = approvalResultMap.get('process_instance_id');
                updateEMList.add(updateEM);
            }

        }
        if(updateEMList.size() > 0){
            update updateEMList;
        }

    }
    public  class approvalInfo{
        public  String agent_id = '1464687714';
        public  String process_code = 'PROC-30D378BE-246C-474C-B2EF-2E384ECCA618';
        public  String dept_id ;
        public  String originator_user_id ;
        public  List<formValue> form_component_values;
    }
    public class formValue{
        public  String name;
        public  String value;
    }
    public static Map<String,String> requestApprovalInfo(String requestBody,String token){
        Map<string,string> approvalResultMap = new Map<string,string>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String endPoint_Approval = approvalEndpoint+'?access_token='+ token;
        request.setEndpoint(endPoint_Approval);
        request.setMethod('POST');
        request.setTimeout(30000);
        request.setBody(requestBody);
        request.setHeader('Content-Type', 'application/json');
        response = http.send(request);
        system.debug('response'+response.getBody());
        if(response.getStatusCode() == 200){
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'process_instance_id')) {
                    parser.nextToken();
                    approvalResultMap.put('process_instance_id',String.valueOf(parser.getText()));
                }
            }
        }
        return approvalResultMap;
    }
    public  static Map<String,String> getDingApprovalResult(String processCode ,String token){
        Map<string,string> approvalResultMap = new Map<string,string>();
        Http http = new Http();
        processInfo requestBody = new processInfo();
        requestBody.process_instance_id = processCode;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        String approvalResultEndpoint = approvalResultEndpoint+'?access_token='+ token;
        request.setEndpoint(approvalResultEndpoint);
        request.setMethod('POST');
        request.setTimeout(30000);
        request.setBody(json.serialize(requestBody));
        request.setHeader('Content-Type', 'application/json');
        response = http.send(request);
        if(response.getStatusCode() == 200){
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
                    parser.nextToken();
                    approvalResultMap.put('status',String.valueOf(parser.getText()));
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'result')) {
                    parser.nextToken();
                    approvalResultMap.put('result',String.valueOf(parser.getText()));
                }
            }
        }
        return approvalResultMap;
    }
    public  class processInfo {
        public string process_instance_id;
    }
}