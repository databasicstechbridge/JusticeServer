trigger CaseTrigger on Case (after insert, after update) {

    if(Trigger.isAfter && Trigger.IsInsert){
        CaseTriggerHandler.afterInsertHandler(Trigger.New, null);    
    } 
    
    if(Trigger.isAfter && Trigger.IsUpdate){
        CaseTriggerHandler.afterUpdateHandler(Trigger.New, Trigger.OldMap);    
    }  
}