/**
 * Created by tko18 on 2022/2/18.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 分配人员 (获得成员列表)
*@Authortko18
*@Date 2022/2/18 14:12
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetPersonnelList')
global with sharing class DingTalk_GetPersonnelList {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespPersonnelInfo respInfo = new RespPersonnelInfo();
        try {
            RestPersonnelInfo restInfo = (RestPersonnelInfo) JSON.deserialize(requestBody, RestPersonnelInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }

    global static RespPersonnelInfo decisionMakingOperation(RestPersonnelInfo restInfo) {
        RespPersonnelInfo respInfo = new RespPersonnelInfo();
        List<PersonnelStaff> PersonnelStaffList = new List<PersonnelStaff>();
        if (String.isBlank(restInfo.userId)) {
            respInfo.msg = 'userId必填';
            return respInfo;
        }
        vlink__DING_User__c vDingUser = [SELECT Id,vlink_Title__c,Department__c FROM vlink__DING_User__c WHERE vlink__User_ID__c = :restInfo.userId];
        if (vDingUser == null) {
            respInfo.msg = '无法找到对应UserId的DING_User，请联系SAOP系统管理员';
            return respInfo;
        }
        List<staff__c> staffList = new List<staff__c>();
        if (String.isEmpty(restInfo.personnelName)) {
            staffList = [SELECT Id,Name FROM staff__c WHERE Department__c = :vDingUser.Department__c];
        } else {
            restInfo.personnelName = '%' + restInfo.personnelName + '%';
            staffList = [SELECT Id,Name FROM staff__c WHERE Name LIKE :restInfo.personnelName AND Department__c LIKE :vDingUser.Department__c];
        }
        if (!staffList.isEmpty()) {
            for (staff__c staff : staffList) {
                PersonnelStaff personnelStaff = new PersonnelStaff();
                personnelStaff.personnelId = staff.Id;
                personnelStaff.personnelName = staff.Name;
                PersonnelStaffList.add(personnelStaff);
            }
        }
        respInfo.personnelStaffs = PersonnelStaffList;
        respInfo.code = 1;
        return respInfo;
    }

    global class RestPersonnelInfo {
        public String userId { get; set; }
        public String personnelName { get; set; }
    }
    global class RespPersonnelInfo {
        public Integer code;
        public String msg;
        public List<PersonnelStaff> personnelStaffs;
        public RespPersonnelInfo() {
            this.code = 0;
            this.msg = '';
        }
    }
    global class PersonnelStaff {
        public String personnelName { get; set; }
        public String personnelId { get; set; }
    }

}