@isTest
private class TestProductController {

    @isTest static void testGetProducts() {

        insert new Org_Configuration_List__c(Name='TestPeriodTerm',  Period_Term__c=8);

        List<Product_Table__c> testProducts = new List<Product_Table__c>();
        
        ProductTableController controllerTest = new ProductTableController();

        System.assertEquals(testProducts , controllerTest.getProducts() );
    }
}