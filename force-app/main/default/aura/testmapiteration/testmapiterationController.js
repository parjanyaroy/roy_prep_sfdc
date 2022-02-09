({
     getMapRecords : function(cmp){
        var action = cmp.get("c.getMapOfRecords");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultRecords = response.getReturnValue();
                var resultArray = [];
                var parsed = JSON.parse(resultRecords);
                for(var entry in parsed)
                {
                    resultArray.push({crnumber : parsed[entry].crNumber,wrapper : parsed[entry].tr});
                }
                console.log(JSON.stringify(response.getReturnValue()));
                cmp.set("v.testmessage",resultArray);
            }
        });
	 $A.enqueueAction(action);
    },
    checkStatus : function(cmp, event, helper)
    {
    alert(event.getSource().get('v.label'));
	},
    doSomething: function(cmp, event, helper) {
        var button = event.getSource().get("v.name");
        alert(button);
    }
})