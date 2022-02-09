({
	 doInit: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Full Name', fieldName: 'Name', type: 'text'},
            { label: 'Income', fieldName: 'Income__c', type: 'currency',typeAttributes: { currencyCode: 'INR'}},
            { label: 'Status', fieldName: 'Status__c', type: 'text'}
        ]);
        var sampleData ={
                    id: 'a',
                    Name: 'Sample Data',
                    Income__c: 25000,
                    Status__c: 'Active'
                };
         var getAllIncomeDetail = cmp.get("c.getAllIncomeDetail");
         getAllIncomeDetail.setCallback(this,function(response){
             var incomeRecords =response.getReturnValue();
             //incomeRecords.push(sampleData);
             cmp.set('v.mydata', incomeRecords);
         })
         $A.enqueueAction(getAllIncomeDetail);
    },
    
    addDetails : function (cmp,evt,helper)
    {
    	var fullName = cmp.find('fullname').get("v.value");
        var income = cmp.find('income').get("v.value");
        var status = cmp.find('status').get("v.value");
        var saveDetail = cmp.get("c.saveIncomeRecord");
        saveDetail.setParams( {'fullName' : fullName,
                              'income' : income,
                             'status' : status});
        saveDetail.setCallback(this, function(response){
            console.log(response.getReturnValue());
        })
        $A.enqueueAction(saveDetail)
	},
     handleDeleteRecord: function(component, event, helper) {
        component.find(event.getSource().get("v.name")).deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                console.log("Record is deleted.");
            } else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                console.log('Problem deleting record, error: ' + JSON.stringify(deleteResult.error));
            } else {
                console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
            }
        }));
    }
})