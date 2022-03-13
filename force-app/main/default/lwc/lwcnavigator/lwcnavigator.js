import { LightningElement,wire,track } from 'lwc';
import  allLWCComponentBundles  from '@salesforce/apex/LWCDetailsHelper.getLWCComponentAndResourceBundle'
import { publish, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/lwcnavigator__c';

export default class Lwcnavigator extends LightningElement {

    @wire(MessageContext)
    messageContext;

    @track
    mapkeyvaluestore = [];

    // ------ For Delete Modal -----------c/createNewLwc
    deleteConfirmationCompName ; 
    deleteConfirmationCompId ; 
    isDeleteConfirmationDisplayed = false;


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

    deleteSelectedComponent(event){
        this.deleteConfirmationCompId= event.currentTarget.dataset.lwcid;
        this.deleteConfirmationCompName= event.currentTarget.dataset.lwcname;
        this.isDeleteConfirmationDisplayed=true;
        console.log(this.deleteConfirmationCompId,this.deleteConfirmationCompName,this.isDeleteConfirmationDisplayed);
        this.template.querySelector('c-delete-lwc-modal').openModal();
    }

    handleDisplayNewLWCModal()
    {
        this.template.querySelector('c-create-new-lwc').openModal();

    }
    }

