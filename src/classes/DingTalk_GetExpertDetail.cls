/**
*@ClassName:DingTalk_GetExpertsList
*@Description:TODO 专家详细信息页面初始化
*@Author: zhou
*@Date 2022/2/21
*@Version:1.0.0
**/
@RestResource(urlMapping='/DingTalk/GetExpertDetail')
global with sharing class DingTalk_GetExpertDetail {

    global class AppInput{
        public String Id;
    }
    
    global class AppOutput{
        public String status;             //200成功，500部分失败，501全失败
        public String msg;                //接收失败原因
        public ExpertInfo ExpertInfoDetails; //返回专家详细信息
        public List<workExperience> workExperienceList; //  工作经历
        public List<CommunityRecord> CommunityRecordList; //  工作经历
    }
    global class ExpertInfo{
        public String ID;
        public String Name;
        public String alias;
        public String ExpertID;
        public String gender;
        public String education;
        public String contray;
        public String province;
        public String telephone;
        public String telephoneRemarks;
        public String Email;
        public String wechat;
        public String expertOriginal;
        public String commend;
        public String company;
        public String expertCharge2;
        public String expertCharge1;
        public String title;
        public String depertment;
        public String active;
        public String keyWords;
        public String register;
        public String registerTime;
        public String Bio;
    }


    global class workExperience{
        public String ID;
        public String start;
        public String close;
        public String company;
        public String department;
        public String title;
    }


    global class CommunityRecord{
        public String ID;
        public String content;
        public String user;
        public String recordtime;
        public String url;
   
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
            input = (DingTalk_GetExpertDetail.AppInput)JSON.deserialize(req.requestBody.toString(), DingTalk_GetExpertDetail.AppInput.class);
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


        try {
                List<String> tempList = new List<String>{
                    'Name',
                    'alias__c',
                    'ExpertID__c',
                    'gender__c',
                    'education__c',
                    'contray__c',
                    'province__c',
                    'telephone__c',
                    'telephoneRemarks__c',
                    'Email__c',
                    'wechat__c',
                    'expertOriginal__c',
                    'commend__c',
                    'company__c',
                    'expertCharge2__c',
                    'expertCharge1__c',
                    'title__c',
                    'depertment__c',
                    'active__c',
                    'keyWords__c',
                    'register__r.Name',
                    'registerTime__c',
                    'Bio__c'
                }; 
                String sql = 'SELECT ';
                sql += String.join(tempList, ',');
                sql += ' FROM Expert_management__c WHERE Id == : input.Id';
                
                System.debug('sql=>' + sql);
    
                List<Expert_management__c> ExpertList = Database.query(sql);

                List<ExpertInfo> expertInfoList = new List<ExpertInfo>();
                for (Expert_management__c obj : ExpertList) {
                    ExpertInfo expertInfo = new ExpertInfo();
                    ExpertInfo.ID = obj.ID;
                    ExpertInfo.Name = obj.Name;
                    ExpertInfo.alias = obj.alias__c;
                    ExpertInfo.ExpertID = obj.ExpertID__c;
                    ExpertInfo.gender = obj.gender__c;
                    ExpertInfo.education = obj.education__c;
                    ExpertInfo.contray = obj.contray__c;
                    ExpertInfo.province = obj.province__c;
                    ExpertInfo.telephone = obj.telephone__c;
                    ExpertInfo.telephoneRemarks = obj.telephoneRemarks__c;
                    ExpertInfo.Email = obj.Email__c;
                    ExpertInfo.wechat = obj.wechat__c;
                    ExpertInfo.expertOriginal = obj.expertOriginal__c;
                    ExpertInfo.commend = obj.commend__c;
                    ExpertInfo.company = obj.company__c;
                    ExpertInfo.expertCharge2 = obj.expertCharge2__c;
                    ExpertInfo.expertCharge1 = String.valueOf(obj.expertCharge1__c);
                    ExpertInfo.title = obj.title__c;
                    ExpertInfo.depertment = obj.depertment__c;
                    ExpertInfo.active = obj.active__c;
                    ExpertInfo.keyWords = obj.keyWords__c;
                    ExpertInfo.register = obj.register__r.name;
                    ExpertInfo.registerTime = String.valueOf(obj.registerTime__c);
                    ExpertInfo.Bio = obj.Bio__c;
                    expertInfoList.add(ExpertInfo);
                }
                out.ExpertInfoDetails = expertInfoList[0];


                List<workExperience> workExperienceList = new List<workExperience>();
                // 工作经历
                List<work_experience__c> workExperienceQuery = [Select Id ,start__c, close__c,company__c, department__c,
                                                                title__c From work_experience__c 
                                                                Where NameOf_expert__c = :  input.Id];
                for (work_experience__c obj : workExperienceQuery) {
                    workExperience workExperience = new workExperience();
                    workExperience.ID = obj.ID;
                    workExperience.start = String.valueOf(obj.start__c);
                    workExperience.close = String.valueOf(obj.close__c);
                    workExperience.company = obj.company__c;
                    workExperience.department = obj.department__c;
                    workExperience.title = obj.title__c;
                    workExperienceList.add(workExperience);
                }
                out.workExperienceList = workExperienceList;



                // 沟通记录
                List<CommunityRecord> CommunityRecordList = new List<CommunityRecord>();
                List<CommunityRecord__c> CommunityRecordQuery = [Select Id ,user__c, user__r.External_id__c ,
                                                                 time__c, content__c
                                                                 From CommunityRecord__c 
                                                                  Where expert__c = :  input.Id];
                // 提交人头像map
                Map<String,String> urlMap = new Map<String,String>();
                // 通过提交人ExternId 取ding user对象的头像url
                Set<String> ExternalSet = new Set<String>();
                for (CommunityRecord__c obj : CommunityRecordQuery) ExternalSet.add(obj.user__r.External_id__c);

                for (vlink__DING_User__c obj : [Select Id, vlink__Head_Image_Url__c From vlink__DING_User__c Where Id in :ExternalSet]) {
                    urlMap.put(obj.ID, obj.vlink__Head_Image_Url__c);
                } 

                for (CommunityRecord__c obj : CommunityRecordQuery) {
                    CommunityRecord communityRecord = new CommunityRecord();
                    communityRecord.ID = obj.Id;
                    communityRecord.content = obj.content__c;
                    communityRecord.user = obj.user__c;
                    communityRecord.recordtime = String.valueOf(obj.time__c);
                    communityRecord.url = urlMap.get(obj.user__r.External_id__c);
                    CommunityRecordList.add(communityRecord);
                }

                out.CommunityRecordList = CommunityRecordList;
                return out;


        } catch (Exception ex) {
            out.status = '501';
            out.msg = '获取专家详细信息失败：' + ex.getMessage() ;  
            return out;
        }

    }
}