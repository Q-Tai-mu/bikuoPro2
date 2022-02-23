/*
* Author : zcx
* Date: 2022.2.14
* Function : 人天填报aura页面提供后台接口
 */

 public with sharing class ManDaysInputService {


    @AuraEnabled
    // 初始化查询人天信息
    public static resultClass getManDaysInfo() {
      try {
        List<WorkDayObject__c> queryResult= [SELECT Id,Name,weekStart__c,weekClose__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
                                            customer__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c desc LIMIT 4];

        // if (queryResult[0].workDay44IF__r.size() == 0 ) {
        //      queryResult = [SELECT Id,Name,weekStart__c,weekClose__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
        //                                       customer__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c desc LIMIT 2];
        //     queryResult[0] = queryResult[1];
        // }

        Map<String, List<Project_person_days__c>> itemsMap = new Map<String, List<Project_person_days__c>>();
        List<String> DateNameList = new List<String>();
        // 根据日期整理人天相关项
        for (Project_person_days__c obj : queryResult[3].workDay44IF__r) {
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
        retObj.Name = queryResult[0].Name + '本周';
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
        List<WorkDayObject__c> queryResult= [SELECT Id,Name,weekStart__c,weekClose__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
                                            customer__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c desc LIMIT 2];

        Map<String, List<Project_person_days__c>> itemsMap = new Map<String, List<Project_person_days__c>>();
        List<String> DateNameList = new List<String>();
        // 根据日期整理人天相关项
        for (Project_person_days__c obj : queryResult[1].workDay44IF__r) {
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
        retObj.Name = queryResult[0].Name + '本周';
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
    // 翻页
    public static resultClass getManDaysInfoChange(String Action,String CurrentId) {
      try {
        WorkDayObject__c PreviousObj;
        if (Action == 'Previous') {
          List<WorkDayObject__c> queryResult= [SELECT Id,Name,weekStart__c,weekClose__c,(Select Id, projectName__r.name,timeConfirm__c,Custom_date__c,
                                              customer__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c desc ];
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
                                              customer__r.name From workDay44IF__r) FROM WorkDayObject__c order by weekStart__c asc ];
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
    public static String SaveManDaysInfo() {
      try {
        return null;
      } catch (Exception e) {
        return null;
      }
    }



    @AuraEnabled
    // 查找项目（模糊查询）
    public static List<adviser__c> queryProject(String KeyStr) {
      try {
        System.debug(KeyStr);
        String keyWord = '%' + KeyStr + '%';
        List<adviser__c> projectList = [SELECT Id, Name, projectManager__r.name, projectStatus__c, projectStart__c, projectStop__c
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
        List<adviser__c> projectList = [SELECT Id, Name, projectManager__r.name, projectStatus__c, projectStart__c, projectStop__c
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
      public Map<String, List<Project_person_days__c>> itemsMap;
      @AuraEnabled
      public List<String> DateNameList;
    }



}