public with sharing class ContinuationSample {

    public static final String endpoint='https://reqres.in/api/users?delay=20';
    
    @AuraEnabled(cacheable=true continuation=true)
    public static Object getContinuationObject()
    {
        Continuation con = new Continuation(120);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        con.ContinuationMethod='processResponse';
        con.state='Set State';
        con.addHttpRequest(req);
        return con;
    }

    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state){
        try {
            System.debug('Hi');
             // Get the response by using the unique label
            HttpResponse response = Continuation.getResponse(labels[0]);
             // Set the result variable
            String result = response.getBody();
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}
