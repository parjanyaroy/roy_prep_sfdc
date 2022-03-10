import { LightningElement,wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/lwcnavigator__c';

export default class Lwcviewercontainer extends LightningElement {

    @wire(MessageContext)
    messageContext;

    handleeditorreload(event)
    {
        const data = event.detail;
        console.log(JSON.stringify(data));
        this.template.querySelector('c-lwc-editor-window').reloadComponentBundle();
        const payload = { 
            lwcId: event.detail.selectedComponentId,
            lwcName: event.detail.selectedComponentName 
        };
        console.log(payload);
        //publish(this.messageContext, recordSelected, payload);
    }
}