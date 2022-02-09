({
	handleCompEvent : function(component, event, helper) {
        alert('Event Caught in ->'+component.get('v.Id')+' Message: ');
        component.set('v.message',event.getParam('message'));
		
	},
    handleApplEvent : function(component, event, helper) {
        alert('Event Caught in ->'+component.get('v.Id')+' Message: ');
        component.set('v.message',event.getParam('message'));
		
	},
    fireCompEvent : function(component, event, helper) {
        var evt = component.getEvent("childCompEvent");
        evt.setParams({'message':'Component Event Fired from ->'+component.get('v.Id')});
        evt.fire();
		
	},
    fireApplEvent :function(component, event, helper) {
        var evt = $A.get("e.c:ApplicationEvent");
        evt.setParams({'message':'Application Event Fired from ->'+component.get('v.Id')});
        evt.fire();
    },
    passMessage : function(component, event, helper)
    {
    alert('hi');
	}
})