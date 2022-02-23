/**
 * Created by tko18 on 2022/2/21.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 修改项目专家的访谈状态
*@Authortko18
*@Date 2022/2/21 16:22
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/ModifyAppointmentStatus')
global with sharing class DingTalk_ModifyAppointmentStatus {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespModifyAppointment respInfo = new RespModifyAppointment();
        try {
            RestModifyAppointment restInfo = (RestModifyAppointment) JSON.deserialize(requestBody, RestModifyAppointment.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespModifyAppointment decisionMakingOperation(RestModifyAppointment restInfo) {
        RespModifyAppointment respInfo = new RespModifyAppointment();
        if (String.isEmpty(restInfo.recordNumber) || String.isEmpty(restInfo.overallState)) {
            respInfo.msg = '参数必填！';
            return respInfo;
        }
        Project_expert__c projectExpert = [SELECT Id,interviewStatus__c,reason__c FROM Project_expert__c WHERE Name = :restInfo.recordNumber];
        if (Integer.valueOf(restInfo.overallState) == 0) {
            projectExpert.interviewStatus__c = '已约访';
            Database.update(projectExpert, false);
        }
        if (Integer.valueOf(restInfo.overallState) == 1) {
            projectExpert.interviewStatus__c = '拒绝(原因)';
            if (String.isEmpty(restInfo.refuseToReason)) {
                respInfo.msg = '拒绝原因必填！';
                return respInfo;
            } else {
                if (Integer.valueOf(restInfo.refuseToReason) == 0) {
                    projectExpert.reason__c = '不约访';
                }
                if (Integer.valueOf(restInfo.refuseToReason) == 1) {
                    projectExpert.reason__c = '专家不合适';
                }
                if (Integer.valueOf(restInfo.refuseToReason) == 2) {
                    projectExpert.reason__c = '无法联系上';
                }
                if (Integer.valueOf(restInfo.refuseToReason) == 3) {
                    projectExpert.reason__c = '拒绝';
                }
            }
            Database.update(projectExpert, false);
        }
        respInfo.code = 1;
        return respInfo;
    }
    global class RestModifyAppointment {
        public String recordNumber { get; set; }//项目专家编号
        public String overallState { get; set; }//0是以约访，1是拒绝
        public String refuseToReason { get; set; }//0~3是拒绝原因
    }
    global class RespModifyAppointment {
        public Integer code;
        public String msg;
        public RespModifyAppointment() {
            this.code = 0;
            this.msg = '';
        }
    }
}