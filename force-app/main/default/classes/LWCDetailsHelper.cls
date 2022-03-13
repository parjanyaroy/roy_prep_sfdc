public with sharing class LWCDetailsHelper {

    public static List<String> coreComponents = new List<String>{'lwcEditorWindow','lwcnavigator','responseModal','lwcviewercontainer','unsavedChangesModal'};

    String sourceHTML = '<!-- @description: \n @author: '+Label.LWC_IDE_Author+' \n @last modified on: '+System.today()+' \n @last modified by: '+Label.LWC_IDE_Author+' -->\n<template>\n</template>';
    String sourceJS = 'import { LightningElement } from \'lwc\'; \n export default class Empty extends LightningElement { \n }';
    String sourceMETA = '<?xml version="1.0"?>\n <LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata"> \n <apiVersion>50</apiVersion> \n <isExposed>true</isExposed> \n 	<targets> <target>lightning__AppPage</target> \n <target>lightning__HomePage</target>\n<target>lightning__RecordPage</target>\n </targets> \n </LightningComponentBundle>';

    @AuraEnabled
    public static List<ResponseWrapper> saveLWCBundles(List<ChangedResourceBundle> updatedResourceBundle){
        List<ResponseWrapper> allResponses = new List<ResponseWrapper>();
        System.debug(updatedResourceBundle);
        String endpoint = '/services/data/v52.0/tooling/sobjects/LightningComponentResource/' ;
        for(ChangedResourceBundle crb : updatedResourceBundle)
        {
            System.debug(crb.Format);
            System.debug(crb.Name);
            System.debug(endpoint+crb.Id+'/');
            System.debug('{"Source":"'+crb.Source.escapeJava()+'"}');
            HttpResponse response = triggerToolingAPI(endpoint+crb.Id+'/','PATCH','{"Source":"'+crb.Source.escapeJava()+'"}');
            ResponseWrapper resW = new ResponseWrapper();
            resW.Id=crb.Id;
            resW.Name=crb.Name;
            resW.Format=crb.Format;
            resW.Message=response.getBody().trim().length()>0?response.getBody() : 'Changes saved successfully!';
            resW.ResponseStatusCode = String.valueOf(response.getStatusCode());
            resW.Status= response.getStatusCode()>=200 && response.getStatusCode()<=299 ? 'Success' : 'Failure';
            System.debug(response);
            System.debug(resW);
            allResponses.add(resW);
        }
        return allResponses;
    }

    @AuraEnabled
    public static void createNewLWC(String componentName){
        if(componentName.trim().length()==0 || componentName.trim().contains(' '))
            throw new Exception('The component name supplied was invalid');
        
    }
   
    public static String createLWCBundle(String componentName)
    {
        String endpoint = '/services/data/v52.0/tooling/sobjects/LightningComponentBundle/';
        String body = '{"FullName":"'+componentName+'","Metadata":{"apiVersion":52,"description": null,"isExplicitImport": false,"isExposed":true,"masterLabel": "'+componentName+'","targets": {"target": ["lightning__RecordPage","lightning__AppPage","lightning__HomePage"]}}}';
        HttpResponse resp = triggerToolingAPI(endpoint,'POST',body);
        return null;
    }

    public static List<String> createLWCResource(String componentName,String lwcBundleId)
    {
        String endpoint = '/services/data/v52.0/tooling/sobjects/LightningComponentResource/';
        
        String fpath_html = 'lwc/'+componentName+'/'+componentName+'.html';
        String body_html = '{"FilePath": "'+fpath_html+'","LightningComponentBundleId":"'+lwcBundleId+'","Format":"html", "Source" : '+ sourceHTML+'}';

        String fpath_js = 'lwc/'+componentName+'/'+componentName+'.js';
        String body_js = '{"FilePath": "'+fpath_js+'","LightningComponentBundleId":"'+lwcBundleId+'","Format":"js", "Source" : '+ sourceJS+'}';

        String fpath_meta = 'lwc/'+componentName+'/'+componentName+'js-meta.xml';
        String body_meta = '{"FilePath": "'+fpath_meta+'","LightningComponentBundleId":"'+lwcBundleId+'","Format":"xml", "Source" : '+ sourceMETA+'}';

        return null;
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
        String response = triggerToolingAPI(endpoint,'GET',null).getBody();
        System.debug(response);
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        LWCComponentBundleWrapper lwcComp = (LWCComponentBundleWrapper)parser.readValueAs(LWCComponentBundleWrapper.class);
                        if(!coreComponents.contains(lwcComp.DeveloperName.trim()))
                        {
                            componentMap.put(lwcComp.Id,lwcComp);
                        }
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
        String response = triggerToolingAPI(endpoint,'GET',null).getBody();
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
                        lwcResource.format = lwcResource.format.toUpperCase();
                        resourceWrapperList.add(lwcResource);
                        
                    }
                }
            }
        }
        System.debug(resourceWrapperList);
        return resourceWrapperList;
    }

    public static HttpResponse triggerToolingAPI(String endpoint,String protocol,String body)
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
            req.setBody(body);
        }
        else if(protocol.trim().equalsIgnoreCase('POST')){
            req.setMethod('POST');
            req.setBody(body);
        }
        HttpResponse response = h.send(req);
        return response;
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
        @AuraEnabled
        public String Format {get ; set;}
        @AuraEnabled
        public String Name {get ; set;}
    }

    class ResponseWrapper
    {
        @AuraEnabled
        public String Id {get ; set;}
        @AuraEnabled
        public String Format {get ; set;}
        @AuraEnabled
        public String Name {get ; set;}
        @AuraEnabled
        public String Message {get ; set;} 
        @AuraEnabled
        public String Status {get ; set;}
        @AuraEnabled
        public String ResponseStatusCode {get ; set;}
    }

    
}