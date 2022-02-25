/**
 * Created by tko18 on 2022/2/23.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO 返回费用的银行卡
 *  1.新增 银行卡记录类型（develop） 字段
*@Authortko18
*@Date 2022/2/23 15:35
*@Version:1.0.0
**/
@RestResource(UrlMapping='/DingTalk/BankCard')
global with sharing class DingTalk_BankCard {
    @HttpPost
    global static void doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        RespBankCard respInfo = new RespBankCard();
        try {
            RestBankCard restInfo = (RestBankCard) JSON.deserialize(requestBody, RestBankCard.class);
            respInfo = decisionMakingOperation(restInfo);
        } catch (Exception e) {
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getLineNumber():' + e.getLineNumber());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(respInfo));
    }
    public static RespBankCard decisionMakingOperation(RestBankCard restInfo) {
        RespBankCard respInfo = new RespBankCard();
        String sqlQuery = 'SELECT Id,Name,BankCardRecordTypeDevelop__c,bankName__c,province__c,city__c,bankBranch__r.Name,bankAccount__c,user__r.Name,projectExpert__r.Name,identityInformation2__c FROM BankCard__c WHERE Id != null ';
        String recordId = restInfo.recordId;
        if (String.isEmpty(restInfo.whetherPayment) || String.isEmpty(restInfo.currencyType) || String.isEmpty(restInfo.recordId)) {
            respInfo.msg = '缺失必填！';
            return respInfo;
        }
        switch on Integer.valueOf(restInfo.whetherPayment) {
            when 0 {
                sqlQuery += ' AND user__c=:recordId ';
            }
            when 1 {
                sqlQuery += ' AND projectExpert__r.ExpertID__c =:recordId ';
            }
        }
        switch on Integer.valueOf(restInfo.currencyType) {
            when 0 {
                sqlQuery += ' AND BankCardRecordTypeDevelop__c =\'RecordType2\'';
            }
            when 1 {
                sqlQuery += ' AND BankCardRecordTypeDevelop__c =\'BankOfDollar\'';
            }

        }
        List<BankCard__c> bankCards = (List<BankCard__c>) Database.query(sqlQuery);
        if (!bankCards.isEmpty()) {
            List<BankCard> bankCards2 = new List<BankCard>();
            for (BankCard__c bankCard : bankCards) {
                BankCard bankCard2 = new BankCard();
                bankCard2.bankNumber = bankCard.Name;
                bankCard2.bankName = bankCard.bankName__c;
                bankCard2.province = bankCard.province__c;
                bankCard2.city = bankCard.city__c;
                bankCard2.bankBranchName = bankCard.bankBranch__r.Name;
                bankCard2.bankCardNumber = bankCard.bankAccount__c;
                if(Integer.valueOf(restInfo.whetherPayment) == 0) {
                    bankCard2.userName = bankCard.user__r.Name;
                }
                if(Integer.valueOf(restInfo.whetherPayment) == 1) {
                    bankCard2.userName = bankCard.projectExpert__r.Name;
                }
                bankCard2.idCard = bankCard.identityInformation2__c;
                bankCards2.add(bankCard2);
            }
            respInfo.bankCards = bankCards2;
        }
        return respInfo;
    }
    global class RestBankCard {
        public String whetherPayment { get; set; }//是否垫付
        public String currencyType { get; set; }//币种类型
        public String recordId { get; set; }//项目专家上（专家自定义Id/员工Id）二提一
    }
    global class RespBankCard {
        public Integer code;
        public String msg;
        public List<BankCard> bankCards;
        public RespBankCard() {
            this.code = 0;
            this.msg = '';
        }
    }
    global class BankCard {
        public String bankNumber {get;set;}
        public String bankName { get; set; }
        public String province { get; set; }
        public String city { get; set; }
        public String bankBranchName { get; set; }
        public String bankCardNumber {get;set;}
        public String userName { get; set; }
        public String idCard { get; set; }
    }
}