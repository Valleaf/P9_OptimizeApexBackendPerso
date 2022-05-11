@isTest
private with sharing class updateAllAccountsTEST {

    @isTest
    private static void updateAllAccountsTEST() {
    
        // Set data, then start batch. Query the data anew and assert
        Account acc1 = DataFactory.createAccount('Test 1', false);
        Account acc2 = DataFactory.createAccount('Test 2', false);
        Account acc3 = DataFactory.createAccount('Test 3', false);
        insert new List<Account> { acc1, acc2, acc3 };

        // Update all accounts
        updateAccounts.run();

        // Query the data anew and assert
        List<Account> accounts = [SELECT Chiffre_d_affaire__c FROM Account];

    }

}
