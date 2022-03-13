import { LightningElement,track,wire,api } from 'lwc';
import createNewLWC from '@salesforce/apex/LWCDetailsHelper.createNewLWC'

export default class CreateNewLwc extends LightningElement {//Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    disableSaveButton = false;
    newComponentName;
    lwccretionresponse = [];
    isSaveDisabled = false;
    
    columns = [
        { label: 'Component Path', fieldName: 'name' },
        { label: 'Creation Status', fieldName: 'success' }
    ];

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
        location.reload();
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isSaveDisabled=true;
        createNewLWC({componentName : this.newComponentName})
        .then(response =>{
            console.log(response);
            this.lwccretionresponse = response;
        }); 
        lwccretionresponse=[];
        newComponentName='';
    }
}