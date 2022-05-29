global class UpdateAccounts implements Database.Batchable<sObject>{
    
   global Database.QueryLocator start(Database.BatchableContext info){ 
        return Database.getQueryLocator('SELECT Id FROM Account WHERE ID IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){      
       list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order];
       
		for(integer i=0; i < scope.size(); i++){
			myAccount.Chiffre_d_affaire__c = 0;  
           }
        OrderUtils.updateCA(listOrders);
       }
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}