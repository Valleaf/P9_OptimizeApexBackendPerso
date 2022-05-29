public class OrderUtils{

    public static void updateCA(List<Account> accsWithOrders){
        Account[] accsToUpdate = new List<Account>();
        for(Account a : accsWithOrders){
            a.Chiffre_d_affaire__c = 0;
            for(Order o : a.Orders){
                a.Chiffre_d_affaire__c += o.TotalAmount;
            }
            accsToUpdate.add(a);
        }
        try{
            update accsToUpdate;
        } catch (Exception ex) {
         System.debug('Exception UpdateCA: '+ex.getMessage());
         System.debug('Exception UpdateCA: '+ex.getStackTraceString());      
        }
    }

}