/*
* Author : zcx
* Date: 2022.2.14
* Function : 人天填报aura页面提供后台接口
 */

 public with sharing class ManDaysInputService {


    @AuraEnabled
    // 初始化查询人天信息
    public static resultClass getManDaysInfo(String weekRencentlyName) {
      try {
        List<WorkDayObject__c> queryResult= [SELECT Id,Name,weekStart__c,weekClose__c,workDay2__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
                                            projectName__r.account__r.name From workDay44IF__r) FROM WorkDayObject__c where RecentThreeWeeks2__c =:weekRencentlyName];


        Map<String, List<Project_person_days__c>> itemsMap = new Map<String, List<Project_person_days__c>>();
        List<String> DateNameList = new List<String>();
        // 根据日期整理人天相关项
        for (Project_person_days__c obj : queryResult[0].workDay44IF__r) {
            if (!itemsMap.containsKey(String.valueOf(obj.Custom_date__c))) {
              List<Project_person_days__c> ppdList = new List<Project_person_days__c>();
              ppdList.add(obj);
              itemsMap.put(String.valueOf(obj.Custom_date__c), ppdList);
              DateNameList.add(String.valueOf(obj.Custom_date__c));
            }else {
              itemsMap.get(String.valueOf(obj.Custom_date__c)).add(obj);
            }
        }
        resultClass retObj = new resultClass();
        retObj.Id = queryResult[0].Id;
        retObj.Name = queryResult[0].Name ;
        retObj.weekStart = String.valueOf(queryResult[0].weekStart__c)  ;
        retObj.weekClose = String.valueOf(queryResult[0].weekClose__c) ;
        retObj.daysCount =  queryResult[0].workDay2__c ;
        
        retObj.itemsMap = itemsMap;
        retObj.DateNameList = DateNameList;
        
        retObj.state = 'success';

        System.debug(retObj);
        return retObj;
      } catch (Exception e) {
        return null;
      }
    }


    @AuraEnabled
    // 取前一天（相关项）
    public static resultClass getManDaysInfoP() {
      try {
        List<Project_person_days__c> queryResult= [Select Id, projectName__c, projectName__r.name,projectName__r.projectManager__r.name,
                                                  projectName__r.projectStatus__c,projectName__r.projectStart__c,projectName__r.projectStop__c,
                                                  projectName__r.account__r.name,
                                              timeConfirm__c,Custom_date__c,
                                            customer__r.name  FROM Project_person_days__c where workDay__r.name = '2022-W06(2022.02.07 - 2022.02.13)'
                                            and timeConfirm__c != '0' and timeConfirm__c != null];

        for (Project_person_days__c one : queryResult) {
          one.timeConfirm__c = '0';
        }
        // 取上一天项目 并去重 待开发
        // Set<String> proIdSet = new Set<String>();
        // for (Project_person_days__c variable : queryResult) {
        //   proIdSet
        // }
        resultClass retObj = new resultClass();
        retObj.queryResult = queryResult;
        retObj.state = 'success';

        System.debug(retObj);
        return retObj;
      } catch (Exception e) {
        return null;
      }
    }


    @AuraEnabled
    // 翻页
    public static resultClass getManDaysInfoChange(String Action,String CurrentId) {
      try {
        WorkDayObject__c PreviousObj;
        if (Action == 'Previous') {
          List<WorkDayObject__c> queryResult= [SELECT Id,Name,weekStart__c,weekClose__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
                                              projectName__r.account__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c desc ];
          system.debug(queryResult.size());
          Boolean isCurrency = false;
          for (WorkDayObject__c obj : queryResult) {
            system.debug(obj.Id);
            system.debug(CurrentId);
  
            if (String.valueOf(obj.Id) == String.valueOf(CurrentId)) {
              system.debug('go into');
              isCurrency = true;
              continue;
            }
            if (isCurrency) {
              system.debug('go into2');
              PreviousObj = obj;
              break;
            }
          }
          system.debug(PreviousObj);
        }else {

          List<WorkDayObject__c> queryResult= [SELECT Id,Name,weekStart__c,weekClose__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
                                              projectName__r.account__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c asc ];
          system.debug(queryResult.size());
          Boolean isCurrency = false;

          for (WorkDayObject__c obj : queryResult) {
            system.debug(obj.Id);
            system.debug(CurrentId);
  
            if (String.valueOf(obj.Id) == String.valueOf(CurrentId)) {
              system.debug('go into');
              isCurrency = true;
              continue;
            }
            if (isCurrency) {
              system.debug('go into2');
              PreviousObj = obj;
              break;
            }
          }
          system.debug(PreviousObj);
        }

        Map<String, List<Project_person_days__c>> itemsMap = new Map<String, List<Project_person_days__c>>();
        List<String> DateNameList = new List<String>();
        // 根据日期整理人天相关项
        for (Project_person_days__c obj : PreviousObj.workDay44IF__r) {
            if (!itemsMap.containsKey(String.valueOf(obj.Custom_date__c))) {
              List<Project_person_days__c> ppdList = new List<Project_person_days__c>();
              ppdList.add(obj);
              itemsMap.put(String.valueOf(obj.Custom_date__c), ppdList);
              DateNameList.add(String.valueOf(obj.Custom_date__c));
            }else {
              itemsMap.get(String.valueOf(obj.Custom_date__c)).add(obj);
            }
        }
        resultClass retObj = new resultClass();
        retObj.Id = PreviousObj.Id;
        retObj.Name = PreviousObj.Name;
        retObj.itemsMap = itemsMap;
        retObj.DateNameList = DateNameList;
        
        retObj.state = 'success';

        System.debug(retObj);
        return retObj;
      } catch (Exception e) {
        return null;
      }
    }



    @AuraEnabled
    // 保存人天信息
    public static String saveManDaysInfo(String paramStr) {
      try {
        system.debug(paramStr);
        List<ParamClass> objList = (List<ParamClass>) JSON.deserialize(paramStr, List<ParamClass>.class);
        system.debug(objList);

        List<Project_person_days__c> upsertList = new List<Project_person_days__c>();

        for (ParamClass one : objList) {
            Project_person_days__c  obj = new Project_person_days__c();
            obj.Id =  one.Id == null ? null : one.Id;
            obj.projectName__c = one.projectName == null ? null : one.projectName;
            obj.timeConfirm__c = one.timeConfirm == null ? null : one.timeConfirm;
            //obj.workDay__c = one.workDay == null ? null : one.workDay;
            obj.Custom_date__c = Date.valueOf(one.Custom_date == null ? null : one.Custom_date);
            upsertList.add(obj);
        }
        upsert upsertList;

        return '保存成功';
      } catch (Exception e) {
        return '保存失败，错误信息为：' + e.getMessage();
      }
    }



    @AuraEnabled
    // 查找项目（模糊查询）
    public static List<adviser__c> queryProject(String KeyStr) {
      try {
        System.debug(KeyStr);
        String keyWord = '%' + KeyStr + '%';
        List<adviser__c> projectList = [SELECT Id, Name, projectManager__r.Name, projectStatus__c, projectStart__c, projectStop__c,account__c,account__r.name
                                   FROM adviser__c WHERE Name Like :keyWord];
        return projectList;
      } catch (Exception e) {
        return null;
      }
    }

    @AuraEnabled
    // 查找项目（查出默认项目）
    public static List<adviser__c> queryProjectBefore() {
      try {
        List<adviser__c> projectList = [SELECT Id, Name, projectManager__r.name, projectStatus__c, projectStart__c, projectStop__c,account__c,account__r.name
                                   FROM adviser__c WHERE projectType__c != '项目' and projectType__c != null];
        return projectList;
      } catch (Exception e) {
        return null;
      }
    }


    @AuraEnabled
    // 查找客户（模糊查询）
    public static List<Account> queryAcc(String KeyStr) {
      try {
        System.debug(KeyStr);
        String keyWord = '%' + KeyStr + '%';
        List<Account> AccList = [SELECT Id, Name, Owner.name, Rating
                                   FROM Account WHERE Name Like :keyWord];
        return AccList;
      } catch (Exception e) {
        return null;
      }
    }


    public class resultClass {
      @AuraEnabled
      public String state;
      @AuraEnabled
      public String Id;
      @AuraEnabled
      public String Name;
      @AuraEnabled
      public String weekStart;
      @AuraEnabled
      public String weekClose;
      @AuraEnabled
      public Decimal daysCount;
      @AuraEnabled
      public List<Project_person_days__c> queryResult;
      
      @AuraEnabled
      public Map<String, List<Project_person_days__c>> itemsMap;
      @AuraEnabled
      public List<String> DateNameList;
    }


    public class ParamClass{
      public String Id;

      public String projectName;
      public String timeConfirm;
      public String workDay;
      public String Custom_date;


    }



}