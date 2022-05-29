public class OrderUtils{

    public void updateCA(List<Order> orders){
        Account[] accsToUpdate = new List<Account>();
        Set<Id> ordersIds = new Set<Id>();
        for(Order o : orders){
            ordersIds.add(o.Id);
        }
        Set<Id> setAccountIds = new set<Id>();
        Map<Id,Account> accsMap = new Map<Id,Account>([SELECT Id, Chiffre_d_affaire__c FROM Order WHERE Id IN  ordersIds]);
        for(Order o : newOrders){
            Account acc = accsMap.get(o.AccountId);
            acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + o.TotalAmount;
            accsToUpdate.add(acc);
        }
        try{
            update accsToUpdate;
        } catch (Exception ex) {
         System.debug('Exception UpdateCA: '+ex.getMessage());
         System.debug('Exception UpdateCA: '+ex.getStackTraceString());      
        }
    }

}