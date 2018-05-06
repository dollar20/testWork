public class OrderController {

    public Contact contact {get;set;}
    public Product_Table__c product {get;set;}
    public Order_Table__c order {get;set;}
    public class MyException extends Exception {}

    public OrderController() {

        contact = new Contact();
        order = new Order_Table__c();
        system.debug('id=' + ApexPages.currentPage().getParameters().get('id'));
        product = [SELECT Unit_Price__c, Units_Available__c, Name FROM Product_Table__c WHERE Id =:ApexPages.currentPage().getParameters().get('id') ];
    }

    public PageReference confirm() {
    
        Savepoint sp = Database.setSavepoint();
        try{
        
            if( order.Units__c > product.Units_Available__c )
                throw new MyException('Field Unit Count(' + order.Units__c + ') can\'t be more Product Unit Available(' + product.Units_Available__c + ')' );
                
            Contact[] findContact = [SELECT Id FROM Contact WHERE Email = :contact.Email ];
            
            if(findContact.size()==0){ 
                insert contact;

                system.debug('order= '+order);
                order.Contract__c = contact.Id;
            }else{
                upsert findContact;
                order.Contract__c = findContact[0].Id;
            }
           
            order.Product__c = product.Id;
            insert order;
            
            product.Units_Available__c = product.Units_Available__c - order.Units__c;
            upsert product;
                        

            PageReference listPage = new PageReference('/apex/List');
            listPage.setRedirect(true);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Order Created Successfully.Thank you!'));
            return listPage;
            
        } catch(Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
    }
}