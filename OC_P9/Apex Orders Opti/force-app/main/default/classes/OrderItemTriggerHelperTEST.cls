@isTest
public with sharing class OrderItemTriggerHelperTEST {

    
    @TestSetup
    static void makeData(){
        Account acc1 = DataFactory.createAccount('Test Account 1', true);

        PricebookEntry pbe = DataFactory.initPriceBook('Chemise Verte longue XXL', 'TTII', 100);
        insert pbe;
    }

    @isTest
    static void updateMontantTestwhenUsingOrderItems() {
        Account acc1  = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        Product2 pd1 = [SELECT Id FROM Product2 WHERE Name = 'Chemise Verte longue XXL']; 
        PricebookEntry pbe = [SELECT Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id = :pd1.Id LIMIT 1];
        
        Order o1 = DataFactory.createOrder(acc1, pbe.Pricebook2Id, false);
        insert o1;

        Test.startTest();
        OrderItem oi1 = DataFactory.createOrderItem(o1, pbe.Id, 100, false);
        OrderItem oi2 = DataFactory.createOrderItem(o1, pbe.Id, 20, false);
        oi1.Quantity = 10;
        oi2.Quantity = 1000;
        // Insert OrderItems
        insert new List<OrderItem>{oi1,oi2};
        Order o1AfterInsert = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
        Integer amountAfterInsert = 10*100 + 20*1000;
        System.assertEquals(amountAfterInsert, o1AfterInsert.NetAmount__c,'Wrong amount');

        // Update OrderItems
        oi1.Quantity = 20;
        oi2.UnitPrice = 2000;
        update new List<OrderItem>{oi1,oi2};
        Order o1AfterUpdate = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
        Integer amountAfterUpdate = 20*100 + 2000*1000;
        System.assertEquals(amountAfterUpdate, o1AfterUpdate.NetAmount__c,'Wrong amount');
        // Delete OrderItems
        delete new List<OrderItem>{oi1,oi2};
        Test.stopTest();
        // Query the account
        Order o1AfterDelete = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
        // Assert
        System.assertEquals(0, o1AfterDelete.NetAmount__c,'Wrong amount');
    }
}
