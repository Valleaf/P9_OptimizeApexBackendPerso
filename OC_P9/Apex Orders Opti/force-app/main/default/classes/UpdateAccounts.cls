global class UpdateAccounts implements Database.Batchable<sObject>{

    public static void run(){
        Database.executeBatch(new UpdateAccounts());
    }
    
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
        // Map the orders to the accounts via a list
        Map<Id, List<Order>> ordersByAccount = new Map<Id, List<Order>>();
        for(Order order : listOrders){
            if(ordersByAccount.get(order.AccountId) != null){
                ordersByAccount.get(order.AccountId).add(order);
            }else{
                List<Order> list = new List<Order>();
                list.add(order);
                ordersByAccount.put(order.AccountId, list);
            }
        }
        // Calculate the total amount for each account
        for(Id accountId : ordersByAccount.keyset()){
            Account aTemp = new Account(Id = accountId);
            aTemp.Chiffre_d_affaire__c = 0;
            for(Order order : ordersByAccount.get(accountId)){
                aTemp.Chiffre_d_affaire__c += order.TotalAmount;
            }
        }
        // TODO: USE EXISTING METHOD
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