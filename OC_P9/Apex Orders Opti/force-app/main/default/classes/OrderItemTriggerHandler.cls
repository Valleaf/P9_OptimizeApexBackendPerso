public class OrderItemTriggerHandler extends TriggerHandler {

    // Maps and list initialized from the Trigger context
    private Map<Id,OrderItem> oldMap;
    private Map<Id,OrderItem> newMap;
    private List<OrderItem> oldList;
    private List<OrderItem> newList;

    // Accounts to Update
    private static List<Id> ordersWithAmountChangedId = new List<Id>();
    private static List<Order> ordersWithAmountChanged = new List<Order>();

    // Constructor
    public OrderItemTriggerHandler() {
        this.oldMap = (Map<Id, OrderItem>) Trigger.oldMap;
        this.newMap = (Map<Id, OrderItem>) Trigger.newMap;
        this.oldList = (List<OrderItem>) Trigger.Old;
        this.newList = (List<OrderItem>) Trigger.New;
    }

    public override void startTrigger() {
        ordersWithAmountChanged.clear();

        if(newList != null){
            //  Loop through and add to lists depending on conditions
            for (OrderItem newOrderItem : newList){
                OrderItem oldOrderItem = (this.oldMap != null) ? oldMap.get(newOrderItem.Id) : null;
                // Insert
                if (oldOrderItem == null){
                    if(newOrderItem.UnitPrice != 0 && newOrderItem.Quantity != 0){
                        ordersWithAmountChangedId.add(newOrderItem.OrderId);
                    }
                } else {
                    // Update
                    if(oldOrderItem.UnitPrice != newOrderItem.UnitPrice || oldOrderItem.Quantity != newOrderItem.Quantity){
                        ordersWithAmountChangedId.add(newOrderItem.OrderId);
                    }   
                }
            }
        } else {
            //  Loop through and add to lists depending on conditions
            for (OrderItem newOrderItem : oldList){
                ordersWithAmountChangedId.add(newOrderItem.OrderId);
            }
        }
    }

         /*
    Handle "Order after Insert"
    */
    public override void afterInsert() {
        System.debug(
        '## >>> Order after Insert:START <<< run by ' + UserInfo.getName()
        );

        if(PAD.canTrigger('UpdateMontant')){
            if(!ordersWithAmountChangedId.isEmpty()){
                ordersWithAmountChanged = [SELECT NetAmount__c, Shipping_Costs__c,TotalAmount FROM Order WHERE ID IN :ordersWithAmountChangedId];
                OrderTriggerHelper.updateNetAmount(ordersWithAmountChanged);
            }
        }

        System.debug('## >>> Order after Insert:END <<<');
    }
         /*
    Handle "Order after Update"
    */
    public override void afterUpdate() {
        System.debug(
        '## >>> Order after Update:START <<< run by ' + UserInfo.getName()
        );

        if(PAD.canTrigger('UpdateMontant')){
            if(!ordersWithAmountChangedId.isEmpty()){
                ordersWithAmountChanged = [SELECT NetAmount__c, Shipping_Costs__c,TotalAmount FROM Order WHERE ID IN :ordersWithAmountChangedId];
                OrderTriggerHelper.updateNetAmount(ordersWithAmountChanged);
            }
        }

        System.debug('## >>> Order after Update:END <<<');
    }

    /*
    Handle "Order after Delete"
    */
    public override void afterDelete() {
        System.debug(
        '## >>> Order after Delete:START <<< run by ' + UserInfo.getName()
        );

        if(PAD.canTrigger('UpdateMontant')){
            if(!ordersWithAmountChangedId.isEmpty()){
                ordersWithAmountChanged = [SELECT NetAmount__c, Shipping_Costs__c,TotalAmount FROM Order WHERE ID IN :ordersWithAmountChangedId];
                OrderTriggerHelper.updateNetAmount(ordersWithAmountChanged);
            }
        }

        System.debug('## >>> Order after Delete:END <<<');
    }

    public override void endTrigger() {
        System.debug('## >>> OrderItem endTrigger:END <<<');
        if(!ordersWithAmountChanged.isEmpty()){
            try {
                update ordersWithAmountChanged;
            } catch (Exception ex) {
                System.debug('Exception endTrigger: '+ex.getMessage());
                System.debug('Exception endTrigger: '+ex.getStackTraceString());
            }
        }
    }

}