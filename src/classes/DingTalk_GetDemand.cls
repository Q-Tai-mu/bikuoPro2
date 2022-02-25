/**
 * Created by tko18 on 2022/2/18.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 项目需求新增
*@Authortko18
*@Date 2022/2/18 15:04
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetDemand')
global with sharing class DingTalk_GetDemand {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespDemandInfo respInfo = new RespDemandInfo();
        try {
            RestDemandInfo restInfo = (RestDemandInfo) JSON.deserialize(requestBody, RestDemandInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespDemandInfo decisionMakingOperation(RestDemandInfo restInfo) {
        RespDemandInfo respInfo = new RespDemandInfo();
        if (String.isEmpty(restInfo.demandTheme) || String.isEmpty(restInfo.demandForContent) || String.isEmpty(restInfo.projectNumber)) {
            respInfo.msg = '请传递必填需求【需求主题】【需求】【项目编号】！';
            return respInfo;
        }
        adviser__c adviser = [SELECT Id FROM adviser__c WHERE projectNumber__c = :restInfo.projectNumber];
        Expert_demand__c expertDemand = new Expert_demand__c();
        expertDemand.Name = restInfo.demandTheme;
        expertDemand.project_Management__c = adviser.Id;
        expertDemand.command__c = restInfo.demandForContent;
        expertDemand.requireExpert__c = Integer.valueOf(restInfo.numberOfExperts);
        if (!String.isEmpty(restInfo.recordId)) {
            expertDemand.Id = restInfo.recordId;
        }
        Database.upsert(expertDemand, false);
        respInfo.code = 1;
        return respInfo;
    }
    global class RestDemandInfo {
        public String demandTheme { get; set; }
        public String projectNumber { get; set; }
        public String demandForContent { get; set; }
        public String numberOfExperts { get; set; }
        public String recordId { get; set; }

    }

    global class RespDemandInfo {
        public Integer code;
        public String msg;
        public RespDemandInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
}