public with sharing class IncomeDetailTriggerHandler implements TriggerInterface {

    public Boolean isDisabled()
    {
        return false;
    }
    
    public void handleBeforeInsert(List<IncomeDetail__c> newList){
        for(IncomeDetail__c record : newList)
        {
            record.Name+=' Trgr BI Modified';
        }

    }
    public void handleAfterInsert(List<sObject> newList,Map<Id,sObject> newMap){
        // If the same record as that of the trigger is updated in the 'after' method the following error occurs
        //System.FinalException: Record is read-only
        /*for(IncomeDetail__c record : (List<IncomeDetail__c>)newList)
        {
            record.Name+=' Trgr AI Modified';
        }
        upsert(newList);*/
        
        // Attempting a callout from the AfterInsert
        // Error : System.CalloutException: Callout from triggers are currently not supported.
        /*Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://reqres.in/api/users');
        req.setMethod('GET');
        http.send(req);*/
        
        doCallout(JSON.serialize((List<IncomeDetail__c>)newList));
        Database.executeBatch(new TestBatchableJob());
        
    }
    @Future(callout=true)
    public static void doCallout(String incomeDetailRecords)
    {
        List<IncomeDetail__c> newRecordList =(List<IncomeDetail__c>) JSON.deserialize(incomeDetailRecords,List<IncomeDetail__c>.class);
        IncomeDetailTriggerHandler.UserRequest userRequest = new IncomeDetailTriggerHandler.UserRequest(newRecordList[0]);
        newRecordList[0].Name+=' Job:';
        // The following DML would throw the error System.CalloutException: 
        // You have uncommitted work pending. Please commit or rollback before calling out
        //upsert newRecordList;
        System.debug(JSON.serialize(userRequest));
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://reqres.in/api/users');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(userRequest));
        HttpResponse res = http.send(req);
        IncomeDetailTriggerHandler.UserResponse userResponse= (IncomeDetailTriggerHandler.UserResponse) JSON.deserialize(res.getBody(),IncomeDetailTriggerHandler.UserResponse.class);
        System.debug(userResponse);
        // Attempt to User DML in the same method as a callout
        newRecordList[0].Name+=userResponse.job;
        // This is not a problem . So solution is to "Do all the callouts first and THEN do the commit operation"
        upsert newRecordList;
        System.enqueueJob(new TestQueueableJob(4));
        // Following line gives an error
        //Database.executeBatch(new TestBatchableJob());
        
        /*-------------- CONCLUSION
         * 1. Future  -> Future NOT ALLOWED
         * 2. Future  -> Batch  NOT ALLOWED
         * 3. Batch   -> Future NOT ALLOWED
         * 4. Trigger -> Batch Callout		POSSIBLE
         * 5. Trigger -> Future 			POSSIBLE
         * 6. Trigger -> Future Callout 	POSSIBLE
         * 7. Future  -> Queueable Callout 	POSSIBLE
         * 8. Queueable  -> Future Callout 	POSSIBLE
         * 9. Queueable -> Batch Callout	POSSIBLE
         * 9. Batch -> Queuable				POSSIBLE
         */
    }

    public void handleBeforeUpdate(List<sObject> newList,Map<Id,sObject> newMap,List<sObject> oldList,Map<Id,sObject> oldMap){
        
    }
    public void handleAfterUpdate(List<sObject> newList,Map<Id,sObject> newMap,List<sObject> oldList,Map<Id,sObject> oldMap){
        
    }

    public void handleBeforeDelete(List<sObject> oldList,Map<Id,sObject> oldMap){
        
    }
    public void handleAfterDelete(List<sObject> oldList,Map<Id,sObject> oldMap){
        
    }

    public void handleAfterUndelete(List<sObject> newList,Map<Id,sObject> newMap){
        
    }
    
    public class UserRequest
    {
        String name;
        String job;
        public UserRequest(String name,String job)
        {
            this.name=name;
            this.job=job;
        }
        
        UserRequest(IncomeDetail__c incRecord)
        {
            this.name = incRecord.Name;
            this.job='Software Engineer';
        }
    }
    
    public class UserResponse
    {
        String name;
        String job;
        String id;
        String createdAt;
    }
    
    
    
}