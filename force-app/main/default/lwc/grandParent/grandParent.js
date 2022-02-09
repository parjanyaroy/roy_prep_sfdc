import { LightningElement } from 'lwc';

export default class GrandParent extends LightningElement {
    handleEventFromChild(event)
    {
        alert('In Grand Parent');
        console.log(event.detail);
    
    }
    handleEventFromChildStyling(event)
    {
        alert('In Grand Parent');
        console.log(event.detail);
    }
}