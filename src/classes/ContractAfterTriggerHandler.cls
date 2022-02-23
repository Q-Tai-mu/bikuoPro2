/**
 * Created by tko18 on 2022/2/16.
 */
/**
*@ClassName:Lin-Tui
*@Description:TODO
*@Authortko18
*@Date 2022/2/16 13:46
*@Version:1.0.0
**/
public with sharing class ContractAfterTriggerHandler implements Triggers.Handler {
    public void handle() {
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            Map<String, List<Contract>> contractMap = new Map<String, List<Contract>>();
            for (Contract contract : (List<Contract>) Trigger.new) {
                if (!contractMap.containsKey(contract.currency__c)) {
                    contractMap.put(contract.currency__c, new List<Contract>());
                }
                contractMap.get(contract.currency__c).add(contract);
            }
            for (ExchangeRate__c exchangeRate : [SELECT Id,primaryCurrency__c,exchangeRate__c FROM ExchangeRate__c WHERE primaryCurrency__c IN:contractMap.keySet()]) {
                List<Contract> contracts = contractMap.get(exchangeRate.primaryCurrency__c);
                if (contracts != null) {
                    for (Contract contract : contracts) {
                        contract.tax__c = exchangeRate.exchangeRate__c;
                    }
                }
            }


        }
    }
}