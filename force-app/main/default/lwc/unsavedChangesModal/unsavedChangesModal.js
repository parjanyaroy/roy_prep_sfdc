import { LightningElement,track,api } from 'lwc';

export default class UnsavedChangesModal extends LightningElement {
    
    @track isUnsavedChangesModalOpen = false;
    @api openModal() {
        this.isUnsavedChangesModalOpen = true;
    }
    closeModal() {
        this.isUnsavedChangesModalOpen = false;
        this.dispatchEvent(new CustomEvent('discardchanges'));
    }
    submitDetails() {
        this.isUnsavedChangesModalOpen = false;
        this.dispatchEvent(new CustomEvent('submitchanges'));
    }
}