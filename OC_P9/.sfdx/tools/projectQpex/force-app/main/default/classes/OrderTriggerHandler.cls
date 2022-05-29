public class OrderTriggerHandler {

    public void beforeUpdate(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
    }   

    public void afterUpdate(List<Order> newOrders){
        Set<Id> setAccountIds = new set<Id>();
        for(Order o : newOrders){
            if(o.status == 'ORDERED'){
                setAccountIds.add(o.AccountId);
            }
        }
        List<Account> accsWithOrders = [SELECT Id, (SELECT TotalAmount FROM Orders WHERE Status = 'Ordered') 
                                        FROM Account
                                        WHERE Id IN :setAccountIds];
        OrderUtils.updateCA(accsWithOrders);
    } 

    



}