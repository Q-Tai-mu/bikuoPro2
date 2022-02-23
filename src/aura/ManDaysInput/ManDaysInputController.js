({
    myAction : function(component, event, helper) {

    },

    handlesubmit : function(component, event, helper) {
        var downList = component.get('v.downList');
        console.log(JSON.stringify(downList));
        if ( JSON.stringify(downList) == "[]") {
            alert("请添加项目！");
            return
        }
        
        var itemsList = component.get('v.itemsList');
        console.log(itemsList);
        downList.forEach(e => {
            console.log(e)
            var obj2 = {    
                            Id: e.account__c,
                            Name : e.account__c == undefined ? undefined : e.account__r.Name
                        };
                        
            var obj1 = {
                        Id:e.Id ,
                        Name : e.Name, 
                        account__c: e.account__c,
                        account__r: obj2 == undefined ? undefined : obj2
                        };

            var newobj ={
                type: 'new',
                Id: Math.floor(Math.random()*(999999-100000))+100000,
                projectName__c :e.Id,
                projectName__r: obj1,
            };


            itemsList.forEach(element => {
                newobj.Custom_date__c = element.Custom_date__c;
                newobj.index = element.project.length + 1  ;

                console.log(newobj.projectName__r.Name)
                console.log(newobj.index)
                console.log(element.date)

                console.log('+++++++++++++++++++++++++++++++++++++')

                var isExist = false;
                element.project.forEach(p => {
                    if ( p.projectName__c == newobj.projectName__c) {
                        isExist = true;
                    }
                });
                if (isExist == false) {
                console.log('*********************')
                console.log(newobj)
                console.log('*********************')

                    element.project.push(newobj);
                }

            });
        });
        console.log(itemsList);
        component.set('v.itemsList', itemsList);
        

        component.set("v.isModalOpen", false);

        var querySelectedList = [];
        component.set('v.querySelectedList', querySelectedList);

        // var queryResultList = [];
        // component.set('v.queryResultList', queryResultList);
    },

    handleopenModel : function(component, event, helper) {
        component.set("v.isModalOpen", true);
        helper.helperQueryBefore(component, event, helper);

        // 本周默认显示上一周的项目列表 以便移除
        var downList1 = component.get('v.downList');
        console.log(JSON.stringify(downList1));
        if(JSON.stringify(downList1) == "[]"){
            console.log('本周默认显示上一周的项目列表 以便移除');

            var action1 = component.get("c.getManDaysInfoP");
                    
            action1.setCallback(this, function (response) {
                var state = response.getState();
                //请求成功
                if (state == "SUCCESS") 
                {
                    var respValue1 = response.getReturnValue();
                    console.log(789);
                    console.log(respValue1.queryResult);
                    var downList = [];
                    respValue1.queryResult.forEach(e => {
                        console.log(e)
                        var obj2 = {Id:e.projectName__r.account__r.Id,Name:e.projectName__r.account__r.Name}
                        var obj1 = {Id:e.projectName__c,Name:e.projectName__r.projectManager__r.Name}
                        var obj = {
                            Id: e.projectName__c, 
                            Name: e.projectName__r.Name,
                            projectManager__r: obj1,
                            projectStatus__c: e.projectName__r.projectStatus__c,
                            projectStart__c: e.projectName__r.projectStart__c,
                            projectStop__c: e.projectName__r.projectStop__c,
                            account__r:obj2,
                            account__c:e.projectName__r.account__c
                        }
                        downList.push(obj);
                    });
                    component.set('v.downList', downList);
                    
                }
            });
            $A.enqueueAction(action1);

            var downList = component.get('v.downList');
            console.log(itemsListForDownList); 
            console.log(querySelectedList); 
            querySelectedList.forEach(element => {
                queryResultList.forEach(e => {
                    if (element == e.Id) {
                        downList.push(e);
                    }
                });
            });
            console.log(downList);
            component.set('v.downList', downList);
        }

    },

    handlecloseModel : function(component, event, helper) {
        
        component.set("v.isModalOpen", false);
        var querySelectedList = [];
        component.set('v.querySelectedList', querySelectedList);
        // var downList = [];
        // component.set('v.downList', downList);
        var queryResultList = [];
        component.set('v.queryResultList', queryResultList);

    },
    handleQuery : function(component, event, helper) {
        
        helper.helperQuery(component, event, helper);
    },



    handleopenModel2 : function(component, event, helper) {
        component.set("v.isModal2Open", true);
    },
    handlecloseModel2 : function(component, event, helper) {
        
        component.set("v.isModal2Open", false);
        var querySelectedAccList = [];
        component.set('v.querySelectedAccList', querySelectedAccList);

    },    
    handleQuery2 : function(component, event, helper) {
        
        helper.helperQuery2(component, event, helper);
    },



    handlesubmit2 : function(component, event, helper) {
        var selectedAcc = component.get('v.selectedAcc');
        console.log(JSON.stringify(selectedAcc));
        if ( JSON.stringify(selectedAcc) == "[]") alert("请添加项目！");
        
         var itemsList = component.get('v.itemsList');
         console.log(itemsList);

         var queryResultAccList = component.get('v.queryResultAccList');
         console.log(queryResultAccList);
         
         queryResultAccList.forEach(e => {

            
            if(e.Id == selectedAcc){
            var obj2 = {Id:e.Id ,Name : e.name};

            // itemsList.forEach(element => {
                // 按照index 插入
            //     element.customer__c = e.Id,
            //     element.customer__r = obj2
            // });
            }

        });
 
        

  
    },

    handleAdd : function(component, event, helper) {
        
        helper.helperAdd(component, event, helper);

        var querySelectedList = component.get('v.querySelectedList');
        console.log(querySelectedList);
        if(JSON.stringify(querySelectedList) == "[]") alert("请选择要添加的项目");
        var queryResultList = component.get('v.queryResultList');
        var downList = component.get('v.downList');
        console.log(querySelectedList); 
        console.log(queryResultList); 
        //var downList = [];
        querySelectedList.forEach(element => {
            queryResultList.forEach(e => {
                if (element == e.Id) {
                    var isExist = false;
                    downList.forEach(p => {

                        if (p.Id == element) {
                            isExist = true;
                        }
                    });

                    if (isExist == false)  downList.push(e);
                }
            });
        });
        console.log(downList);
        component.set('v.downList', downList);

    },

    
    handleremove : function(component, event, helper) {

        var selecedDownList = component.get('v.selecedDownList');
        console.log(selecedDownList);
        if(JSON.stringify(selecedDownList) == "[]") {
            alert("请选择要移除的项目");
            return
        }
        var itemsList = component.get('v.itemsList');
        
        selecedDownList.forEach(proId => {
            
            itemsList.forEach(element => {
                console.log(proId)
                console.log(element.project)
                element.project = element.project.filter(item => {return proId != item.projectName__c})
            });
        });
        console.log(itemsList);
        component.set('v.itemsList', itemsList);

        component.set("v.isModalOpen", false);
        var empty = [];
        component.set('v.selecedDownList', empty);
        

        var querySelectedList = [];
        component.set('v.querySelectedList', querySelectedList);
        // var downList = [];
        // component.set('v.downList', downList);
        var queryResultList = [];
        component.set('v.queryResultList', queryResultList);

    },

    onCheck: function(cmp, evt) {
        console.log(evt.getSource().get("v.value"));

        //var checkCmp = cmp.find("checkbox");
        console.log(evt.getSource().get("v.value"));
        console.log(evt.getSource().get("v.name"));
        var queryResultList = cmp.get('v.queryResultList');
        var querySelectedList = cmp.get('v.querySelectedList');

        if(evt.getSource().get("v.value") == true){
            console.log(evt.getSource().get("v.name"));
            querySelectedList.push(evt.getSource().get("v.name"))
            cmp.set('v.querySelectedList', querySelectedList);
            console.log(querySelectedList);

        }else{
            querySelectedList = querySelectedList.filter(item => {evt.getSource().get("v.name") != item.Id})
            cmp.set('v.querySelectedList', querySelectedList);
            console.log(querySelectedList);

        }
    },

    onCheckfordown: function(cmp, evt) {

        var selecedDownList = cmp.get('v.selecedDownList');
        if(evt.getSource().get("v.value") == true){
            selecedDownList.push(evt.getSource().get("v.name"))
            cmp.set('v.selecedDownList', selecedDownList);
            console.log(selecedDownList);

        }else{
            selecedDownList = selecedDownList.filter(item => {evt.getSource().get("v.name") != item.Id})
            cmp.set('v.selecedDownList', selecedDownList);
            console.log(selecedDownList);
        }
    },
    



        onCheck1: function(cmp, evt) {
            var checkCmp = cmp.find("checkbox1");
            console.log(checkCmp.get("v.value"));
            


        if(evt.getSource().get("v.value") == true){
            console.log(evt.getSource().get("v.name"));
            querySelectedList.push(evt.getSource().get("v.name"))
            cmp.set('v.querySelectedList', querySelectedList);
            console.log(querySelectedList);

        }else{
            querySelectedList = querySelectedList.filter(item => {evt.getSource().get("v.name") != item.Id})
            cmp.set('v.querySelectedList', querySelectedList);
            console.log(querySelectedList);

        }
    },

    onGroup: function(cmp, evt) {
        var selected = evt.getSource().get("v.text");
        console.log(selected);
        
        cmp.set('v.selectedAcc', selected);

    },

    handleClick : function (cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.label"));
    },

    
    // handlePrevious : function (component, event, helper) {
    //     helper.helperPrevious(component, event, helper);
    // },

    // handleNext : function (component, event, helper) {
    //     helper.helperNext(component, event, helper);
    // },

    handleDel : function (cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.name")+ event.getSource().get("v.value") );
        var itemsListNew = cmp.get('v.itemsList');
        let index1 = event.getSource().get("v.name");
        let Id = event.getSource().get("v.value");

        console.log('old:'+itemsListNew[0].project);

        itemsListNew.forEach(function(element) {
            if (element.index === index1 ){
                element.project = element.project.filter(item => {return item.Id != Id})
            }
          });
        console.log('new:'+itemsListNew[0].project);
        cmp.set('v.itemsList', itemsListNew);

    },

    
    handlechange: function (component, event, helper) {
        console.log(1233333);
        var itemsList = component.get('v.itemsList');
        let index1 = event.getSource().get("v.name");
        let Id = event.getSource().get("v.aura:id");
       

        itemsList.forEach(element => {
            
        });
        console.log(itemsList);
        console.log(index1);
        console.log(Id);
        console.log(event.getParam())
    },




    handlesave: function (component, event, helper) {
        helper.helperSave(component, event, helper);
    },



    handleSelect: function (component, event, helper) {
        console.log( event.getParam('id'))
        helper.helperSelect(component, event, helper);

    },

    init: function (component, event, helper) {
        helper.helperInit(component, event, helper);
    }
})