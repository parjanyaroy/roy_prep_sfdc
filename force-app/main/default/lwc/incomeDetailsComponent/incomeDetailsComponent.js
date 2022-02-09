import { LightningElement, track, wire , api } from 'lwc';
import getAllIncomeDetail from '@salesforce/apex/AuraApexController.getAllIncomeDetail';
import  { refreshApex } from '@salesforce/apex'
import saveIncomeRecord from '@salesforce/apex/AuraApexController.saveIncomeRecord';
import deleteIncomeRecord from '@salesforce/apex/AuraApexController.deleteIncomeRecord';

export default class IncomeDetailsComponent extends LightningElement {
    @api
    department = "Engineering";
    newRecordName;
    newRecordSalary;
    allIncomeResponse;
    isProcessing=true;

    @api
    someChildMethod(param)
    {
        alert('Hi,'+param);
    }

    @track
    salaryDetails = [] ;

    @wire(getAllIncomeDetail)
    getAllSalaryDetails(response)
    {
        this.isProcessing=true;
        if(response.data || response.error)
        {
            console.log(response);
            if(response.data)
            {
                this.allIncomeResponse=response;
                var incomeData = response.data ; 
                this.salaryDetails=[];
                for(var i=0;i<response.data.length;i++)
                {
                    //console.log(incomeData[i]);
                    this.salaryDetails.push({
                    id: incomeData[i].Id,
                    name: incomeData[i].Name,
                    salary: incomeData[i].Income__c
                    });
                }
                this.isProcessing=false;    
            }
            else
            {
                this.isProcessing=false;
                console.log(error);
            }
            
        }
    }

    handleRefreshIncomeData()
    {
        refreshApex(this.allIncomeResponse);
    }

    handleAddNewName(event)
    {
        this.newRecordName = event.target.value;
    }
    
    handleAddNewSalary(event)
    {
        this.newRecordSalary = event.target.value;
    }

    handleAddSalary()
    {
        //console.log(this.newRecordName+' '+this.newRecordSalary);
        this.isProcessing=true;
        saveIncomeRecord({
            fullName : this.newRecordName,
            income : this.newRecordSalary
        }).then(response => {
            console.log(response);
            this.salaryDetails.push({
                id : response.Id,
                name : response.Name ,
                salary : response.Income__c
            })
        }).catch(error => console.log(error)).finally(()=> {this.isProcessing=false;});
        //console.log(this.salaryDetails.length);
    }

    handleDeleteRecord(event)
    {
        this.isProcessing = true;
        console.log(event.currentTarget.dataset.recid);
        var recIdForDeletion=event.currentTarget.dataset.recid;
        var deletionIndex = -1;
        deleteIncomeRecord({recordId : recIdForDeletion }).then((response) => {
            for(var i=0;i<this.salaryDetails.length;i++)
            {
                if(this.salaryDetails[i].id===recIdForDeletion)
                {
                    deletionIndex=i;
                    break;
                }
            }
            console.log(deletionIndex);
            if(deletionIndex!==-1)
            {
                this.salaryDetails.splice(deletionIndex,1);
            }

        }).catch(error => console.log(error)).finally(()=> this.isProcessing = false);
    }

    /* Lifecycle methods for LWC */ 
    constructor(){super();console.log('C constructor');}
    connectedCallback(){console.log('C connectedCallback');}
    disconnectedCallback(){console.log('C disconnectedCallback');}
    renderedCallback(){console.log('C renderedCallback');}
    //render(){console.log('C render');}
    errorCallback(){console.log('C errorCallback');}
    


}