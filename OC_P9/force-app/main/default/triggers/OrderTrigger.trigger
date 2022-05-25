trigger OrderTrigger on Order (before update,after update) {
	
    if(Trigger.OperationType == BEFORE_UPDATE) {
        OrderTriggerHandler.beforeUpdate(Trigger.Old,Trigger.New);
    }
    if(Trigger.OperationType == AFTER_UPDATE){
        OrderTriggerHandler.afterUpdate(Trigger.Old,Trigger.New);
    }
}


	
    