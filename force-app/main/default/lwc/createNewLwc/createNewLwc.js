import { LightningElement,track,wire,api } from 'lwc';

export default class CreateNewLwc extends LightningElement {//Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    
    newComponentName;

    handleNewCompName(event)
    {
        this.newComponentName = event.target.value;
    }
    @api openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
}