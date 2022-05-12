public class OrderItemTriggerHandler extends TriggerHandler {

    // Maps and list initialized from the Trigger context
    private Map<Id,OrderItem> oldMap;
    private Map<Id,OrderItem> newMap;
    private List<OrderItem> oldList;
    private List<OrderItem> newList;

    // Accounts to Update
    private static List<Order> ordersToUpdate = new List<Order>();
    
    // CONSTANTS
    private static final String ORDERED = 'Ordered';

    // Constructor
    public OrderItemTriggerHandler() {
        this.oldMap = (Map<Id, OrderItem>) Trigger.oldMap;
        this.newMap = (Map<Id, OrderItem>) Trigger.newMap;
        this.oldList = (List<OrderItem>) Trigger.Old;
        this.newList = (List<OrderItem>) Trigger.New;
    }

    public override void startTrigger() {

        if(newList != null){
            //  Loop through and add to lists depending on conditions
            for (OrderItem newOrderItem : newList){
                OrderItem oldOrderItem = (this.oldMap != null) ? oldMap.get(newOrderItem.Id) : null;
                // Insert or Update ?
                if (oldOrderItem == null){
                }else{
                }
            }
        }
    }

    public override void endTrigger() {
        System.debug('## >>> OrderItem endTrigger:END <<<');
        if(!ordersToUpdate.isEmpty()){
            try {
                update ordersToUpdate;
            } catch (Exception ex) {
                System.debug('Exception endTrigger: '+ex.getMessage());
                System.debug('Exception endTrigger: '+ex.getStackTraceString());
            }
        }
    }

}