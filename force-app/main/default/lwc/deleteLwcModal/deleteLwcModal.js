import { LightningElement,track,api } from 'lwc';

export default class deleteLwcModal extends LightningElement {
    
    @track isDeleteLWC = false;
    @api lwcIdForDelete ; 
    @api lwcNameForDelete ; 
    @api openModal() {
        this.isDeleteLWC = true;
    }
    closeModal() {
        this.isDeleteLWC = false;
        this.dispatchEvent(new CustomEvent('discardchanges'));
    }
    deletelwc() {
        this.isDeleteLWC = false;
        this.dispatchEvent(new CustomEvent('submitchanges'));
    }
}