@isTest
private with sharing class UpdateAccountsTest{
    public static final String ACTIVATED = 'Activated';
    @isTest
    private static void updateAllAccountsTEST(){

        // Set data, then start batch. Query the data anew and assert
        Account acc1 = DataFactory.createAccount('Test 1', false);
        Account acc2 = DataFactory.createAccount('Test 2', false);
        Account acc3 = DataFactory.createAccount('Test 3', false);
        insert new List<Account>{ acc1, acc2, acc3 };

        PricebookEntry pbe = DataFactory.initPriceBook('Test Item', 'TTII', 100);
        insert pbe;
        Order o1 = DataFactory.createOrder(acc1, pbe.Pricebook2Id, false);
        Order o1b = DataFactory.createOrder(acc1, pbe.Pricebook2Id, false);
        Order o2 = DataFactory.createOrder(acc2, pbe.Pricebook2Id, false);
        Order o2b = DataFactory.createOrder(acc2, pbe.Pricebook2Id, false);
        Order o3 = DataFactory.createOrder(acc3, pbe.Pricebook2Id, false);
        Order o3b = DataFactory.createOrder(acc3, pbe.Pricebook2Id, false);
        insert new List<Order>{ o1, o2, o3, o1b, o2b, o3b };

 
        OrderItem oi1 = DataFactory.createOrderItem(o1, pbe.Id, 100, false);
        OrderItem oi1b = DataFactory.createOrderItem(o1b, pbe.Id, 100, false);
        OrderItem oi2 = DataFactory.createOrderItem(o2, pbe.Id, 200, false);
        OrderItem oi2b = DataFactory.createOrderItem(o2b, pbe.Id, 200, false);
        OrderItem oi3 = DataFactory.createOrderItem(o3, pbe.Id, 300, false);
        OrderItem oi3b = DataFactory.createOrderItem(o3b, pbe.Id, 300, false);
        insert new List<OrderItem>{ oi1, oi2, oi3, oi1b, oi2b, oi3b };

        // Change status of orders to "activated"
        o1.status = ACTIVATED;
        o1b.Status = ACTIVATED;
        o2.status = ACTIVATED;
        o2b.Status = ACTIVATED;
        o3.status = ACTIVATED;
        o3b.Status = ACTIVATED;
        update new List<Order>{ o1, o2, o3, o1b, o2b, o3b };
        // Update all accounts
        Test.startTest();
        UpdateAccounts.run();
        Test.stopTest();

        // Query the data anew and assert
        List<Account> accounts = [SELECT Chiffre_d_affaire__c
                                  FROM Account
                                  ORDER BY Chiffre_d_affaire__c ASC];
        System.assertEquals(3, accounts.size());
        System.assertEquals(200, accounts[0].Chiffre_d_affaire__c);
        System.assertEquals(400, accounts[1].Chiffre_d_affaire__c);
        System.assertEquals(600, accounts[2].Chiffre_d_affaire__c);
    }

}