public class OrderTriggerHandler {

    public static void beforeUpdate(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            newOrder.NetAmount__c = newOrder.TotalAmount - (newOrder.Shipping_Costs__c == null ? 0 : newOrder.Shipping_Costs__c);
        }
    }   

    public static void afterUpdate(List<Order> newOrders){
        Set<Id> setAccountIds = new set<Id>();
        for(Order o : newOrders){
            if(o.status == 'ACTIVATED'){
                setAccountIds.add(o.AccountId);
            }
        }
        List<Account> accsWithOrders = [SELECT Id, (SELECT TotalAmount FROM Orders WHERE Status = 'Activated') 
                                        FROM Account
                                        WHERE Id IN :setAccountIds];
        OrderUtils.updateCA(accsWithOrders);
    } 

    



}