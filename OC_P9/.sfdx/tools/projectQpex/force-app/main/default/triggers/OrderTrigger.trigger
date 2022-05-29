trigger OrderTrigger on Order (before update,after update) {
	
    if(Trigger.OperationType == BEFORE_UPDATE) {
        OrderTriggerHandler.beforeUpdate(Trigger.New);
    }
    if(Trigger.OperationType == AFTER_UPDATE){
        OrderTriggerHandler.afterUpdate(Trigger.New);
    }
}


	
    