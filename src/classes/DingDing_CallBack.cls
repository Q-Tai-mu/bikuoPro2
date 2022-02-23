/**********************************************************************
 * 
 *
 * @url: /services/apexrest/DingDing_CallBack
 * @data:
 *  {
        
    }
*************************************************************************/
//package com.controller;

@RestResource(urlMapping='/DingDing_CallBack')
global with sharing class DingDing_CallBack {
    @HttpPost
    global static Map<string,string> doPost() {
    	Map<string,string> responseMap = new Map<string,string>();
    	RestRequest req = RestContext.request;
    	AppInput input = new AppInput(); 
    	input = (AppInput)JSON.deserialize(req.requestBody.toString(), AppInput.class);
    	Map<string,string> header = RestContext.request.params;
    	responseMap.put('msg_signature',header.get('msg_signature'));
    	responseMap.put('timeStamp',header.get('timestamp'));
    	responseMap.put('nonce',header.get('nonce'));
    	responseMap.put('encrypt',input.encrypt);
    	system.debug('responseMap'+responseMap);
        return responseMap;
    }
    global class AppInput{
        public String encrypt;


    }
}