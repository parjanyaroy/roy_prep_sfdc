import { LightningElement,track,api } from 'lwc';
export default class ModalPopupLWC extends LightningElement {
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    @track responseList = [] ;
    @track columns = [{
        label: 'Id',
        fieldName: 'Id',
        type: 'text',
        sortable: true
    },
    {
        label: 'Component Name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Format ',
        fieldName: 'Format',
        type: 'text',
        sortable: true
    },
    {
        label: 'Message',
        fieldName: 'Message',
        type: 'text',
        sortable: true
    },
    {
        label: 'Status',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    }
];
    
    @api
    openModal(changedBundleResponseArray) {
        this.responseList=changedBundleResponseArray;
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    resetModalComponent(){
        this.responseList = [];
    }
}