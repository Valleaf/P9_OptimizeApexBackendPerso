@isTest
public with sharing class MyTeamOrdersControllerTEST{
    @isTest
    public static void MyTeamOrdersControllerTest(){
        // Test with a single user
        User u = DataFactory.createStandardUser();
        insert u;
        System.runAs(u){
            Account acc4 = DataFactory.createAccount('Test 4', false);
            insert acc4;
    
            PricebookEntry pbe2 = DataFactory.initPriceBook('Test Item 2', 'TTII', 500);
            insert pbe2;
            Order o4 = DataFactory.createOrder(acc4, pbe2.Pricebook2Id, false);
            Order o4b = DataFactory.createOrder(acc4, pbe2.Pricebook2Id, false);
            insert new List<Order>{ o4,o4b};
    
            OrderItem oi4 = DataFactory.createOrderItem(o4, pbe2.Id, 250, false);
            OrderItem oi4b = DataFactory.createOrderItem(o4b, pbe2.Id, 250, false);
            insert new List<OrderItem>{ oi4, oi4b };
            o4.Status = 'Activated';
            o4b.Status = 'Activated';
            update new list<Order>{ o4, o4b };     
            MyTeamOrdersController mtoC2 = new MyTeamOrdersController();
            Test.startTest();
            Decimal result2 = mtoC2.SumOrders;
            Test.stopTest();
            System.assertEquals(500, result2, 'Result is not correct');
        }
    }

}