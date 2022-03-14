import { LightningElement,track,api } from 'lwc';
import deleteLWC from '@salesforce/apex/LWCDetailsHelper.deleteLWCBundleAndResource';

export default class deleteLwcModal extends LightningElement {
    
    @track isDeleteLWC = false;
    @api lwcIdForDelete ; 
    @api lwcNameForDelete ; 
    @api openModal() {
        this.isDeleteLWC = true;
    }
    closeModal() {
        this.isDeleteLWC = false;
        this.lwcIdForDelete = null;
        this.lwcNameForDelete = null;
        
    }
    deletelwc() {
        this.isDeleteLWC = false;
        deleteLWC({lwcBundleId : this.lwcIdForDelete})
        .then(response => {
            if(response===true)
            {
                location.reload();
            }
        });
        
    }
}