import { LightningElement,wire,track } from 'lwc';
import  allLWCComponentBundles  from '@salesforce/apex/LWCDetailsHelper.getLWCComponentAndResourceBundle'
import { publish, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/lwcnavigator__c';

export default class Lwcnavigator extends LightningElement {

    @wire(MessageContext)
    messageContext;

    @track
    mapkeyvaluestore = [];

    @wire(allLWCComponentBundles)
    getAllLWC(result)
    {
        if(result.data){
           //this.mapkeyvaluestore = JSON.parse(result.data);
           this.mapkeyvaluestore = JSON.parse(result.data);
           //console.log(JSON.stringify(this.mapkeyvaluestore,null,2));
        }
        
    }

    handleSelectedComponent(event){
        
        const payload = { 
            lwcId: event.currentTarget.dataset.lwcid,
            lwcName: event.currentTarget.dataset.lwcname 
        };
        console.log(payload);
        publish(this.messageContext, recordSelected, payload);
    }
    }

