import { LightningElement , wire , track , api } from 'lwc';
import getResourceBundleForId from '@salesforce/apex/LWCDetailsHelper.getResourceBundleForId';
import saveLWCBundles from '@salesforce/apex/LWCDetailsHelper.saveLWCBundles'
import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext 
} from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/lwcnavigator__c';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import highlightminjs from '@salesforce/resourceUrl/HighlightMinJS';


export default class LwcEditorWindow extends LightningElement {
    subscription = null;
    @api selectedComponentId = null;
    @api selectedComponentName = null;
    selectedComponentBundleData = null ;
    isLoading = false;
    @wire(MessageContext)
    messageContext;
    lwcBundleChangeList = [];
    lwcBundleChangeListSize = this.lwcBundleChangeList.length+' unsaved changes!';
    // -- Needed in the MODAL ---
    lwcBundleChangeResponse = [];

    refreshBundleData()
    {
        //this.reloadComponentBundle();
        const selectedData = {
            selectedComponentId : this.selectedComponentId,
            selectedComponentName : this.selectedComponentName
        }
        const reloadeditorwindow = new CustomEvent('reloadeditorwindow',{detail : selectedData});
        this.dispatchEvent(reloadeditorwindow);
    }

    
    saveLWCBundle()
    {
        console.log(this.lwcBundleChangeList);
        saveLWCBundles({updatedResourceBundle : this.lwcBundleChangeList})
        .then((response)=>{
           this.lwcBundleChangeResponse = response;
           console.log(this.lwcBundleChangeResponse);
        }).catch((error) => {
            console.log(error);
        }).finally(()=>{
            this.template.querySelector('c-response-modal').openModal(this.lwcBundleChangeResponse);
        });
    }

    handleTextChange(event)
    {
        var pBundleId = event.currentTarget.dataset.id;
        var pBundleChangedValue =event.target.value;
        var pBundleChangedFormat =event.currentTarget.dataset.format;
        var pBundleChangedComponentName = this.selectedComponentName;
        if(this.lwcBundleChangeList.some(function(el) {
            //console.log(el.bundleId === pBundleId);
            return el.Id === pBundleId;})){ // If condition checks if a javascript object already exists in the Array with the same bundle ID
                var existingIndex = this.lwcBundleChangeList.map(function(e) { return e.Id; }).indexOf(pBundleId); // Get the existing object so that the change ccode can be used to replace the older value
                //console.log('existingIndex '+existingIndex)
                if(existingIndex!==-1){
                    this.lwcBundleChangeList[existingIndex]={
                        Id : pBundleId ,
                        Source : pBundleChangedValue,
                        Format : pBundleChangedFormat,
                        Name : pBundleChangedComponentName
                    };
                }
                else{
                    alert('Error');
                }
            }
            else{
                this.lwcBundleChangeList.push({
                    Id : pBundleId ,
                    Source : pBundleChangedValue ,
                    Format : pBundleChangedFormat,
                    Name : pBundleChangedComponentName
                });
            }
        
        console.log(this.lwcBundleChangeList);
        this.lwcBundleChangeListSize = this.lwcBundleChangeList.length+' Files Changed !';
    }

    @wire(getResourceBundleForId,{ lwcId : '$selectedComponentId'})
    getResourceBundle(response)
    {   
        this.isLoading=true;
        this.selectedComponentBundleData = response.data;
        console.log(this.selectedComponentBundleData);
        this.isLoading=false;
    }

    connectedCallback()
    {
        this.subscribeToMessageChannel();
    }
    @api
    reloadComponentBundle()
    {
        this.lwcBundleChangeList = [];
        this.lwcBundleChangeResponse = [];
        console.log('reload bundle ');
        eval("$A.get('e.force:refreshView').fire();");
    }

    


    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            recordSelected,
            (message) => this.handleMessage(message),
            { scope: APPLICATION_SCOPE }
            );
        console.log('subscription'+JSON.stringify(this.subscription));
    }
    

    handleMessage(message) {
        this.isLoading=true;
        this.selectedComponentId = message.lwcId;
        this.selectedComponentName = message.lwcName;
        this.isLoading=false;
        //this.reloadComponentBundle();

    }

    

}