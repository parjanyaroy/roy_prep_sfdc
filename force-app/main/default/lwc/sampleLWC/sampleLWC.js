import { LightningElement } from 'lwc';

export default class SampleLWC extends LightningElement {
    name="Parjanya Roy" ;

    updateName(event)
    {
        this.name = event.target.value;
    }
}