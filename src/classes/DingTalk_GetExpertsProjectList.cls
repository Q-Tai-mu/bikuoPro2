/**
 * Created by tko18 on 2022/2/23.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 项目专家列表 (集成了搜索功能)
*@Authortko18
*@Date 2022/2/23 11:42
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetExpertsProjectList')
global with sharing class DingTalk_GetExpertsProjectList {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespExpertsProjectInfo respInfo = new RespExpertsProjectInfo();
        try {
            RestExpertsProjectInfo restInfo = (RestExpertsProjectInfo) JSON.deserialize(requestBody, RestExpertsProjectInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespExpertsProjectInfo decisionMakingOperation(RestExpertsProjectInfo restInfo) {
        RespExpertsProjectInfo respInfo = new RespExpertsProjectInfo();
        respInfo.expertsProjects = new List<ExpertsProject> ();
        String recordNumber = restInfo.recordNumber;
        String sqlQuery = 'SELECT Id,Name,expertName__r.ExpertID__c,expertName__r.Name,expertCompany__c,title__c,telephone__c,(SELECT Id,Field1__r.Name FROM ProjectExpertDemand__r),Recruiter__c,Analyst__c,Analyst__r.Name,interviewStatus__c,payStatus__c,reason__c,(SELECT Id,status__c FROM Charge_Expert__r) FROM Project_expert__c WHERE  Id != null ';
        if (String.isEmpty(restInfo.recordNumber)) {
            respInfo.msg = '编号必填！';
            return respInfo;
        }
        sqlQuery += 'AND projectName__r.projectNumber__c =: recordNumber ';
        if (String.isEmpty(restInfo.interviewStatus) && String.isEmpty(restInfo.searchCriteria) && String.isEmpty(restInfo.searchContent)) {
            respInfo.expertsProjects = encapsulation((List<Project_expert__c>) Database.query(sqlQuery));
            respInfo.code = 1;
            return respInfo;
        }
        if (!String.isEmpty(restInfo.interviewStatus)) {
            switch on Integer.valueOf(restInfo.interviewStatus) {
                when 0 {
                    sqlQuery += ' AND interviewStatus__c = \'未约访\'';
                }
                when 1 {
                    sqlQuery += ' AND interviewStatus__c = \'已约访\'';
                }
                when 2 {
                    sqlQuery += ' AND interviewStatus__c = \'拒绝(原因)\'';
                }
                when 3 {
                    sqlQuery += ' AND interviewStatus__c = \'已访谈\'';
                }
            }
        }
        System.debug('SQL' + sqlQuery);
        if (!String.isEmpty(restInfo.searchCriteria)) {
            if (String.isEmpty(restInfo.searchContent)) {
                respInfo.msg = '请在选择过搜索条件后，必填搜索内容!';
                return respInfo;
            }
            restInfo.searchContent = '%' + restInfo.searchContent + '%';
            switch on Integer.valueOf(restInfo.searchCriteria) {
                when 0 {
                    sqlQuery += ' AND expertName__r.ExpertID__c LIKE :restInfo.searchContent ';
                }
                when 1 {
                    sqlQuery += ' AND expertName__r.Name LIKE :restInfo.searchContent ';
                }
                when 2 {
                    sqlQuery += ' AND expertName__r.company__c LIKE :restInfo.searchContent ';
                }
                when 3 {
                    sqlQuery += ' AND expertName__r.title__c LIKE :restInfo.searchContent ';
                }
                when 4 {
                    sqlQuery += ' AND expertName__r.telephone__c LIKE :restInfo.searchContent ';
                }
            }
        }
        respInfo.expertsProjects = encapsulation((List<Project_expert__c>) Database.query(sqlQuery));
        respInfo.code = 1;
        return respInfo;
    }
    public static List<ExpertsProject> encapsulation(List<Project_expert__c> projectExperts) {
        List<ExpertsProject> expertsProjects = new List<ExpertsProject> ();
        if (!projectExperts.isEmpty()) {
            for (Project_expert__c projectExperts2 : projectExperts) {
                ExpertsProject expertsProject = new ExpertsProject();
                expertsProject.recordNumber = projectExperts2.Name;
                expertsProject.expertsNumber = projectExperts2.expertName__r.ExpertID__c;
                expertsProject.expertsName = projectExperts2.expertName__r.Name;
                expertsProject.companyOfAffiliation = projectExperts2.expertCompany__c;
                expertsProject.position = projectExperts2.title__c;
                expertsProject.phone = projectExperts2.telephone__c;
                if (!projectExperts2.ProjectExpertDemand__r.isEmpty()) {
                    List<Demand> demands = new List<Demand>();
                    for (ProjectExpertDemand__c projectExpertDemand : (List<ProjectExpertDemand__c>) projectExperts2.ProjectExpertDemand__r) {
                        Demand demand = new Demand();
                        demand.demandName = projectExpertDemand.Field1__r.Name;
                        demands.add(demand);
                    }
                    expertsProject.demands = demands;
                }
                expertsProject.recruiter = projectExperts2.Recruiter__c;
                expertsProject.analystId = projectExperts2.Analyst__c;
                expertsProject.analystName = projectExperts2.Analyst__r.Name;
                expertsProject.interviewStatus = projectExperts2.interviewStatus__c;
                expertsProject.payStatus = projectExperts2.payStatus__c;
                expertsProject.reason = projectExperts2.reason__c;
                if (!projectExperts2.Charge_Expert__r.isEmpty()) {
                    expertsProject.chargeExpert = projectExperts2.Charge_Expert__r[0].status__c;
                }
                expertsProjects.add(expertsProject);
            }
        }
        return expertsProjects;
    }
    global class RestExpertsProjectInfo {
        public String recordNumber { get; set; }//项目编号
        public String interviewStatus { get; set; }//访谈状态
        public String searchCriteria { get; set; }//搜索条件
        public String searchContent { get; set; }//搜索内容
    }
    global class RespExpertsProjectInfo {
        public Integer code;
        public String msg;
        public List<ExpertsProject> expertsProjects;
        public RespExpertsProjectInfo() {
            this.code = 0;
            this.msg = '';
        }

    }
    global class ExpertsProject {
        public String recordNumber { get; set; }
        public String expertsNumber { get; set; }
        public String expertsName { get; set; }
        public String companyOfAffiliation { get; set; }
        public String position { get; set; }
        public String phone { get; set; }
        public List<Demand> demands { get; set; }
        public String recruiter { get; set; }
        public String analystId { get; set; }
        public String analystName { get; set; }
        public String interviewStatus { get; set; }
        public String payStatus { get; set; }
        public String reason { get; set; }
        public String chargeExpert { get; set; }
    }
    global class Demand {
        public String demandName { get; set; }
    }
}