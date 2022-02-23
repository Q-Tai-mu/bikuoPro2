/**
 * Created by tko18 on 2022/2/23.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 项目专家列表
*@Authortko18
*@Date 2022/2/23 11:42
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/GetExpertsProjectList')
global with sharing class DingTalk_GetExpertsProjectList {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespDemandCInfo respInfo = new RespDemandCInfo();
        try {
            RestDemandCInfo restInfo = (RestDemandCInfo) JSON.deserialize(requestBody, RestDemandCInfo.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    global class RestExpertsProjectInfo {

    }
    global class RespExpertsProjectInfo {
        public Integer code;
        public String msg;
        public RespExpertsProjectInfo() {
            this.code = 0;
            this.msg = '';
        }

    }
}