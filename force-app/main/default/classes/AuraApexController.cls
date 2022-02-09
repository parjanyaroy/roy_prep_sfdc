public with Sharing class AuraApexController  {
    
    /*@AuraEnabled
    public static Boolean saveIncomeRecord(String fullName , Integer income , Boolean status)
    {
        insert new IncomeDetail__c(Name=fullName , Income__c=income, Status__c=status);
        return true;
    }
    */
    @AuraEnabled
    public static IncomeDetail__c saveIncomeRecord(String fullName , Integer income)
    {
        IncomeDetail__c newIncome =  new IncomeDetail__c(Name=fullName , Income__c=income, Status__c=true);
        insert newIncome;
        return newIncome;
    }
    
    @AuraEnabled
    public static boolean deleteIncomeRecord(Id recordId)
    {
        IncomeDetail__c inc = new IncomeDetail__c(Id=recordId);
        delete inc;
        return true;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<IncomeDetail__c> getAllIncomeDetail()
    {
        return [Select Id,Name,Income__c,Status__c from IncomeDetail__c order by createddate desc];
    }

}