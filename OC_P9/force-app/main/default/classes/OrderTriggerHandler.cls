public class OrderTriggerHandler {

    public void beforeUpdate(List<Order> oldOrders, List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
        newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }   

    public void afterUpdate(List<Order> oldOrders, List<Order> newOrders){
        Account[] accsToUpdate = new List<Account>();
        Set<Id> ordersIds = new Set<Id>();
        for(Order o : newOrders){
            ordersIds.add(o.Id);
        }
        Set<Id> setAccountIds = new set<Id>();
        Map<Id,Account> accsMap = new Map<Id,Account>([SELECT Id, Chiffre_d_affaire__c FROM Order WHERE Id IN  ordersIds]);
        for(Order o : newOrders){
            Account acc = accsMap.get(o.AccountId);
            acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + o.TotalAmount;
            accsToUpdate.add(acc);
        }
        update accsToUpdate;
    } 

    



}