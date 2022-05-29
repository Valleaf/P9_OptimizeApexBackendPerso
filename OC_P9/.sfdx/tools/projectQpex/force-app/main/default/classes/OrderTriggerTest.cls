@isTest
private class OrderTriggerTest {

    private static final String ACTIVATED = 'Activated';

    @TestSetup
    static void makeData(){
        Account acc1 = DataFactory.createAccount('Test Account 1', true);

        PricebookEntry pbe = DataFactory.initPriceBook('Chemise Verte longue XXL', 'TTII', 100);
        insert pbe;
    }
 

    @isTest static void updateCATest() {
        Account acc1  = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        Product2 pd1 = [SELECT Id FROM Product2 WHERE Name = 'Chemise Verte longue XXL']; 
        PricebookEntry pbe = [SELECT Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id = :pd1.Id LIMIT 1];
        
        Order o1 = DataFactory.createOrder(acc1, pbe.Pricebook2Id, false);
        insert o1;

        OrderItem oi1 = DataFactory.createOrderItem(o1, pbe.Id, 100, false);
        oi1.Quantity = 10;
        insert oi1;

        Test.startTest();
        o1.Status = ACTIVATED;
        update o1;
        Test.stopTest();
        // Query the account
        Account acc2 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        // Assert
        System.assertEquals(1000, acc2.Chiffre_d_affaire__c,'Wrong amount');
    }

    @isTest
    static void updateMontantTestWhenUpdatingShippingCosts() {
        Account acc1  = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        Product2 pd1 = [SELECT Id FROM Product2 WHERE Name = 'Chemise Verte longue XXL']; 
        PricebookEntry pbe = [SELECT Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id = :pd1.Id LIMIT 1];
        
        Order o1 = DataFactory.createOrder(acc1, pbe.Pricebook2Id, false);
        insert o1;

        OrderItem oi1 = DataFactory.createOrderItem(o1, pbe.Id, 100, false);
        OrderItem oi2 = DataFactory.createOrderItem(o1, pbe.Id, 20, false);
        oi1.Quantity = 10;
        oi2.Quantity = 1000;
        insert new List<OrderItem>{oi1,oi2};

        Test.startTest();
        o1.Shipping_Costs__c = 100;
        update o1;
        Test.stopTest();

        // Query the account
        Order o1After = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
        // Assert
        Integer amount = 10*100 + 20*1000 - 100;
        System.assertEquals(amount, o1After.NetAmount__c,'Wrong amount');
    }
}
