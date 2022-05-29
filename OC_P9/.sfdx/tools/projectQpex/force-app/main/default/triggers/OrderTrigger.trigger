trigger OrderTrigger on Order (before update,after update) {
	
    if(Trigger.isBefore && Trigger.isUpdate) {
        OrderTriggerHandler.beforeUpdate(Trigger.New);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        OrderTriggerHandler.afterUpdate(Trigger.New);
    }
}


	
    