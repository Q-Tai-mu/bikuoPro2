/**
 * Created by tko18 on 2022/2/21.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 填写沟通记录
*@Authortko18
*@Date 2022/2/21 16:56
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/CommunicationRecord')
global with sharing class DingTalk_CommunicationRecord {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespCommunicationInfo respInfo = new RespCommunicationInfo();
        try {
            RestCommunicationInfo restInfo = (RestCommunicationInfo) JSON.deserialize(requestBody, RestCommunicationInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespCommunicationInfo decisionMakingOperation(RestCommunicationInfo restInfo) {
        RespCommunicationInfo respInfo = new RespCommunicationInfo();
        adviser__c adviser = new adviser__c();
        Project_expert__c projectExpert = new Project_expert__c();
        Expert_management__c expertManagement = new Expert_management__c();
        if (String.isEmpty(restInfo.communicationContent)) {
            respInfo.msg = '参数必填！';
            return respInfo;
        }
        if (!String.isEmpty(restInfo.projectNumber)) {
            adviser = [SELECT Id FROM adviser__c WHERE projectNumber__c = :restInfo.projectNumber];
        }
        if (!String.isEmpty(restInfo.projectExpertsNumber)) {
            projectExpert = [SELECT Id FROM Project_expert__c WHERE Name = :restInfo.projectExpertsNumber];
        }
        if (!String.isEmpty(restInfo.expertsNumber)) {
            expertManagement = [SELECT Id FROM Expert_management__c WHERE ExpertID__c = :restInfo.expertsNumber];
        }

        CommunityRecord__c communityRecord = new CommunityRecord__c();
        communityRecord.project__c = adviser.Id != null ? adviser.Id : '';
        communityRecord.expert__c = expertManagement.Id != null ? expertManagement.Id : '';
        communityRecord.projectExpert__c = projectExpert.Id != null ? projectExpert.Id : '';
        communityRecord.content__c = restInfo.communicationContent;
        Database.insert(communityRecord, false);
        respInfo.code = 1;
        return respInfo;
    }
    global class RestCommunicationInfo {
        public String projectNumber { get; set; }//项目编号
        public String expertsNumber { get; set; }//专家ID
        public String projectExpertsNumber { get; set; }//项目专家编号
        public String communicationContent { get; set; }//内容
    }
    global class RespCommunicationInfo {
        public Integer code;
        public String msg;
        public RespCommunicationInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
}