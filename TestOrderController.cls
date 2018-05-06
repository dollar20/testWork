@isTest
private class TestOrderController {

    @isTest static void testCreateOrder() {

        insert new Org_Configuration_List__c(Name='TestPeriodTerm',  Period_Term__c=8);
        Product_Table__c testProducts = new Product_Table__c(Name = 'myTestOrderProduct', Added_Date__c = System.today(),Unit_Price__c  = 8.00, Units_Available__c = 16);
        insert testProducts;
        
        ApexPages.currentPage().getParameters().put('id', testProducts.Id);
        
        OrderController controllerTest = new OrderController();
        Contact contact = new Contact(Email='test@test.test', FirstName='testFirstName', LastName='testLastName');
        Product_Table__c product ;
        Order_Table__c order = new Order_Table__c(Units__c=2);
        
        product = controllerTest.product;
        order.Order_Amount__c = product.Unit_Price__c * order.Units__c;
        controllerTest.product = product;
        controllerTest.contact = contact;
        controllerTest.order   = order;
        controllerTest.confirm();
        
        Contact[] dataContact = [SELECT FirstName FROM Contact WHERE Email='test@test.test'];
        System.assertEquals('testFirstName', dataContact[0].FirstName );
    }
}