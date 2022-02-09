import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent' ;
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import CONTACT_FirstName from '@salesforce/schema/Contact.FirstName';
import CONTACT_LastName from '@salesforce/schema/Contact.LastName';
import CONTACT_Email from '@salesforce/schema/Contact.Email';
export default class ContactCreator extends LightningElement {
objectAPIName=CONTACT_OBJECT;
fields= [CONTACT_FirstName , CONTACT_LastName , CONTACT_Email];
handleSuccess(event)
{
    const toastEvent = new ShowToastEvent({
        title: "Contact created",
        message: "Record ID: " + event.detail.id,
        variant: "success"
    });
    this.dispatchEvent(toastEvent);
}

}