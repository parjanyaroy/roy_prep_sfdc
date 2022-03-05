public without sharing class ToolingAPIDemo {
    
    public static void triggerToolingAPI()
    {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        //req.setEndpoint(baseURL+'/services/data/v54.0/tooling/sobjects/ApexClass/describe');
        req.setEndpoint(baseURL+'/services/data/v52.0/tooling/query/?q=SELECT+Id,DeveloperName+FROM+LightningComponentBundle');
        //req.setEndpoint(baseURL+'/services/data/v52.0/tooling/query/?q=SELECT+Id,format,source,LightningComponentBundle.DeveloperName+FROM+LightningComponentResource');
        req.setMethod('GET');
        HttpResponse response = h.send(req);
        System.debug(JSON.serializePretty(JSON.deserializeUntyped(response.getBody())));
    }

}
