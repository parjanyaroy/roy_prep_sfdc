import { LightningElement , wire } from 'lwc';
import { MessageContext , publish } from 'lightning/messageService';
//import samchannel from '@salesforce/messageChannels/sample_Channel__c';



export default class Child extends LightningElement {

    @wire(MessageContext)
    context;

    sampledata = {
        id : '001',
        name : 'Child Name'
    }

    raiseCustomEvent()
    {
        console.log('Firing Event from Child');
        this.dispatchEvent(new CustomEvent('notify', { 
            detail : this.sampledata ,
            bubbles : true,
            composed : true
        }));
    }

    posttochannel()
    {
        payload = { 
            id : '01',
            name : 'Roy'
        }
        publish(context,samchannel , payload);
    }

}