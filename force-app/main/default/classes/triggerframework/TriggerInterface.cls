public  interface TriggerInterface {
    
    Boolean isDisabled();
    
    void handleBeforeInsert(List<sObject> newList);
    void handleAfterInsert(List<sObject> newList,Map<Id,sObject> newMap);

    void handleBeforeUpdate(List<sObject> newList,Map<Id,sObject> newMap,List<sObject> oldList,Map<Id,sObject> oldMap);
    void handleAfterUpdate(List<sObject> newList,Map<Id,sObject> newMap,List<sObject> oldList,Map<Id,sObject> oldMap);

    void handleBeforeDelete(List<sObject> oldList,Map<Id,sObject> oldMap);
    void handleAfterDelete(List<sObject> oldList,Map<Id,sObject> oldMap);

    void handleAfterUndelete(List<sObject> newList,Map<Id,sObject> newMap);


}