import { LightningElement } from 'lwc';
//import processResponse from '@salesforce/apex/ContinuationSample.processResponse';
import getContinuationObject from '@salesforce/apexContinuation/ContinuationSample.getContinuationObject';
export default class ContinuationExample extends LightningElement {

    responseData = 'Sample';

    sendrequest(){
        getContinuationObject().then(response => {
            console.log(response);
        })
    }
}