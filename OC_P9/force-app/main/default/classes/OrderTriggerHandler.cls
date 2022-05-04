public class OrderTriggerHandler extends TriggerHandler {

// Maps and list initialized from the Trigger context
private Map<Id,Order> oldMap;
private Map<Id,Order> newMap;
private List<Order> oldList;
private List<Order> newList;

public override void startTrigger() {
     if(newList != null){
        for (Order newOrder : newList){
            Order oldOrder = (this.oldMap != null) ? oldMap.get(newOrder.Id) : null;
            // Insert or Update ?
            if (oldOrder == null){

            }else{

            }
     }
}







    // Calcul montant
	Order newOrder= trigger.new[0];
	newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
    
    // UpdateAccountCA
    set<Id> setAccountIds = new set<Id>();  
    for(integer i=0; i< trigger.new.size(); i++){
        Order newOrder= trigger.new[i];
       
        Account acc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
        acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + newOrder.TotalAmount;
        update acc;
    }
