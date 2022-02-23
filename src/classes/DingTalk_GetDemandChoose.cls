/**
 * Created by tko18 on 2022/2/21.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 找到项目专家-项目-专家需求
*@Authortko18
*@Date 2022/2/21 14:56
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetDemandChoose')
global with sharing class DingTalk_GetDemandChoose {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespDemandCInfo respInfo = new RespDemandCInfo();
        try {
            RestDemandCInfo restInfo = (RestDemandCInfo) JSON.deserialize(requestBody, RestDemandCInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespDemandCInfo decisionMakingOperation(RestDemandCInfo restInfo) {
        RespDemandCInfo respInfo = new RespDemandCInfo();
        respInfo.eDemands = new List<Demand>();
        if (String.isEmpty(restInfo.recordNumber)) {
            respInfo.msg = '项目专家编号缺失！';
            return respInfo;
        }
        Project_expert__c projectExpert = [SELECT Id,projectName__c FROM Project_expert__c WHERE Name = :restInfo.recordNumber];
        if (projectExpert == null) {
            respInfo.msg = '项目专家编号不正确无法查询到结果！查询结果为null';
            return respInfo;
        }
        List<Expert_demand__c> expertDemands = [SELECT Id,Name FROM Expert_demand__c WHERE project_Management__c = :projectExpert.projectName__c];
        if (expertDemands.isEmpty()) {
            respInfo.msg = '无法找到项目专家管理的项目下的专家需求！查询结果为null';
            return respInfo;
        }
        if (!expertDemands.isEmpty()) {
            for (Expert_demand__c expertDemand : expertDemands) {
                Demand demand = new Demand();
                demand.recordId = expertDemand.Id;
                demand.recordName = expertDemand.Name;
                respInfo.eDemands.add(demand);
            }
        }
        respInfo.code = 1;
        return respInfo;
    }
    global class RestDemandCInfo {
        public String recordNumber { get; set; }//项目专家编号

    }
    global class RespDemandCInfo {
        public Integer code;
        public String msg;
        public List<Demand> eDemands;

        public RespDemandCInfo() {
            this.code = 0;
            this.msg = '';
        }

    }
    global class Demand {
        public String recordId { get; set; }
        public String recordName { get; set; }
    }
}