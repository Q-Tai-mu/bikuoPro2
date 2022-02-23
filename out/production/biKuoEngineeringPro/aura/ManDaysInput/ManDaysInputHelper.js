({
    helperMethod : function() {

    },
    helperInit: function (component, event, helper) {


        var action = component.get("c.getManDaysInfo");

        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
            	var respValue = response.getReturnValue();
            	console.log(respValue);

            	console.log(typeof respValue.itemsMap);
                console.log(respValue.itemsMap)

                var itemsList = [];
                var index = 1;


                respValue.DateNameList = respValue.DateNameList.sort();

                // 构造二维数组
                respValue.DateNameList.forEach(element => {
                    var index1 = 1;
                    respValue.itemsMap[element].forEach(e => {
                        e.index = index1;
                        index1 ++;
                    });
                    var one ={
                        index: index,
                        date: respValue.itemsMap[element][0].Custom_date__c,
                        project: respValue.itemsMap[element],
                    };
                    index ++ ;
                    // item.date = element[0].Custom_date__c;
                    // item.project = element;
                    itemsList.push(one);
                });


                console.log(itemsList);

                // 若本周为空 则带出上一周的itemsList
                if(itemsList.length != 0){
                    component.set('v.obj', respValue);
                    component.set('v.itemsList', itemsList);
                }else{
                    console.log(45);
                    console.log(respValue.Id);
                    var action1 = component.get("c.getManDaysInfoP");
                    action1.setParams({
                        "Action": 'Previous',
                        "CurrentId": respValue.Id
                    })
                    
                    action1.setCallback(this, function (response) {
                        var state = response.getState();
                        //请求成功
                        if (state == "SUCCESS") 
                        {
                            var respValue1 = response.getReturnValue();
                            var itemsList1 = [];
                            var index = 1;
                            respValue1.DateNameList = respValue1.DateNameList.sort();
                            console.log('123' + respValue1.DateNameList);
                            // 构造二维数组
                            respValue1.DateNameList.forEach(element => {
                                var index1 = 1;
                                respValue.itemsMap[element].forEach(e => {
                                    e.index = index1;
                                    index1 ++;
                                });
                                var one ={
                                    index: index,
                                    date: respValue1.itemsMap[element][0].Custom_date__c,
                                    project: respValue1.itemsMap[element],
                                };
                                index ++ ;
                                itemsList1.push(one);
                            });

                            console.log(itemsList);
                             component.set('v.obj', respValue);
                            component.set('v.itemsList', itemsList1);
                        }
                    });
                    $A.enqueueAction(action1);
                }
                
            	
            }
        });
        $A.enqueueAction(action);

        var serverResponse = {
                option: [
                    { id: 0, label: 0 , selected: true },
                    { id: 0.125, label: 0.125},
                    { id: 0.25, label: 0.25 },
                    { id: 0.5, label: 0.5 },
                    { id: 0.75, label: 0.75 }
                ],
                speicalProjectList: [
                    "内部管理-培训","内部管理-病假","内部管理-事假","内部管理-年假"
                ],
                projectList :[
                    { },
                    { },
                    { }
                ],
                projectSelectedList :[
                    { },
                    { },
                    { }
                ]
                // obj : { title: '2022W01(2022-01-03 ~ 2022-01-09)  本周' },
                // itemsList: [
                //     {Id:1 , date : '2021-01-03' , project: [{Id : 1, name: '疫苗调研项目', acc: ''},{Id : 2, name: 'VR眼睛消费者研究', acc: ''}] }, 
                //     {id:2 , date : '2021-01-04' , project: [{Id : 1, name: '疫苗调研项目', acc: '金成医学'},{Id : 2, name: '内部项目-BD', acc: ''}]  }
                // ]
            };
            component.set('v.options', serverResponse.option);
            component.set('v.projectList', serverResponse.projectList);
            component.set('v.projectSelectedList', serverResponse.projectSelectedList);
            component.set('v.speicalProjectList', serverResponse.speicalProjectList);
   
    },

    

    helperPrevious: function (component, event, helper) {

        var action = component.get("c.getManDaysInfoChange");
        console.log(component.get("v.obj").Id);
        action.setParams({
            "Action": 'Previous',
            "CurrentId": component.get("v.obj").Id
        })
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
            	var respValue = response.getReturnValue();
                if(respValue == null) alert("已经是最后一页！");
            	console.log(respValue);

            	console.log(typeof respValue.itemsMap);
                console.log(respValue.itemsMap)

                var itemsList = [];
                var index = 1;
                // for (var i in respValue.itemsMap) {
                //     respValue.itemsMap[i].index = index
                //     console.log(respValue.itemsMap[i]);
                //     itemsList.push(respValue.itemsMap[i]); 
                //     index ++;
                    
                // }


                respValue.DateNameList = respValue.DateNameList.sort();
                console.log('123' + respValue.DateNameList);

                // 构造二维数组
                respValue.DateNameList.forEach(element => {
                    var index1 = 1;
                    respValue.itemsMap[element].forEach(e => {
                        e.index = index1;
                        index1 ++;
                    });
                    var one ={
                        index: index,
                        date: respValue.itemsMap[element][0].Custom_date__c,
                        project: respValue.itemsMap[element],
                    };
                    index ++ ;
                    // item.date = element[0].Custom_date__c;
                    // item.project = element;
                    itemsList.push(one);
                });

                //var itemsList = Object.values(respValue.itemsMap)
                console.log(itemsList);
                component.set('v.obj', respValue);
                component.set('v.itemsList', itemsList);
            	
            }
        });
        $A.enqueueAction(action);

   
    },

    helperNext: function (component, event, helper) {

        var action = component.get("c.getManDaysInfoChange");
        console.log(component.get("v.obj").Id);
        action.setParams({
            "Action": 'next',
            "CurrentId": component.get("v.obj").Id
        })
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
            	var respValue = response.getReturnValue();
                if(respValue == null) alert("已经是最后一页！");
            	console.log(respValue);

            	console.log(typeof respValue.itemsMap);
                console.log(respValue.itemsMap)

                var itemsList = [];
                var index = 1;
                // for (var i in respValue.itemsMap) {
                //     respValue.itemsMap[i].index = index
                //     console.log(respValue.itemsMap[i]);
                //     itemsList.push(respValue.itemsMap[i]); 
                //     index ++;
                    
                // }


                respValue.DateNameList = respValue.DateNameList.sort();
                console.log('123' + respValue.DateNameList);

                // 构造二维数组
                respValue.DateNameList.forEach(element => {
                    var index1 = 1;
                    respValue.itemsMap[element].forEach(e => {
                        e.index = index1;
                        index1 ++;
                    });
                    var one ={
                        index: index,
                        date: respValue.itemsMap[element][0].Custom_date__c,
                        project: respValue.itemsMap[element],
                    };
                    index ++ ;
                    // item.date = element[0].Custom_date__c;
                    // item.project = element;
                    itemsList.push(one);
                });

                //var itemsList = Object.values(respValue.itemsMap)
                console.log(itemsList);
                component.set('v.obj', respValue);
                component.set('v.itemsList', itemsList);
            	
            }
        });
        $A.enqueueAction(action);

   
    },



    helperQuery: function (component, event, helper) {

        var action = component.get("c.queryProject");
        console.log(component.get("v.queryKeyStr"));
        action.setParams({
            "KeyStr": component.get("v.queryKeyStr") == undefined ? '' : component.get("v.queryKeyStr") 
        })
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
            	var respValue = response.getReturnValue();
            	console.log(respValue);
                component.set('v.queryResultList', respValue);

            }
        });
        $A.enqueueAction(action);

   
    },
    

    helperQueryBefore: function (component, event, helper) {

        var action = component.get("c.queryProjectBefore");
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
            	var respValue = response.getReturnValue();
            	console.log(respValue);
                component.set('v.queryResultList', respValue);

            }
        });
        $A.enqueueAction(action);
    },

    helperAdd : function (component, event, helper) {

        //console.log(component.get('v.queryResultList'));
    },



    helperQuery2: function (component, event, helper) {

        var action = component.get("c.queryAcc");
        console.log(component.get("v.queryAccKeyStr"));
        action.setParams({
            "KeyStr": component.get("v.queryAccKeyStr") == undefined ? '' : component.get("v.queryAccKeyStr") 
        })
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
            	var respValue = response.getReturnValue();
            	console.log(respValue);
                component.set('v.queryResultAccList', respValue);

            }
        });
        $A.enqueueAction(action);

   
    },

})