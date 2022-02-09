public class TestBatchableJob implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
   public Database.QueryLocator start(Database.BatchableContext bc)
   {
       return Database.getQueryLocator('Select Name,Income__c from IncomeDetail__c');
   }
    
    public void execute(Database.BatchableContext bc,List<sObject> rows)
    {
        IncomeDetailTriggerHandler.UserRequest userRequest = new IncomeDetailTriggerHandler.UserRequest('Roy','Engineer');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://reqres.in/api/users');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(userRequest));
        HttpResponse res = http.send(req);
        IncomeDetailTriggerHandler.UserResponse userResponse= (IncomeDetailTriggerHandler.UserResponse) JSON.deserialize(res.getBody(),IncomeDetailTriggerHandler.UserResponse.class);
        System.debug(userResponse);
        // The following method gives the error : Future method cannot be called from a future or batch method: TestBatchableJob.testFutureMethod()
        //testFutureMethod();
    }
    
    @Future(callout=true)
    public static void testFutureMethod()
    {
        System.debug('Hi from Future');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://reqres.in/api/users');
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        HttpResponse res = http.send(req);
    }
    
    public void finish(Database.BatchableContext bc)
    {
       // System.enqueueJob(new TestQueueableJob(4));
    }

}