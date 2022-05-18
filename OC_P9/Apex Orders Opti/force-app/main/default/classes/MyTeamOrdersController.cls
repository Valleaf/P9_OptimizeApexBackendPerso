public with sharing class MyTeamOrdersController {
    public decimal SumOrders{
        get{
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order ];
            // TODO: STATUS ORDERED / ACTIVATED ONLY
			return (decimal)groupedResults.get('total');
        }
        set;
    }
}