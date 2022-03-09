import { LightningElement , wire , track } from 'lwc';
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
    selectedComponentId = null;
    selectedComponentName = null;
    selectedComponentBundleData = null ;
    isLoading = false;
    @wire(MessageContext)
    messageContext;
    lwcBundleChangeList = [];
    lwcBundleChangeListSize ;
    
    saveLWCBundle()
    {
        console.log(this.lwcBundleChangeList);
        saveLWCBundles({updatedResourceBundle : this.lwcBundleChangeList})
        .then((response)=>{
            console.log(response);
        }).catch((error) => {
            console.log(error);
        });
    }

    handleTextChange(event)
    {
        var pBundleId = event.currentTarget.dataset.id;
        var pBundleChangedValue =event.target.value;
        /*console.log(this.lwcBundleChangeList.some(function(el) {
            return el.bundleId === pBundleId;}));
        console.log(this.lwcBundleChangeList.map(function(e) { return e.bundleId; }).indexOf(pBundleId));*/
        if(this.lwcBundleChangeList.some(function(el) {
            return el.bundleId === pBundleId;})){ // If condition checks if a javascript object already exists in the Array with the same bundle ID
                var existingIndex = this.lwcBundleChangeList.map(function(e) { return e.bundleId; }).indexOf(pBundleId); // Get the existing object so that the change ccode can be used to replace the older value
                if(existingIndex!==-1){
                    this.lwcBundleChangeList[existingIndex]={
                        Id : pBundleId ,
                        Source : pBundleChangedValue 
                    };
                }
                else{
                    alert('Error');
                }
            }
            else{
                this.lwcBundleChangeList.push({
                    Id : pBundleId ,
                    Source : pBundleChangedValue 
                });
            }
        
        console.log(this.lwcBundleChangeList);
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
    reloadComponentBundle()
    {
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