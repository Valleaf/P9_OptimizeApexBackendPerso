public without sharing class MyTeamOrdersController {
    public decimal SumOders{
        get{
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Ordered' OR Status ='ACTIVATED' ];
			return (decimal)groupedResults.get('total');

        }
        set;
    }
}