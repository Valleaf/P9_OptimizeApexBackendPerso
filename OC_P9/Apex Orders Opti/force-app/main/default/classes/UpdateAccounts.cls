global class UpdateAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        return Database.getQueryLocator('SELECT Id FROM Account WHERE ID IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){      
        // get accounts Ids in a Set
        Set<Id> accountsIds = new Set<Id>();
        for(Account account : scope){
            accountsIds.add(account.Id);
        }    
        list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accountsIds];
        
        for(Account a : scope){
            a.Chiffre_d_affaire__c = 0;
            for(integer j=0; j < listOrders.size(); j++){
               if(listOrders[j].AccountId == a.Id){
                   a.Chiffre_d_affaire__c += listOrders[j].TotalAmount;
               }                   
           }
        }
        
        try {
         update scope;
        } catch (Exception ex) {
         System.debug('Exception UpdateAccounts: '+ex.getMessage());
         System.debug('Exception UpdateAccounts: '+ex.getStackTraceString());      
        }
     }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }