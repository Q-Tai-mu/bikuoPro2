/**
*@ClassName:DingTalk_GetExpertProject
*@Description:TODO 专家项目
*@Author: zhou
*@Date 2022/2/21
*@Version:1.0.0
**/
@RestResource(urlMapping='/DingTalk/GetExpertProject')
global with sharing class DingTalk_GetExpertProject {

    global class AppInput{
        public String Id;
        public String interviewStatus;
        public String condition;
        public String content;
    }
    
    global class AppOutput{
        public String status;             //200成功，500部分失败，501全失败
        public String msg;                //接收失败原因
        public List<ProjectExpert> projectExpertList; //返回查询的专家项目 List
        public Map<String,String> conditionOptionMap; //条件下拉列表 Map
        public Map<String,String> statusOptionMap; //访谈状态下拉列表 Map
    }
    global class ProjectExpert{
        public String ID;
        public String projectName;
        public String projectStatus;
        public String command;
        public String Recruiter;
        public String Analyst;
        public String interviewStatus;
        public String interviewDate;
        public String interviewTime;
        public String payStatus;
        public String chargeMoney;
        public String mark;
    }
    @HttpPost
    global static AppOutput doPost() {
        AppOutput out = new AppOutput();  
        AppInput input = new AppInput(); 
        out.status = '200';
        out.msg = '接收信息成功!'; 
        try{
            RestRequest req = RestContext.request;
            System.debug('req.requestBody'+ req.requestBody.toString()); 
            input = (DingTalk_GetExpertProject.AppInput)JSON.deserialize(req.requestBody.toString(), DingTalk_GetExpertProject.AppInput.class);
            system.debug('input:-->>'+input);     
            if(input.Id == null || input.Id == '' ){
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
        try{

            String sqlWhere = '';
            if (String.isNotEmpty(input.interviewStatus))sqlWhere += ' and projectName__r.interviewStatus__c =:input.interviewStatus ';
            if (String.isNotEmpty(input.condition) 
                    && String.isNotEmpty(input.content))sqlWhere += ' and :input.condition =:input.content ';
 
            List<String> tempList = new List<String>{
                'Id',
                'projectName__r.name',
                'projectName__r.projectStatus__c',
                'command__c',
                'Recruiter__c',
                'Analyst__c',
                'interviewStatus__c',
                'interviewDate__c',
                'interviewTime__c',
                'payStatus__c',
                '(select id ,chargeMoney__c, mark__c from Charge_Expert__r limit 1)'
            };
            String sql = 'SELECT ';
            sql += String.join(tempList, ',');
            sql += ' FROM Project_expert__c WHERE expertName__c =: input.Id ';
            sql += sqlWhere + 'limit 50000';
            
            System.debug('sql=>' + sql);
            system.debug('sqlwhere=>' + sqlwhere);

            List<Project_expert__c> queryResultList = Database.query(sql);
 

            List<ProjectExpert> projectExpertList = new List<ProjectExpert>();
            if(!queryResultList.isEmpty()){
                for(Project_expert__c obj : queryResultList){
                    ProjectExpert pe = new ProjectExpert();
                    pe.Id = obj.Id;
                    pe.projectName = obj.projectName__r.name;
                    pe.projectStatus = obj.projectName__r.projectStatus__c;
                    pe.command = obj.command__c;
                    pe.Recruiter = obj.Recruiter__c;
                    pe.Analyst = obj.Analyst__c;
                    pe.interviewStatus = obj.interviewStatus__c;
                    pe.interviewDate = String.valueOf(obj.interviewDate__c);
                    pe.interviewTime = String.valueOf(obj.interviewTime__c);
                    pe.payStatus = obj.payStatus__c;

                    // 暂时取第一个费用
                    if(obj.Charge_Expert__r.size() != 0){
                        pe.chargeMoney = String.valueOf(obj.Charge_Expert__r[0].chargeMoney__c);
                        pe.mark = String.valueOf(obj.Charge_Expert__r[0].mark__c);
                    }

                    projectExpertList.add(pe);
                }
            }
            out.projectExpertList = projectExpertList;


            //下拉列表：
            Map<String,String> conditionOptionMap = new Map<String,String>(); //下拉列表 条件
            Map<String,String> statusOptionMap = new Map<String,String>(); //下拉列表 访谈状态
            
            conditionOptionMap.put('项目需求', 'command__c');
            
            List<Schema.PicklistEntry> statusPickList = Project_expert__c.interviewStatus__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry option : statusPickList ){
                statusOptionMap.put(option.getLabel(), option.getValue());
            }
            out.conditionOptionMap = conditionOptionMap;
            out.statusOptionMap = statusOptionMap;
            System.debug(out);   
            return out;
            
        }catch(Exception e){
            out.status = '501';
            out.msg = '查询操作错误:' + e.getMessage() + e.getLineNumber(); 
            System.debug(out);  
            return out;
        }
    }
}