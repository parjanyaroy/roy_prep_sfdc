public with sharing class TriggerDispatcher {
    
    public static void run(TriggerInterface handler){
        if(handler.isDisabled())
            return;
        System.debug(Trigger.operationType);
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.handleBeforeInsert(Trigger.new);
            }
            when AFTER_INSERT {
                handler.handleAfterInsert(Trigger.new, Trigger.newMap);
            }
            when BEFORE_UPDATE {
                handler.handleBeforeUpdate(Trigger.new, Trigger.newMap,Trigger.old, Trigger.oldMap);
            }
            when AFTER_UPDATE {
                handler.handleAfterUpdate(Trigger.new, Trigger.newMap,Trigger.old, Trigger.oldMap);
            }
            when BEFORE_DELETE {
                handler.handleBeforeDelete(Trigger.old, Trigger.oldMap);
            }
            when AFTER_DELETE {
                handler.handleAfterDelete(Trigger.old, Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                handler.handleAfterUndelete(Trigger.new, Trigger.newMap);
            }
            when else {
                return;
            }
        }
    }

}