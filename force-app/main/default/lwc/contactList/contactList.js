import { LightningElement, wire } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import getContacts from '@salesforce/apex/ContactController.getContacts'
import CONTACT_FirstName from '@salesforce/schema/Contact.FirstName';
import CONTACT_LastName from '@salesforce/schema/Contact.LastName';
import CONTACT_Email from '@salesforce/schema/Contact.Email';

export default class ContactList extends LightningElement {

    columns  = [  
        { label: 'First Name', fieldName: CONTACT_FirstName.fieldApiName, type: 'text' },
        { label: 'Last Name', fieldName: CONTACT_LastName.fieldApiName, type: 'text' },
        { label: 'Email', fieldName: CONTACT_Email.fieldApiName, type: 'text' }
    ];
    

    contactlist = [];


    get errors() {
        return (this.contactlist.error) ?
            reduceErrors(this.contactlist.error) : [];
    }

    @wire(getContacts)
    getContacts(request)
    {
        if(request.data)
        {
        console.log(request.data);
        this.contactlist=request.data;
        }
        else if (request.error)
        {
            this.errors = reduceErrors(request.error);
        }
    }

}