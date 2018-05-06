public class TriggerHandlerProduct {
  
    public void beforeInsert() {
        setWarehouseData();
    }
 
    private void setWarehouseData() {

        List<Warehouse__c> warehouses;
        List<Product_Table__c> notWarehousesProduct = new List<Product_Table__c>();
        List<Warehouse__c> newWarehouses = new List<Warehouse__c>();
        List<Date> dateAdded = new List<Date> ();    // Массив со значениями дат, из добавляемого списка товаров
        Date minDateAdded;// = System.today();
        Date maxDateAdded;// = System.today(); 

        Map<String,Org_Configuration_List__c> OC = Org_Configuration_List__c.getAll();

        System.debug('periodTerm =  '+ OC.get('TestPeriodTerm').Period_Term__c);

        for (Product_Table__c currProduct : (List<Product_Table__c>) Trigger.new) {
            // на всякий случай если передается пустая дата
            if(currProduct.Added_Date__c == null) currProduct.Added_Date__c = System.today();
            
            dateAdded.add(currProduct.Added_Date__c);
        }
        
        dateAdded.sort();
        
        minDateAdded = dateAdded.get(0);
        maxDateAdded = dateAdded.get(dateAdded.size()-1);

        warehouses = [SELECT Id, Period_Start__c , Period_End__c  FROM Warehouse__c WHERE Period_Start__c <= :minDateAdded AND Period_End__c >= :maxDateAdded];   
        //endPeriod используется только при создании нового warehouse
        //в SOQL нужно использовать maxDateAdded вместо endPeriod
        for (Product_Table__c currProduct : (List<Product_Table__c>) Trigger.new) {

            // проверяем наличие соответствия в warehouse
            for( Warehouse__c searchWarehouse : warehouses ){
            
                if(searchWarehouse.Period_Start__c <= currProduct.Added_Date__c && searchWarehouse.Period_End__c >= currProduct.Added_Date__c)
                    currProduct.Warehouse__c = searchWarehouse.Id;
            }

            // если соответствия не найдено добавляем новый warehouse и привязываем его к продукту
            if(currProduct.Warehouse__c == NULL){
                notWarehousesProduct.add(currProduct); 
                newWarehouses.add(
                    new Warehouse__c(
                         Name = 'Warehouse' + currProduct.Added_Date__c + ' ' + currProduct.Added_Date__c.addDays( Integer.valueOf(OC.get('TestPeriodTerm').Period_Term__c) ),
                         Period_Start__c = currProduct.Added_Date__c ,
                         Period_End__c = currProduct.Added_Date__c.addDays( Integer.valueOf(OC.get('TestPeriodTerm').Period_Term__c) ) 
                    )
                );
            }            
        }
        
        insert newWarehouses;

        for (Integer i = 0; i < notWarehousesProduct.size(); i++) {
          notWarehousesProduct[i].Warehouse__c = newWarehouses[i].Id;
        }
    }
}