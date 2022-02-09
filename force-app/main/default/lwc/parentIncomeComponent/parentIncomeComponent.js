import { LightningElement } from 'lwc';
import templateOne from './parentIncomeComponent.html';
import templateTwo from './secondTemplate.html';


export default class ParentIncomeComponent extends LightningElement {

    parentDepartment='Physics';
    showTemplateOne = true;
    

    executeChildMethod()
    {
        alert('Hi from Parent!');
        this.template.querySelector('c-income-details-component').someChildMethod('Roy');
    }

    /* Lifecycle methods for LWC */ 
    constructor(){super();console.log('P constructor');}
    connectedCallback(){console.log('P connectedCallback');}
    disconnectedCallback(){console.log('P disconnectedCallback');}
    renderedCallback(){console.log('P renderedCallback');}
    render(){
    return this.showTemplateOne? templateOne : templateTwo ;
    };
    changeTemplate()
    {
        this.showTemplateOne = this.showTemplateOne ? false : true ;
    }
    errorCallback(){console.log('P errorCallback');}
}