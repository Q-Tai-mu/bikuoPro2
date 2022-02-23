public with sharing class ToolUtil {
    public ToolUtil() {
        
    }
    public static void SendEmailTemplate(String templateName,Id userId,Id RecordId,List<string> addressesList){

    	List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName =:templateName];
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setTemplateId(lstEmailTemplates[0].Id);
		mail.setSaveAsActivity(false);
		if(userId != null){
		   mail.setTargetObjectId(userId);
		}
		if(addressesList.size() >0){
            mail.setToAddresses(addressesList);
		}
		mail.setWhatId(RecordId); 
		Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}