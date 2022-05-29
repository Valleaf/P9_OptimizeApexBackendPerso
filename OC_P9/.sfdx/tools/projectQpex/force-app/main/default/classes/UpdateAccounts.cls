global class UpdateAccounts implements Database.Batchable<sObject>{

    public static void run(){
        Database.executeBatch(new UpdateAccounts());
    }
    
    global Database.QueryLocator start(Database.BatchableContext info){ 

         return Database.getQueryLocator('SELECT Id, (SELECT TotalAmount FROM Orders WHERE Status = \'Activated\') FROM Account WHERE ID IN (SELECT AccountId FROM Order WHERE Status = \'Activated\')');
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){      
         OrderUtils.updateCA(scope);
        }
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }