trigger OrderItem_Trigger on OrderItem (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
	new OrderItemTriggerHandler().run();
}
