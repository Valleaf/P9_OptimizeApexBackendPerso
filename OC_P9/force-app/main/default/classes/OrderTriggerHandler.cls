public class OrderTriggerHandler {

    public void beforeUpdate(List<Order> newOrders) {
        for (Order newOrder : newOrders) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
        newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }   

    public void afterUpdate(List<Order> newOrders){
        OrderUtils.updateCA(newOrders);
    } 

    



}