// --------------- TEST SINGLETON - LAZY --------------------
SingletonClass s1 = SingletonClass.getClassInstance();
System.debug(s1);
System.debug(s1.data);
s1.data = '123'; // This will error as the setter is set to private

// --------------- TEST SINGLETON - EAGER --------------------
SingletonClassEager s2 = SingletonClassEager.getClassInstance();
System.debug(s2);
System.debug(s2.data);
s2.data = '123'; // This will error as the setter is set to private
//---------------- STRATEGY PATTERN --------------------------
CalculateOperator c1 = new CalculateOperator('+');
System.debug('-------------'+c1.DoOperation(3,2));
CalculateOperator c2 = new CalculateOperator('-');
System.debug('-------------'+c2.DoOperation(3,2));
//---------------FACADE --------------------------------
ComplexOperationFacade c1 = new ComplexOperationFacade();
System.debug(((ComplexOperationFacade.OperationResponse)(c1.getCustomerDetails('sample'))).addressDetails);

//------------ TRIGGER FRAMEWORK ------------------
Account a = new Account(name='Roy');
insert a;
Account a =[Select Id,Name from Account where Name='Roy' limit 1];
a.Name='Paral';
update a;
//------------CLONE ---------
Account acc = new account(Name = 'Acme', Description = 'Acme Account');
insert acc;
Contact c1 = new Contact(LastName='Roy',AccountId=acc.Id);
insert c1 ;
Contact clonedContact1 = c1.clone(false, false, false, false);
Contact clonedContact2 = c1.clone(true, true, false, false);
System.debug(clonedContact1);
System.debug(clonedContact2);
// --------------------- DYNAMIC APEX ----------------------------------
System.debug(ApexUtil.getAllSObject());
System.debug(ApexUtil.getAllFields('IncomeDetail__c'));
System.debug(ApexUtil.getAllPickListValues('Case','Status'));
System.debug(ApexUtil.getRecordTypes('IncomeDetail__c'));