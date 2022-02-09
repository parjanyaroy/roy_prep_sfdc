public with sharing class ComplexOperationFacade {
    
    public class OperationResponse{
        public string accountName {get;private set;}
        public string addressDetails {get;private set;}
        public OperationResponse(String name,String address)
        {
            this.accountName=name;
            this.addressDetails=address;
        }
    }

    public ComplexOperationFacade.OperationResponse getCustomerDetails(String param1)
    {
        // Complex webservice call to retrieve accountName using param1
        String accountName = 'test Name';
        // Complex webservice call to retrieve address details using account name
        String address = 'test address';
        return new ComplexOperationFacade.OperationResponse(accountName,address);
    }
    

}