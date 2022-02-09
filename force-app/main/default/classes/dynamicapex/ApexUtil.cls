public with sharing class ApexUtil {
    
    public static Map<String,String> getAllSObject()
    {
        Map<String,String> allSObjectMap = new Map<String,String>();
        Map<String,Schema.SObjectType> describeMap = Schema.getGlobalDescribe();
        for(String key : describeMap.keySet())
        {
            Schema.SObjectType s1 = describeMap.get(key);
            Schema.DescribeSObjectResult describeResult = s1.getDescribe();
            if(describeResult.isAccessible() && describeResult.isCreateable())
            allSObjectMap.put(describeResult.getName(),describeResult.getLabel());
        }
    return allSObjectMap;
    }

    public static Map<String,String> getAllFields(String objectApiName)
    {
        Map<String,Schema.SObjectField> fieldTypes = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
        Map<String,String> fieldNames = new Map<String,String>();
        for(String field : fieldTypes.keySet())
        {
            //fieldNames.put(fieldNames.get(field)field.getDescribe().getName(),field.getDescribe().getLabel());
            fieldNames.put(fieldTypes.get(field).getDescribe().getName(),fieldTypes.get(field).getDescribe().getLabel());
        }
        return fieldNames;
    }

    public static Map<String,String> getAllPickListValues(String objectApiName,String pickListFieldName)
    {
        Map<String, String> picklistValueMap = new Map<String,String>();
        Schema.DescribeFieldResult picklistFieldResult =  Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(pickListFieldName).getDescribe();
        List<Schema.PicklistEntry> plist = picklistFieldResult.getPicklistValues();
        for(Schema.PicklistEntry pValue : plist)
        {
            if(pValue.isActive())
            {
                picklistValueMap.put(pValue.getLabel(),pValue.getValue());
            }
        }
        return picklistValueMap;
    }

    public static Map<String,Id> getRecordTypes(String objectApiName)
    {
        Map<String,Id> recType = new Map<String,Id>();
        Schema.DescribeSObjectResult sObjectResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
        List<Schema.RecordTypeInfo> recTypeInfos = sObjectResult.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rec : recTypeInfos)
        {
            recType.put(rec.getDeveloperName(),rec.getRecordTypeId());
        }
        return recType;
    }




}