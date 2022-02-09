public class TestQueueableJob implements Queueable,Database.AllowsCallouts {
    
    public Integer count;
    
    public TestQueueableJob(Integer count)
    {
        this.count=count;
    }
    
    public  void execute(System.QueueableContext qc)
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
        testFutureMethod();
        if(count>0)
        {
            count--;
            System.enqueueJob(new TestQueueableJob(count));
        }
        else
        {
            Database.executeBatch(new TestBatchableJob());
        }

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

}