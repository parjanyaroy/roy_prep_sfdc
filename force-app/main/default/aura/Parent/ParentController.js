({
	handleCompEvent : function(component, event, helper) {
        alert('Event Caught in ->'+component.get('v.Id')+' Message: ');
        component.set('v.message',event.getParam('message'));
		
	},
    handleApplEvent : function(component, event, helper) {
        alert('Event Caught in ->'+component.get('v.Id')+' Message: ');
        component.set('v.message',event.getParam('message'));
		
	},
    invokeChildMethod : function(component,event,helper){
        var childMethod1 = component.find("child1");
        alert(childMethod1);
        var message = childMethod1.childMethod();
    }
})