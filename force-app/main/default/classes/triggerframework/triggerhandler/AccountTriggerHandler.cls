public with sharing class AccountTriggerHandler implements TriggerInterface {

    public boolean triggerEnabled = true; // Fetch this value from custom settings
    
    public Boolean isDisabled()
    {
     return triggerEnabled;   
    }
    
    public void handleBeforeInsert(List<sObject> newList)
    {
        System.debug('handleBeforeInsert');
        System.debug(newList);
    }
    
    public void handleAfterInsert(List<sObject> newList,Map<Id,sObject> newMap)
    {
        System.debug('handleAfterInsert');
        System.debug(newList);
        System.debug(newMap);
    }


    public void handleBeforeUpdate(List<sObject> newList,Map<Id,sObject> newMap,List<sObject> oldList,Map<Id,sObject> oldMap)
    {
        System.debug('handleBeforeUpdate');
        System.debug(newList);
        System.debug(newMap);
        System.debug(oldList);
        System.debug(oldMap);
    }

    public void handleAfterUpdate(List<sObject> newList,Map<Id,sObject> newMap,List<sObject> oldList,Map<Id,sObject> oldMap)
    {
        System.debug('handleAfterUpdate');
        System.debug(newList);
        System.debug(newMap);
        System.debug(oldList);
        System.debug(oldMap);
    }

    public void handleBeforeDelete(List<sObject> oldList,Map<Id,sObject> oldMap)
    {
        System.debug('handleBeforeDelete');
        System.debug(oldList);
        System.debug(oldMap);
    }
    
    public void handleAfterDelete(List<sObject> oldList,Map<Id,sObject> oldMap)
    {
        System.debug('handleAfterDelete');
        System.debug(oldList);
        System.debug(oldMap);
    }

    public void handleAfterUndelete(List<sObject> newList,Map<Id,sObject> newMap)
    {
        System.debug('handleAfterUndelete');
        System.debug(newList);
        System.debug(newMap);
        
    }


}