({
	handleCompEvent : function(component, event, helper) {
        alert('Event Caught in ->'+component.get('v.Id')+' Message: ');
        component.set('v.message',event.getParam('message'));
		
	},
    handleApplEvent : function(component, event, helper) {
        alert('Event Caught in ->'+component.get('v.Id')+' Message: ');
        component.set('v.message',event.getParam('message'));
		
	}
})