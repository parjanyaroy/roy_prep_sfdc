public with sharing class LWCDetailsHelper {


    @AuraEnabled
    public static List<String> saveLWCBundles(List<ChangedResourceBundle> updatedResourceBundle){
        List<String> allResponses = new List<String>();
        //System.debug(updatedResourceBundle);
        String endpoint = '/services/data/v52.0/tooling/sobjects/LightningComponentResource/' ;
        for(ChangedResourceBundle crb : updatedResourceBundle)
        {
            System.debug(endpoint+crb.Id+'/');
            System.debug(crb.Source.escapeJava());
            String response = triggerToolingAPI(endpoint+crb.Id+'/','PATCH','{"Source":"'+crb.Source.escapeJava()+'"}');
            allResponses.add(response);
        }
        return allResponses;
    }

    @AuraEnabled(cacheable=true)
    public  static String getLWCComponentAndResourceBundle() {
        Map<String,LWCComponentBundleWrapper> getAllComponents = getLWCComponentList();
        /*Map<String,List<LWCComponentResourceWrapper>> getAllComponentResources = getLWCComponentResource(getAllComponents.keySet());
        for(String componentId : getAllComponents.keySet())
        {
            ((LWCComponentBundleWrapper)getAllComponents.get(componentId)).resourceList=((List<LWCComponentResourceWrapper>)getAllComponentResources.get(componentId));
        }
        system.debug(getAllComponents);*/
        return JSON.serialize(getAllComponents.values());
    }
    
    public static Map<String,LWCComponentBundleWrapper> getLWCComponentList()
    {
        Map<String,LWCComponentBundleWrapper> componentMap = new Map<String,LWCComponentBundleWrapper>();
        String endpoint = '/services/data/v52.0/tooling/query/?q=SELECT+Id,DeveloperName+FROM+LightningComponentBundle' ;
        String response = triggerToolingAPI(endpoint,'GET',null);
        System.debug(response);
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        LWCComponentBundleWrapper lwcComp = (LWCComponentBundleWrapper)parser.readValueAs(LWCComponentBundleWrapper.class);
                        componentMap.put(lwcComp.Id,lwcComp);
                    }
                }
            }
        }
    return componentMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<LWCComponentResourceWrapper> getResourceBundleForId(String lwcId){
        return getLWCComponentResource(new Set<String>{lwcId});
    }

    public static List<LWCComponentResourceWrapper> getLWCComponentResource(Set<String> lwccomponentbundleid)
    {   
        List<LWCComponentResourceWrapper> resourceWrapperList = new List<LWCComponentResourceWrapper>();
        String endpoint = '/services/data/v52.0/tooling/query/?q=SELECT+Id,format,source,LightningComponentBundleId+FROM+LightningComponentResource+WHERE+LightningComponentBundleId+in+(';
        for(String s : lwccomponentbundleid)
        {
            s='\''+s+'\',';
            endpoint=endpoint+s;
        }
        endpoint = endpoint.substring(0,endpoint.length()-1);
        endpoint = endpoint+')';
        Map<String,LWCComponentBundleWrapper> componentMap = new Map<String,LWCComponentBundleWrapper>();
        
        //System.debug(endpoint);
        endpoint=endpoint.replaceAll(' ','+');
        //System.debug('endpoint'+endpoint);
        String response = triggerToolingAPI(endpoint,'GET',null);
        System.debug(response);
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        LWCComponentResourceWrapper lwcResource = (LWCComponentResourceWrapper)parser.readValueAs(LWCComponentResourceWrapper.class);
                        if(lwcResource.source.startsWith('<?xml'))
                        {
                            lwcResource.format ='xml';
                        }
                        
                        resourceWrapperList.add(lwcResource);
                        
                    }
                }
            }
        }
        System.debug(resourceWrapperList);
        return resourceWrapperList;
    }

    public static String triggerToolingAPI(String endpoint,String protocol,String body)
    {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('callout:CallMeBack'+endpoint);
        if(protocol.trim().equalsIgnoreCase('GET')){
            req.setMethod('GET');
        }
        else if(protocol.trim().equalsIgnoreCase('PATCH')){
            req.setMethod('PATCH');
            //System.debug(body);
            req.setBody(body);
        }
        HttpResponse response = h.send(req);
        return response.getBody();
    }
    

    class LWCComponentBundleWrapper{
        String DeveloperName { get; set; }
        String Id { get; set; }
        //List<LWCComponentResourceWrapper> resourceList { get; set; }

    }
    class LWCComponentResourceWrapper{
        @AuraEnabled
        public String format { get; set; }
        @AuraEnabled
        public String source { get; set; }
        @AuraEnabled
        public String Id { get; set; }
        @AuraEnabled
        public String LightningComponentBundleId { get; set; }
    }

    class ChangedResourceBundle{
        @AuraEnabled
        public String Id {get ; set;}
        @AuraEnabled
        public String Source {get ; set;}
    }

    
}