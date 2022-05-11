@isTest
private class OrderTriggerHelperTEST {

    private static final String ORDERED = 'Ordered';

    @TestSetup
    static void makeData(){
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

    }


    @isTest static void updateCATest() {
        Account acc1  = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        Product2 pd1 = [SELECT Id FROM Product2 WHERE Name = 'Chemise Verte longue XYX']; 
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Commercial' LIMIT 1];
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id = :pd1.Id LIMIT 1];
        System.runAs(u){
            Order o1 = new Order(AccountId = acc1.Id);
            Order o2 = new Order(AccountId = acc1.Id);
            insert new List<Order>{o1, o2};

            OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
            OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
            OrderItem oi3 = new OrderItem (OrderId = o2.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 100);
            OrderItem oi4 = new OrderItem (OrderId = o2.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
            insert new List<OrderItem> {oi1,oi2,oi3,oi4};  

            Test.startTest();
            o1.Status = ORDERED;
            Test.stopTest();
            // Query the account
            Account acc2 = [SELECT Id, Name FROM Account WHERE Id = :acc1.Id];
            // Assert
            Integer amount = 10*150 + 20*1000 + 20*100 + 20*1000;
            System.assertEquals(amount, acc2.Chiffre_d_affaire__c,'Wrong amount');
        }
    }

    @isTest
    static void updateMontantTest() {
        Product2 pd1 = [SELECT Id FROM Product2 WHERE Name = 'Chemise Verte longue XYX']; 
        Account acc1  = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1'];
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Commercial' LIMIT 1];
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry WHERE Product2Id = :pd1.Id LIMIT 1];

        System.runAs(u){
            Order o1 = new Order(AccountId = acc1.Id);
            o1.Shipping_Costs__c = 100;
            insert o1;

            Test.startTest();
            OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
            OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
            insert new List<OrderItem> {oi1,oi2};  
            Test.stopTest();
            // Query the account
            Order o1After = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
            // Assert
            Integer amount = 10*150 + 20*1000 - 100;
            System.assertEquals(amount, o1.NetAmount__c,'Wrong amount');
        }
    }
}
