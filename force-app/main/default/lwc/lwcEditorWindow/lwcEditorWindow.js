import { LightningElement , wire , track } from 'lwc';
import getResourceBundleForId from '@salesforce/apex/LWCDetailsHelper.getResourceBundleForId';
import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/lwcnavigator__c';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import highlightminjs from '@salesforce/resourceUrl/HighlightMinJS';

const NUM_OF_TABS = 30;

export default class LwcEditorWindow extends LightningElement {
    subscription = null;
    selectedComponentId = null;
    selectedComponentName = null;
    selectedComponentBundleData = null ;
    isLoading = false;
    @wire(MessageContext)
    messageContext;

    @wire(getResourceBundleForId,{ lwcId : '$selectedComponentId'})
    getResourceBundle(response)
    {   this.isLoading=true;
        this.selectedComponentBundleData = response.data;
        console.log(this.selectedComponentBundleThankData);
        this.isLoading=false;
    }

    connectedCallback()
    {
        this.subscribeToMessageChannel();
    }
    renderedCallback()
    {
        loadScript(this, highlightminjs)
            .then(() => { 
                console.log('Loaded HighlightMinJS');
                this.hightlightAll();
            })
            .catch(error => console.log(error));
        
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

    }

    

}