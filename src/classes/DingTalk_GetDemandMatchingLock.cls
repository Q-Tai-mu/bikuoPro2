/**
 * Created by tko18 on 2022/2/21.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 给项目专家增加 项目专家需求
*@Authortko18
*@Date 2022/2/21 15:15
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetDemandMatchingLock')
global with sharing class DingTalk_GetDemandMatchingLock {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespDemandMatchingInfo respInfo = new RespDemandMatchingInfo();
        try {
            RestDemandMatchingInfo restInfo = (RestDemandMatchingInfo) JSON.deserialize(requestBody, RestDemandMatchingInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespDemandMatchingInfo decisionMakingOperation(RestDemandMatchingInfo restInfo) {
        RespDemandMatchingInfo respInfo = new RespDemandMatchingInfo();
        if (String.isEmpty(restInfo.recordNumber) || String.isEmpty(restInfo.recordId)) {
            respInfo.msg = '参数必填！';
            return respInfo;
        }
        Project_expert__c projectExpert = [SELECT Id FROM Project_expert__c WHERE Name = :restInfo.recordNumber];
        if (projectExpert == null) {
            respInfo.msg = '无法查找到项目专家！';
            return respInfo;
        }
        ProjectExpertDemand__c projectExpertDemand = new ProjectExpertDemand__c();
        projectExpertDemand.projectExpert__c = projectExpert.Id;
        projectExpertDemand.Field1__c = restInfo.recordId;
        Database.insert(projectExpertDemand, false);
        respInfo.code = 1;
        return respInfo;
    }
    global class RestDemandMatchingInfo {
        public String recordNumber { get; set; }//项目专家编号
        public String recordId { get; set; }//专家需求ID
    }

    global class RespDemandMatchingInfo {
        public Integer code;
        public String msg;

        public RespDemandMatchingInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
}