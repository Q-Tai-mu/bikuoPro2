/**
 * Created by tko18 on 2022/2/17.
 */
/**
*@ClassName:Lin-Tui
*@Description: 返回具体项目详情
*@Authortko18
*@Date 2022/2/17 10:55
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetProjectDetails')
global with sharing class DingTalk_GetProjectDetailsInfo {

    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespProjectDetailsInfo respInfo = new RespProjectDetailsInfo();
        try {
            RestProjectDetailsInfo restInfo = (RestProjectDetailsInfo) JSON.deserialize(requestBody, RestProjectDetailsInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }

    public static RespProjectDetailsInfo decisionMakingOperation(RestProjectDetailsInfo restInfo) {
        RespProjectDetailsInfo respInfo = new RespProjectDetailsInfo();
        if (String.isBlank(restInfo.projectNumber) || String.isBlank(restInfo.userId)) {
            respInfo.msg = '项目编号和userId都是必填';
            return respInfo;
        }
        vlink__DING_User__c vDingUser = [SELECT Id,vlink_Title__c,Department__c FROM vlink__DING_User__c WHERE vlink__User_ID__c = :restInfo.userId];
        if (vDingUser == null) {
            respInfo.msg = '无法找到对应UserId的DING_User，请联系SAOP系统管理员';
            return respInfo;
        }
        adviser__c adviser = [
                SELECT Id,
                        projectNumber__c,
                        Name,
                        BU__c,
                        serviceProject__c,
                        projectStart__c,
                        projectStop__c,
                        projectStatus__c,
                        demandNumber__c,
                        expertNumber__c,
                        chooseExpert__c,
                        interviewExpert__c,
                        averageScore__c,
                         (SELECT Id,Name,command__c FROM project_ManagementGgrz__r), (SELECT Id,title__c,userName__r.Name FROM parjectGgqI__r)
                FROM adviser__c
                WHERE projectNumber__c = :restInfo.projectNumber
        ];
        if (adviser == null) {
            respInfo.msg = '不存在相关项目记录，请联系SAOP系统管理员';
            return respInfo;
        }

        ProjectDetails projectDetail = new ProjectDetails();
        projectDetail.expertsDemands = new List<ExpertsDemand>();
        projectDetail.projectNumber = adviser.projectNumber__c;
        projectDetail.projectName = adviser.Name;
        projectDetail.bU = adviser.BU__c;
        projectDetail.serviceCategory = adviser.serviceProject__c;
        projectDetail.projectStartTime = String.valueOf(adviser.projectStart__c);
        projectDetail.projectEndTime = String.valueOf(adviser.projectStop__c);
        projectDetail.projectStatus = adviser.projectStatus__c;
        projectDetail.projectDemandQuantity = String.valueOf(adviser.demandNumber__c);
        projectDetail.numberOfRequirementsExperts = String.valueOf(adviser.demandNumber__c);
        projectDetail.numberOfSelectedExperts = String.valueOf(adviser.expertNumber__c);
        projectDetail.numberOfExpertsVisited = String.valueOf(adviser.chooseExpert__c);
        projectDetail.ExpertAverageScore = String.valueOf(adviser.interviewExpert__c);
        projectDetail.membersOfTheAuthority = vDingUser.vlink_Title__c == 'Recruiter Team Leader' ? true : false;
        projectDetail.demandPermissions = vDingUser.Department__c != 'Recruiters' ? true : false;
        if (adviser.project_ManagementGgrz__r.size() > 0) {
            for (Expert_demand__c expertDemand : (List<Expert_demand__c>) adviser.project_ManagementGgrz__r) {
                ExpertsDemand expertsDemand = new ExpertsDemand();
                expertsDemand.expertsId = expertDemand.Id;
                expertsDemand.expertsName = expertDemand.Name;
                expertsDemand.expertsContent = expertDemand.command__c;
                projectDetail.expertsDemands.add(expertsDemand);
            }
        }
        if (adviser.parjectGgqI__r.size() > 0) {
            List<MembersOfThe> membersOfTheList = new List<MembersOfThe>();
            for (Project_personnel__c personnel : (List<Project_personnel__c>) adviser.parjectGgqI__r) {
                MembersOfThe membersOfThe = new MembersOfThe();
                membersOfThe.memberPosition = personnel.title__c;
                membersOfThe.memberName = personnel.userName__r.Name;
                membersOfTheList.add(membersOfThe);
            }
            projectDetail.membersOfTheList = membersOfTheList;
        }
        projectDetail.attachmentCustomizations = new List<AttachmentCustomization>();
        projectDetail.communicationHistories = new List<CommunicationHistory>();
        respInfo.projectDetails = projectDetail;
        respInfo.msg = '查询成功';
        respInfo.code = 1;
        return respInfo;
    }

    global class RestProjectDetailsInfo {
        public String projectNumber { get; set; }
        public String userId { get; set; }
    }

    global class RespProjectDetailsInfo {
        public Integer code;
        public String msg;
        public ProjectDetails projectDetails;
        public RespProjectDetailsInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
    global class ProjectDetails {
        public String projectNumber { get; set; }
        public String projectName { get; set; }
        public String bU { get; set; }
        public String serviceCategory { get; set; }
        public String projectStartTime { get; set; }
        public String projectEndTime { get; set; }
        public String projectStatus { get; set; }
        public String projectDemandQuantity { get; set; }
        public String numberOfRequirementsExperts { get; set; }
        public String numberOfSelectedExperts { get; set; }
        public String numberOfExpertsVisited { get; set; }
        public String ExpertAverageScore { get; set; }
        public Boolean membersOfTheAuthority { get; set; }
        public Boolean demandPermissions { get; set; }
        public List<ExpertsDemand> expertsDemands { get; set; }
        public List<MembersOfThe> membersOfTheList { get; set; }
        public List<AttachmentCustomization> attachmentCustomizations { get; set; }
        public List<CommunicationHistory> communicationHistories { get; set; }
    }
    global class ExpertsDemand {
        public String expertsId { get; set; }
        public String expertsName { get; set; }
        public String expertsContent { get; set; }
    }
    global class MembersOfThe {
        public String memberName { get; set; }
        public String memberPosition { get; set; }
    }
    global class AttachmentCustomization {
        public String attachmentId { get; set; }
        public String attachmentName { get; set; }
        public Date attachmentDate { get; set; }
        public String attachmentSize { get; set; }
        public String attachmentSuffix { get; set; }
    }

    global class CommunicationHistory {
        public String communicationName { get; set; }
        public String communicationContent { get; set; }
        public Date historyOfTime { get; set; }
    }
}