public class ProductTableController {
    private List<Product_Table__c> products;//you can remove the property and use return without assigning products
    
    public List<Product_Table__c> getProducts()//bracket
    {
        return products = [
            SELECT Id, Name, Title__c, Product_Description__c, Added_Date__c, Warehouse__c, Image_Url__c, Unit_Price__c, Units_Available__c  
            FROM Product_Table__c
            LIMIT 100
        ];
        //you can use return without 'products ='
    }
    
    
    public ProductTableController () {
        
    } 
}