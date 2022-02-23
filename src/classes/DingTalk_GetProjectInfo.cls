/**********************************************************************
 * 
 *
 * @url: /services/apexrest/DingTalk/GetProjectInfo
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/DingTalk/GetProjectInfo')
global with sharing class DingTalk_GetProjectInfo {

	global class AppInput{
        public String userId;
        public String projectName;
        public String fileName;
        public String startDate;
        public String endDate;

    }
    
    global class AppOutput{
        public String status;             //200成功，500部分失败，501全失败
        public String msg;                //接收失败原因
        public List<ProjectInfo> projectInfoList; //返回查询的Account List
    }
    global class ProjectInfo{
        public String projectNumber;
		public String projectName;
		public String BU;
		public String projectStartDate;
		public String projectEndDate;
		public String projectStatus;
		public String demandNumber;
		public String expertNumber;
		public String chooseExpert;
		public String interviewExpert;
    }
    @HttpPost
    global static AppOutput doPost() {
        AppOutput out = new AppOutput();  
        AppInput input = new AppInput(); 
        List<ProjectInfo> projectInfoList = new List<ProjectInfo>();
        out.status = '200';
        out.msg = '接收信息成功!'; 
        try{
            RestRequest req = RestContext.request;
            System.debug('req.requestBody'+ req.requestBody.toString()); 
            input = (DingTalk_GetProjectInfo.AppInput)JSON.deserialize(req.requestBody.toString(), DingTalk_GetProjectInfo.AppInput.class);
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
            List<adviser__c> ProjectList = [select id, 
                                            projectNumber__c,
                                            Name,
                                            BU__c,
                                            projectStart__c,
                                            projectStop__c,
                                            projectStatus__c,
                                            demandNumber__c,
                                            expertNumber__c,
                                            chooseExpert__c,
                                            interviewExpert__c from adviser__c limit 10];
            if(!ProjectList.isEmpty()){
                for(adviser__c ad:ProjectList){
                    projectInfo projectInfo = new projectInfo();
                    projectInfo.projectNumber = ad.projectNumber__c;
                    projectInfo.projectName = ad.Name;
                    projectInfo.BU = ad.BU__c;
                    projectInfo.projectStartDate = String.valueOf(ad.projectStart__c);
                    projectInfo.projectEndDate = String.valueOf(ad.projectStop__c);
                    projectInfo.projectStatus = String.valueOf(ad.projectStatus__c);
                    projectInfo.demandNumber = String.valueOf(ad.demandNumber__c);
                    projectInfo.expertNumber = String.valueOf(ad.expertNumber__c);
                    projectInfo.chooseExpert = String.valueOf(ad.chooseExpert__c);
                    projectInfo.interviewExpert = String.valueOf(ad.interviewExpert__c);
                    projectInfoList.add(projectInfo);
                }
            }
            out.projectInfoList = projectInfoList;
            System.debug(out);   
            return out;
            
        }catch(Exception e){
            out.status = '501';
            out.msg = 'sfdc中DML错误:' + e.getMessage() + e.getLineNumber(); 
            System.debug(out);  
            return out;
        }
    }
}