({
    helperMethod : function() {

    },
    helperInit: function (component, event, helper) {


        var action = component.get("c.getManDaysInfo");
        action.setParams({
            "weekRencentlyName": '本周',
        })

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

                    var action1 = component.get("c.getManDaysInfoP");
                    
                    action1.setCallback(this, function (response) {
                        var state = response.getState();
                        //请求成功
                        if (state == "SUCCESS") 
                        {
                            var respValue1 = response.getReturnValue();
                            console.log(789);
                            console.log(respValue1.queryResult);

                            // 构造二维数组
                            var itemsListNew = [];
                            var ws = respValue.weekStart;

                            for (let i = 0; i < respValue.daysCount; i++) {

                                var projectNew = [];
                                var index = 1;
                                respValue1.queryResult.forEach(element => {
                                    // 因为是从上一周带出的人天数据，给假Id
                                    element.Id  =  Math.floor(Math.random()*(999999-100000))+100000 ;
                                    element.type = 'new';
                                    // 并更改查找Id  (work day)
                                    element.workDay__c = respValue.Id;

                                    // 并更改日期
                                    // 日期问题待解决
                                    //element.Custom_date__c = ws2;

                                    element.index = index;
                                    projectNew.push(element);
                                    index++;
                                });

                                var one ={
                                    index: i + 1,
                                    date: ws,
                                    project: projectNew,
                                };
                                itemsListNew.push(one);

                                // 造日期
                                var wsDate = new Date(ws);
                                wsDate = wsDate.setDate(wsDate.getDate()+1);
                                var wsDate1 = new Date(wsDate);
    
                                var year = wsDate1.getFullYear(); 
                                var month =(wsDate1.getMonth() + 1).toString(); 
                                var day = (wsDate1.getDate()).toString();  
                                if (month.length == 1) { 
                                    month = "0" + month; 
                                } 
                                if (day.length == 1) { 
                                    day = "0" + day; 
                                }
                                ws = year + "-" + month + "-" + day;
                                
                            }
                            console.log(itemsListNew)
                            console.log(45);
                            component.set('v.obj', respValue);
                            component.set('v.itemsList', itemsListNew);
                            
                        }
                    });
                    $A.enqueueAction(action1);
                }
                
            	
            }
        });
        $A.enqueueAction(action);

        var serverResponse = {
                option: [
                    { id: 1, label: 0 , selected: true },
                    { id: 2, label: 0.125},
                    { id: 3, label: 0.25 },
                    { id: 4, label: 0.5 },
                    { id: 5, label: 0.75 }
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
                
            };
            component.set('v.options', serverResponse.option);
            component.set('v.projectList', serverResponse.projectList);
            component.set('v.projectSelectedList', serverResponse.projectSelectedList);
            component.set('v.speicalProjectList', serverResponse.speicalProjectList);
            component.set('v.tabs', [
                {
                    id: '上上周',
                    label: '上上周',
                },
                {
                    id: '上周',
                    label: '上周',
                }, 
                {
                id: '本周',
                label: '本周',
                }
        ]);



       
   
    },


     
    helperSelect: function (component, event, helper) {

        console.log( event.getParam('id'))

        var action = component.get("c.getManDaysInfo");
        action.setParams({
            "weekRencentlyName": event.getParam('id'),
        })
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

                    var action1 = component.get("c.getManDaysInfoP");
                    
                    action1.setCallback(this, function (response) {
                        var state = response.getState();
                        //请求成功
                        if (state == "SUCCESS") 
                        {
                            var respValue1 = response.getReturnValue();
                            console.log(789);
                            console.log(respValue1.queryResult);

                            // 构造二维数组
                            var itemsListNew = [];
                            var ws = respValue.weekStart;

                            for (let i = 0; i < respValue.daysCount; i++) {

                                var projectNew = [];
                                var index = 1;
                                respValue1.queryResult.forEach(element => {
                                    // 因为是从上一周带出的人天数据，故删除Id
                                    delete element.Id;

                                    // 并更改查找Id  (work day)
                                    element.workDay__c = respValue.Id;

                                    // 并更改日期
                                    // 日期问题待解决
                                    //element.Custom_date__c = ws2;

                                    element.index = index;
                                    projectNew.push(element);
                                    index++;
                                });

                                var one ={
                                    index: i + 1,
                                    date: ws,
                                    project: projectNew,
                                };
                                itemsListNew.push(one);

                                // 造日期
                                var wsDate = new Date(ws);
                                wsDate = wsDate.setDate(wsDate.getDate()+1);
                                var wsDate1 = new Date(wsDate);
    
                                var year = wsDate1.getFullYear(); 
                                var month =(wsDate1.getMonth() + 1).toString(); 
                                var day = (wsDate1.getDate()).toString();  
                                if (month.length == 1) { 
                                    month = "0" + month; 
                                } 
                                if (day.length == 1) { 
                                    day = "0" + day; 
                                }
                                ws = year + "-" + month + "-" + day;
                                
                            }
                            console.log(itemsListNew)
                            console.log(45);
                            component.set('v.obj', respValue);
                            component.set('v.itemsList', itemsListNew);
                        }
                    });
                    $A.enqueueAction(action1);
                }
                
            	
            }
        });
        $A.enqueueAction(action);
        

   
    },

    

    // helperPrevious: function (component, event, helper) {

    //     var action = component.get("c.getManDaysInfoChange");
    //     console.log(component.get("v.obj").Id);
    //     action.setParams({
    //         "Action": 'Previous',
    //         "CurrentId": component.get("v.obj").Id
    //     })
        
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         //请求成功
    //         if (state == "SUCCESS") 
    //         {
    //         	var respValue = response.getReturnValue();
    //             if(respValue == null) alert("已经是最后一页！");
    //         	console.log(respValue);

    //         	console.log(typeof respValue.itemsMap);
    //             console.log(respValue.itemsMap)

    //             var itemsList = [];
    //             var index = 1;
    //             // for (var i in respValue.itemsMap) {
    //             //     respValue.itemsMap[i].index = index
    //             //     console.log(respValue.itemsMap[i]);
    //             //     itemsList.push(respValue.itemsMap[i]); 
    //             //     index ++;
                    
    //             // }


    //             respValue.DateNameList = respValue.DateNameList.sort();
    //             console.log('123' + respValue.DateNameList);

    //             // 构造二维数组
    //             respValue.DateNameList.forEach(element => {
    //                 var index1 = 1;
    //                 respValue.itemsMap[element].forEach(e => {
    //                     e.index = index1;
    //                     index1 ++;
    //                 });
    //                 var one ={
    //                     index: index,
    //                     date: respValue.itemsMap[element][0].Custom_date__c,
    //                     project: respValue.itemsMap[element],
    //                 };
    //                 index ++ ;
    //                 // item.date = element[0].Custom_date__c;
    //                 // item.project = element;
    //                 itemsList.push(one);
    //             });

    //             //var itemsList = Object.values(respValue.itemsMap)
    //             console.log(itemsList);
    //             component.set('v.obj', respValue);
    //             component.set('v.itemsList', itemsList);
            	
    //         }
    //     });
    //     $A.enqueueAction(action);

   
    // },

    // helperNext: function (component, event, helper) {

    //     var action = component.get("c.getManDaysInfoChange");
    //     console.log(component.get("v.obj").Id);
    //     action.setParams({
    //         "Action": 'next',
    //         "CurrentId": component.get("v.obj").Id
    //     })
        
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         //请求成功
    //         if (state == "SUCCESS") 
    //         {
    //         	var respValue = response.getReturnValue();
    //             if(respValue == null) alert("已经是最后一页！");
    //         	console.log(respValue);

    //         	console.log(typeof respValue.itemsMap);
    //             console.log(respValue.itemsMap)

    //             var itemsList = [];
    //             var index = 1;
    //             // for (var i in respValue.itemsMap) {
    //             //     respValue.itemsMap[i].index = index
    //             //     console.log(respValue.itemsMap[i]);
    //             //     itemsList.push(respValue.itemsMap[i]); 
    //             //     index ++;
                    
    //             // }


    //             respValue.DateNameList = respValue.DateNameList.sort();
    //             console.log('123' + respValue.DateNameList);

    //             // 构造二维数组
    //             respValue.DateNameList.forEach(element => {
    //                 var index1 = 1;
    //                 respValue.itemsMap[element].forEach(e => {
    //                     e.index = index1;
    //                     index1 ++;
    //                 });
    //                 var one ={
    //                     index: index,
    //                     date: respValue.itemsMap[element][0].Custom_date__c,
    //                     project: respValue.itemsMap[element],
    //                 };
    //                 index ++ ;
    //                 // item.date = element[0].Custom_date__c;
    //                 // item.project = element;
    //                 itemsList.push(one);
    //             });

    //             //var itemsList = Object.values(respValue.itemsMap)
    //             console.log(itemsList);
    //             component.set('v.obj', respValue);
    //             component.set('v.itemsList', itemsList);
            	
    //         }
    //     });
    //     $A.enqueueAction(action);

   
    // },



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


    helperSave: function (component, event, helper) {

        var itemsList = component.get("v.itemsList");
        console.log(itemsList)

        // 保存前工时校验：
        itemsList.forEach(element => {
            let total = 0;
            element.project.forEach(e => {
                total = total + e.timeConfirm__c;
            });

            console.log(total)
            if (total > 1) {
                alert("保存失败：日期为" + element.date + "工时大于1天！")
                return false;
            }
        });


        
        return false;

        var param = []; 
        itemsList.forEach(element => {
            element.project.forEach(e => {

                var obj = {
                    projectName: e.projectName__c,
                    timeConfirm: e.timeConfirm__c,
                    workDay: e.workDay__c,
                    Custom_date: e.Custom_date__c
                            }
                param.push(obj);
            });
        });
        console.log(JSON.stringify(param));

        var action = component.get("c.saveManDaysInfo");
        action.setParams({
            paramStr: JSON.stringify(param)
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            //请求成功
            if (state == "SUCCESS") 
            {
                var respValue = response.getReturnValue();
                if(respValue == '保存失败') alert("保存失败");
                if(respValue == '保存成功') alert("保存成功");
            }
        });
        $A.enqueueAction(action);
    },


      // 日期转String通用方法
    　dateToString: function(date){ 
        var year = date.getFullYear(); 
        var month =(date.getMonth() + 1).toString(); 
        var day = (date.getDate()).toString();  
        if (month.length == 1) { 
            month = "0" + month; 
        } 
        if (day.length == 1) { 
            day = "0" + day; 
        }
        var dateTime = year + "-" + month + "-" + day;
        return dateTime; 
      },
})