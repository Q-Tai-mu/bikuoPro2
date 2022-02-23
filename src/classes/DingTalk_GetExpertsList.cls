/**
*@ClassName:DingTalk_GetExpertsList
*@Description:TODO 专家列表查询class
*@Author: zhou
*@Date 2022/2/21
*@Version:1.0.0
**/
@RestResource(urlMapping='/DingTalk/GetExpertsList')
global with sharing class DingTalk_GetExpertsList {

    global class AppInput{
        public String keyWords;
        public String industry;
        public String Name;
        public String ExpertID;
        public String registerTimeFrom;
        public String registerTimeTo;
        public String company;
        public String title;
        public String depertment;
        public String telephone;
        public String Email;
        public String wechat;
        public String register;
        public String contray;
        public String province;
        public String status;

    }
    
    global class AppOutput{
        public String status;             //200成功，500部分失败，501全失败
        public String msg;                //接收失败原因
        public List<ExpertInfo> expertInfoList; //返回查询的专家 List
        public Map<String,String> industryOptionMap; //下拉列表 行业
        public Map<String,String> statusOptionMap; //下拉列表 状态
    }
    global class ExpertInfo{
        public String ID;
        public String keyWords;
        public String industry;
        public String Name;
        public String ExpertID;
        public String registerTime;
        public String company;
        public String title;
        public String depertment;
        public String telephone;
        public String Email;
        public String wechat;
        public String register;
        public String contray;
        public String province;
        public String status;
    }
    @HttpPost
    global static AppOutput doPost() {
        AppOutput out = new AppOutput();  
        AppInput input = new AppInput(); 
        List<ExpertInfo> expertInfoList = new List<ExpertInfo>();
        out.status = '200';
        out.msg = '接收信息成功!'; 
        try{
            RestRequest req = RestContext.request;
            System.debug('req.requestBody'+ req.requestBody.toString()); 
            input = (DingTalk_GetExpertsList.AppInput)JSON.deserialize(req.requestBody.toString(), DingTalk_GetExpertsList.AppInput.class);
            system.debug('input:-->>'+input);     
            // if(input.userId == null || input.userId == '' ){
            //     out.status = '501';
            //     out.msg = '传输的数据为空，请重新检验传输的json字符串是否正确！';
            //     System.debug(out);
            //     return out;  
            // }
        }catch(Exception ex){
           out.status = '501';
           out.msg = 'json 字符串解析失败！' + ex.getMessage() ;  
           return out;
        }
        try{

            String keyWord = '%' + input.keyWords + '%';
            String sqlWhere = '';
            if (String.isNotEmpty(input.keyWords))sqlWhere += ' and keyWords__c  like  :keyWord ';
            if (String.isNotEmpty(input.industry))sqlWhere += ' and industry__c =:input.industry ';
            if (String.isNotEmpty(input.Name))sqlWhere += ' and Name =:input.Name ';
            if (String.isNotEmpty(input.ExpertID))sqlWhere += ' and ExpertID__c =:input.ExpertID ';
            if (String.isNotEmpty(input.company ))sqlWhere += ' and company__c  =:input.company  ';
            if (String.isNotEmpty(input.title))sqlWhere += ' and title__c =:input.title ';
            if (String.isNotEmpty(input.depertment))sqlWhere += ' and depertment__c =:input.depertment ';
            if (String.isNotEmpty(input.telephone))sqlWhere += ' and telephone__c =:input.telephone ';
            if (String.isNotEmpty(input.Email))sqlWhere += ' and Email__c =:input.Email ';
            if (String.isNotEmpty(input.wechat))sqlWhere += ' and wechat__c =:input.wechat ';
            if (String.isNotEmpty(input.register))sqlWhere += ' and register__r.Name =:input.register ';
            if (String.isNotEmpty(input.contray))sqlWhere += ' and contray__c =:input.contray ';
            if (String.isNotEmpty(input.province))sqlWhere += ' and province__c =:input.province ';
            if (String.isNotEmpty(input.status))sqlWhere += ' and status__c =:input.status ';

            Date dateFrom;
            Date dateTo;
            if (String.isNotEmpty(input.registerTimeFrom)){ dateFrom = date.valueOf(input.registerTimeFrom);
                                                          sqlWhere += ' and registerTime__c >=: dateFrom ';}
            if (String.isNotEmpty(input.registerTimeTo)){   dateTo = date.valueOf(input.registerTimeTo);
                                                          sqlWhere += ' and registerTime__c <=: dateTo ';}


            List<String> tempList = new List<String>{
                'Id',
                'keyWords__c',
                'industry__c',
                'Name',
                'ExpertID__c',
                'registerTime__c',
                'company__c',
                'title__c',
                'depertment__c',
                'telephone__c',
                'Email__c',
                'wechat__c',
                'register__r.name',
                'contray__c',
                'province__c',
                'status__c'
            };
            String sql = 'SELECT ';
            sql += String.join(tempList, ',');
            sql += ' FROM Expert_management__c WHERE Id != NULL ';
            sql += sqlWhere + 'limit 50000';
            
            System.debug('sql=>' + sql);
            system.debug('sqlwhere=>' + sqlwhere);

            List<Expert_management__c> ExpertList = Database.query(sql);
 

                                      
            if(!ExpertList.isEmpty()){
                for(Expert_management__c obj : ExpertList){
                    ExpertInfo expertInfo = new ExpertInfo();
                    ExpertInfo.ID = obj.ID;
                    ExpertInfo.keyWords = obj.keyWords__c;
                    ExpertInfo.industry = obj.industry__c;
                    ExpertInfo.Name = obj.Name;
                    ExpertInfo.ExpertID = obj.ExpertID__c;
                    ExpertInfo.registerTime = String.valueOf(obj.registerTime__c);
                    ExpertInfo.company = obj.company__c;
                    ExpertInfo.title = obj.title__c;
                    ExpertInfo.depertment = obj.depertment__c;
                    ExpertInfo.telephone = obj.telephone__c;
                    ExpertInfo.Email = obj.Email__c;
                    ExpertInfo.wechat = obj.wechat__c;
                    ExpertInfo.register = obj.register__r.name;
                    ExpertInfo.contray = obj.contray__c;
                    ExpertInfo.province = obj.province__c;
                    ExpertInfo.status = obj.status__c;
                    expertInfoList.add(ExpertInfo);
                }
            }
            out.expertInfoList = expertInfoList;



            //下拉列表：
            Map<String,String> industryOptionMap = new Map<String,String>(); //下拉列表 行业
            Map<String,String> statusOptionMap = new Map<String,String>(); //下拉列表 状态

            List<Schema.PicklistEntry> industryPickList = Expert_management__c.industry__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry option : industryPickList ){
                industryOptionMap.put(option.getLabel(), option.getValue());
            }
            List<Schema.PicklistEntry> statusPickList = Expert_management__c.status__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry option : statusPickList ){
                statusOptionMap.put(option.getLabel(), option.getValue());
            }
            out.industryOptionMap = industryOptionMap;
            out.statusOptionMap = statusOptionMap;
            System.debug(out);   
            return out;
            
        }catch(Exception e){
            out.status = '501';
            out.msg = 'sfdc中DML错误:' + e.getMessage() + e.getLineNumber(); 
            System.debug(out);  
            return out;
        }
    }
}