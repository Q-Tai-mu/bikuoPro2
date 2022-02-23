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
        public List<String> userId;
    }
    
    global class AppOutput{
        public String status;             //200成功，500部分失败，501全失败
        public String msg;                //接收失败原因
        public List<ProjectInfo> projectList; //返回查询的Account List
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
        List<ProjectInfo> projectList = new List<ProjectInfo>();
        out.status = '200';
        out.msg = '接收信息成功!'; 
        try{
            RestRequest req = RestContext.request;
            System.debug(req.requestBody.toString()); 
            input = (DingTalk_GetProjectInfo.AppInput)JSON.deserialize(req.requestBody.toString(), DingTalk_GetProjectInfo.AppInput.class);
            system.debug('input:-->>'+input);     
            if(input.userId == null || input.userId.isEmpty()){
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
        

        return out;
    }
}