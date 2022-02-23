/**
 * Created by tko18 on 2022/2/22.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 返回项目专家详情加相关信息
*@Authortko18
*@Date 2022/2/22 11:04
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/ExpertInterviewReport')
global with sharing class DingTalk_ExpertInterviewReport {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespExpertInterviewInfo respInfo = new RespExpertInterviewInfo();
        try {
            RestExpertInterviewInfo restInfo = (RestExpertInterviewInfo) JSON.deserialize(requestBody, RestExpertInterviewInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespExpertInterviewInfo decisionMakingOperation(RestExpertInterviewInfo restInfo) {
        RespExpertInterviewInfo respInfo = new RespExpertInterviewInfo();
        if (String.isEmpty(restInfo.recordNumber)) {
            respInfo.msg = '请填写必填参数!';
            return respInfo;
        }
        Project_expert__c projectExpert = [
                SELECT Id,
                        projectName2__c,
                        expertName__r.Name,
                        expertCompany__c,
                        title__c,
                        telephone__c, (
                        SELECT Id,
                                Field1__r.Name
                        FROM ProjectExpertDemand__r
                ),
                        Recruiter__c,
                        Analyst__r.Name,
                        interviewStatus__c, (
                        SELECT Id,
                                startTime__c,
                                closeTime__c,
                                actualPhoneTime__c,
                                chargeTimeMinute__c,
                                expertCharge__c,
                                expertChargeMoney__c,
                                expertChargeMoneyRMB__c,
                                participant__c,
                                paymMethod__c,
                                payment__c,
                                urgent__c,
                                charge_chargeAccount__c,
                                chargeRemark__c,
                                mark__c,
                                attitude__c,
                                communicate__c,
                                facts__c,
                                insights__c
                        FROM Charge_Expert__r
                ),
                        payStatus__c, (SELECT Id,user__r.Name,time__c,content__c FROM CommunityRecord__r)
                FROM Project_expert__c
                WHERE Name = :restInfo.recordNumber
        ];
        if (projectExpert == null) {
            respInfo.msg = '无法查询到相关记录!';
            return respInfo;
        }
        ExpertInterview expertInterview = new ExpertInterview();
        expertInterview.projectName = projectExpert.projectName2__c;
        expertInterview.expertsName = projectExpert.expertName__r.Name;
        expertInterview.companyOfAffiliation = projectExpert.expertCompany__c;
        expertInterview.position = projectExpert.title__c;
        expertInterview.phone = projectExpert.telephone__c;
        if (projectExpert.ProjectExpertDemand__r.size() > 0) {
            for (ProjectExpertDemand__c projectExpertDemand : (List<ProjectExpertDemand__c>) projectExpert.ProjectExpertDemand__r) {
                expertInterview.requirements += projectExpertDemand.Field1__r.Name + ',';
            }
        }
        expertInterview.recruiter = projectExpert.Recruiter__c;
        expertInterview.analyst = projectExpert.Analyst__r.Name;
        expertInterview.terViewStatus = projectExpert.interviewStatus__c;
        InterviewFee interviewFee = new InterviewFee();
        interviewFee.paymentStatus = projectExpert.payStatus__c;
        if (projectExpert.Charge_Expert__r.size() > 0) {
            List<Cost_management__c> chargeExperts = (List<Cost_management__c>) projectExpert.Charge_Expert__r;
            interviewFee.interviewStartDate = String.valueOf(chargeExperts[0].startTime__c);
            interviewFee.interviewEndDate = String.valueOf(chargeExperts[0].closeTime__c);
            interviewFee.actualDurationMinuter = String.valueOf(chargeExperts[0].actualPhoneTime__c);
            interviewFee.chargingDurationMinuter = String.valueOf(chargeExperts[0].chargeTimeMinute__c);
            interviewFee.expertProjectRateHours = String.valueOf(chargeExperts[0].expertCharge__c);
            interviewFee.expertFeeAmount = String.valueOf(chargeExperts[0].expertChargeMoney__c);
            interviewFee.expertFeeAmountRMB = String.valueOf(chargeExperts[0].expertChargeMoneyRMB__c);
            interviewFee.participantsThe = String.valueOf(chargeExperts[0].participant__c);
            interviewFee.termsOfPayment = String.valueOf(chargeExperts[0].paymMethod__c);
            interviewFee.whetherPayment = String.valueOf(chargeExperts[0].payment__c);
            interviewFee.urgent = String.valueOf(chargeExperts[0].urgent__c);
            interviewFee.whetherChargeCustomers = String.valueOf(chargeExperts[0].charge_chargeAccount__c);
            interviewFee.feeNote = String.valueOf(chargeExperts[0].chargeRemark__c);
            interviewFee.score = String.valueOf(chargeExperts[0].mark__c);
            interviewFee.activeCooperate = String.valueOf(chargeExperts[0].attitude__c);
            interviewFee.activeLogical = String.valueOf(chargeExperts[0].communicate__c);
            interviewFee.activeFacts = String.valueOf(chargeExperts[0].facts__c);
            interviewFee.activeInsights = String.valueOf(chargeExperts[0].insights__c);
        }
        if (projectExpert.CommunityRecord__r.size() > 0) {
            List<CommunicationHistory> communicationHistories = new List<CommunicationHistory>();
            for (CommunityRecord__c communityRecord : (List<CommunityRecord__c>) projectExpert.CommunityRecord__r) {
                CommunicationHistory communicationHistory = new CommunicationHistory();
                communicationHistory.allNames = communityRecord.user__r.Name;
                communicationHistory.submitTime = String.valueOf(communityRecord.time__c);
                communicationHistory.communicationContent = communityRecord.content__c;
                communicationHistories.add(communicationHistory);
            }
            expertInterview.communicationHistories = communicationHistories;
        }
        expertInterview.interviewFee = interviewFee;
        respInfo.expertInterview = expertInterview;
        respInfo.code = 1;
        return respInfo;
    }

    global class RestExpertInterviewInfo {
        public String recordNumber { get; set; }
    }
    global class RespExpertInterviewInfo {
        public Integer code;
        public String msg;
        public ExpertInterview expertInterview;
        public RespExpertInterviewInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
    global class ExpertInterview {
        public String projectName { get; set; }
        public String expertsName { get; set; }
        public String companyOfAffiliation { get; set; }
        public String position { get; set; }
        public String phone { get; set; }
        public String requirements { get; set; }
        public String recruiter { get; set; }
        public String analyst { get; set; }
        public String terViewStatus { get; set; }
        public InterviewFee interviewFee { get; set; }
        public List<CommunicationHistory> communicationHistories { get; set; }
    }
    global class InterviewFee {
        public String interviewStartDate { get; set; }
        public String interviewEndDate { get; set; }
        public String actualDurationMinuter { get; set; }
        public String chargingDurationMinuter { get; set; }
        public String expertProjectRateHours { get; set; }
        public String expertFeeAmount { get; set; }
        public String expertFeeAmountRMB { get; set; }
        public String participantsThe { get; set; }
        public String termsOfPayment { get; set; }
        public String whetherPayment { get; set; }
        public String urgent { get; set; }
        public String whetherChargeCustomers { get; set; }
        public String paymentStatus { get; set; }
        public String feeNote { get; set; }
        public String score { get; set; }
        public String activeCooperate { get; set; }
        public String activeLogical { get; set; }
        public String activeFacts { get; set; }
        public String activeInsights { get; set; }
    }
    global class CommunicationHistory {
        public String allNames { get; set; }
        public String communicationContent { get; set; }
        public String submitTime { get; set; }
    }
}