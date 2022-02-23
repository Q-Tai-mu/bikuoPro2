({
    myAction : function(component, event, helper) {

    },

    handlesubmit : function(component, event, helper) {
        var downList = component.get('v.downList');
        console.log(JSON.stringify(downList));
        if ( JSON.stringify(downList) == "[]") alert("请添加项目！");
        
        var itemsList = component.get('v.itemsList');
        console.log(itemsList);
        downList.forEach(e => {
            console.log(e.Name)
            var obj1 = {Id:e.Id ,Name : e.Name};
            //var obj2 = {Id:e.customer__c ,Name : e.customer__r.name};
            var newobj ={
                Id: '',
                projectName__c :e.Id,
                projectName__r: obj1,
                //customer__c: e.customer__c,
                //customer__r: obj2,
            };
            console.log(123);


            itemsList.forEach(element => {
                newobj.Custom_date__c = element.Custom_date__c;
                element.project.push(newobj);
            });
        });
        console.log(itemsList);
        component.set('v.itemsList', itemsList);
        

        component.set("v.isModalOpen", false);
        var querySelectedList = [];
        component.set('v.querySelectedList', querySelectedList);
        var downList = [];
        component.set('v.downList', downList);
        var queryResultList = [];
        component.set('v.queryResultList', queryResultList);
    },

    handleopenModel : function(component, event, helper) {
        component.set("v.isModalOpen", true);
        helper.helperQueryBefore(component, event, helper);
    },

    handlecloseModel : function(component, event, helper) {
        
        component.set("v.isModalOpen", false);
        var querySelectedList = [];
        component.set('v.querySelectedList', querySelectedList);
        var downList = [];
        component.set('v.downList', downList);
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
                    downList.push(e);
                }
            });
        });
        console.log(downList);
        component.set('v.downList', downList);

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

    
    handlePrevious : function (component, event, helper) {
        helper.helperPrevious(component, event, helper);
    },

    handleNext : function (component, event, helper) {
        helper.helperNext(component, event, helper);
    },

    handleDel : function (cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.name")+ event.getSource().get("v.value") );
        var itemsListNew = cmp.get('v.itemsList');
        let index1 = event.getSource().get("v.name");
        let index2 = event.getSource().get("v.value");

        console.log('old:'+itemsListNew[0].project);

        itemsListNew.forEach(function(element) {
            if (element.index === index1 ){
                element.project = element.project.filter(item => {return item.index != index2})
            }
          });
        console.log('new:'+itemsListNew[0].project);
        cmp.set('v.itemsList', itemsListNew);

    },
    init: function (component, event, helper) {
        helper.helperInit(component, event, helper);
    }
})