import { LightningElement } from 'lwc';

export default class Parent extends LightningElement {

    handleEventFromChild(event)
    {
        alert('In Parent');
        console.log(event.detail);
    
    }

    handleEventFromChildStyling(event)
    {
        alert('In Parent Styling');
        console.log(event.detail);
    
    }
}