/**
 * Created by tko18 on 2022/2/21.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 新建访谈 复制项目专家
*@Authortko18
*@Date 2022/2/21 15:49
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetReplicationProjectSpecialist')
global with sharing class DingTalk_GetReplicationProjectSpecialist {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespReplicationInfo respInfo = new RespReplicationInfo();
        try {
            RestReplicationInfo restInfo = (RestReplicationInfo) JSON.deserialize(requestBody, RestReplicationInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespReplicationInfo decisionMakingOperation(RestReplicationInfo restInfo) {
        RespReplicationInfo respInfo = new RespReplicationInfo();
        if (String.isEmpty(restInfo.projectNumber) || String.isEmpty(restInfo.expertsNumber)) {
            respInfo.msg = '参数必填！';
            return respInfo;
        }
        adviser__c adviser = [SELECT Id FROM adviser__c WHERE projectNumber__c = :restInfo.projectNumber];
        if (adviser == null) {
            respInfo.msg = '项目并不存在！';
            return respInfo;
        }
        Expert_management__c expertManagement = [SELECT Id FROM Expert_management__c WHERE ExpertID__c = :restInfo.expertsNumber];
        if (expertManagement == null) {
            respInfo.msg = '专家并不存在！';
            return respInfo;
        }
        Project_expert__c projectExpert = new Project_expert__c();
        projectExpert.projectName__c = adviser.Id;
        projectExpert.expertName__c = expertManagement.Id;
        Database.insert(projectExpert, false);
        respInfo.code = 1;
        return respInfo;
    }
    global class RestReplicationInfo {
        public String projectNumber { get; set; }//项目编号
        public String expertsNumber { get; set; }//专家ID
    }

    global class RespReplicationInfo {
        public Integer code;
        public String msg;

        public RespReplicationInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
}