public without sharing class OrderTriggerHelper {

    /** This method updates CA on accounts related to the orders sent through 

    */
    public static List<Account> updateCA(List<Order> orders) {
    set<Id> AccountsIds = new set<Id>(); 
    // get the orders related accounts id to query the accounts
    for(Order order : orders) {
        AccountsIds.add(order.AccountId);
    }
    // query the accounts
    Map<Id,Account> accs = new Map<Id,Account>([SELECT Id, Chiffre_d_affaire__c 
                              FROM Account 
                              WHERE Id IN :AccountsIds]);

    //Loop through the orders, and update the accounts CA
    for(Order order : orders) {
        Account acc = accs.get(order.AccountId);
        if(acc != null) {
            acc.Chiffre_d_affaire__c += order.TotalAmount;
        }
    }
    // return accounts now
    return accs.values();
    }

    public static void updateNetAmount(List<Order> orders){
        for(Order order : orders) {
	        order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;  
        }
    }
}
