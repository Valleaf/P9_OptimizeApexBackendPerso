public class OrderTriggerHandler extends TriggerHandler {

    // Maps and list initialized from the Trigger context
    private Map<Id,Order> oldMap;
    private Map<Id,Order> newMap;
    private List<Order> oldList;
    private List<Order> newList;

    // CONSTANTS
    private static final String ORDERED = 'Ordered';

    // beforeInsert  / beforeUpdate
    private static List<Order> ordersWithAmount = new List<Order>();
    // afterInsert  / afterUpdate
    private static List<Order> ordersOrdered = new List<Order>();

    // Accounts to Update
    private static List<Account> accountsToUpdate = new List<Account>();


    // Constructor
    public OrderTriggerHandler() {
        this.oldMap = (Map<Id, Order>) Trigger.oldMap;
        this.newMap = (Map<Id, Order>) Trigger.newMap;
        this.oldList = (List<Order>) Trigger.Old;
        this.newList = (List<Order>) Trigger.New;
    }

    public override void startTrigger() {
        // Clear lists
        ordersOrdered.clear();
        ordersWithAmount.clear();
        accountsToUpdate.clear();

        // Check this is not Delete event
        if(newList != null){
            //  Loop through and add to lists depending on conditions
            for (Order newOrder : newList){
                Order oldOrder = (this.oldMap != null) ? oldMap.get(newOrder.Id) : null;
                // Insert or Update ?
                if (oldOrder == null){

                }else{
                    // If status changed to ordered, update CA
                    if(oldOrder.Status != newOrder.Status && newOrder.Status == ORDERED){
                        ordersOrdered.add(newOrder);
                    }
                    // If amount changed, update netAmount
                    if(oldOrder.TotalAmount != newOrder.TotalAmount || oldOrder.Shipping_Costs__c != newOrder.Shipping_Costs__c){
                        ordersWithAmount.add(newOrder);
                    }
                }
            }
        }
    }


    /*
    Handle "Order before Insert"
    */
    public override void beforeInsert() {
        System.debug(
        '## >>> Order before Insert:START <<< run by ' + UserInfo.getName()
        );
        if(!ordersWithAmount.isEmpty()){
            OrderTriggerHelper.updateNetAmount(ordersWithAmount);
        }

        System.debug('## >>> Order before Insert:END <<<');
    }

    
    /*
    Handle "Order before Update"
    */
    public override void beforeUpdate() {
        System.debug(
        '## >>> Order before Update:START <<< run by ' + UserInfo.getName()
        );

        if(!ordersWithAmount.isEmpty()){
            OrderTriggerHelper.updateNetAmount(ordersWithAmount);
        }

        System.debug('## >>> Order before Update:END <<<');
    }

    
    /*
    Handle "Order after Update"
    */
    public override void afterUpdate() {
        System.debug(
        '## >>> Order after Update:START <<< run by ' + UserInfo.getName()
        );

        if(PAD.canTrigger('UpdateCA')){
            if(!ordersOrdered.isEmpty()){
                accountsToUpdate.addAll(OrderTriggerHelper.updateCA(ordersOrdered));
            }
        }

        System.debug('## >>> Order after Update:END <<<');
    }


    public override void endTrigger() {
        System.debug('## >>> Order endTrigger:END <<<');
        if(!accountsToUpdate.isEmpty()){
            try {
                update accountsToUpdate;
            } catch (Exception ex) {
                System.debug('Exception endTrigger: '+ex.getMessage());
                System.debug('Exception endTrigger: '+ex.getStackTraceString());
            }
        }
    }

}