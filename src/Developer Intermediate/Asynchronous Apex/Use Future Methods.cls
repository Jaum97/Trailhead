/*
https://trailhead.salesforce.com/content/learn/modules/asynchronous_apex/async_apex_future_methods?trail_id=force_com_dev_intermediate

Developer Intermediate > Asynchronous Apex > Use Future Methods

Your Challenge
Create an Apex class that uses the @future annotation to update Account records.
Create an Apex class with a method using the @future annotation that accepts a List of Account IDs and updates a custom field on the Account object with the number of contacts associated to the Account. Write unit tests that achieve 100% code coverage for the class.

    Create a field on the Account object called 'Number_of_Contacts__c' of type Number. This field will hold the total number of Contacts for the Account.
    Create an Apex class called 'AccountProcessor' that contains a 'countContacts' method that accepts a List of Account IDs. This method must use the @future annotation.
    For each Account ID passed to the method, count the number of Contact records associated to it and update the 'Number_of_Contacts__c' field with this value.
    Create an Apex test class called 'AccountProcessorTest'.
    The unit tests must cover all lines of code included in the AccountProcessor class, resulting in 100% code coverage.
    Run your test class at least once (via 'Run All' tests the Developer Console) before attempting to verify this challenge.
*/
global class AccountProcessor {
    @future
    public static void countContacts(Set<ID> accountIDs) {
    	List<Account> accs = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id IN :accountIDs];
    	for( Account acc : accs ){
            List<Contact> cons = acc.contacts ;
            acc.Number_of_Contacts__c = cons.size();
        }
        update accs;
    }
}

@isTest
public class AccountProcessorTest {
    @isTest public static void accnt(){
        Account a = new Account();
        a.Name = 'Test Account';
        Insert a;

        Contact cont = New Contact();
        cont.FirstName ='Bob';
        cont.LastName ='Masters';
        cont.AccountId = a.Id;
        Insert cont;

        Set<Id> setAccId = new Set<ID>();
        setAccId.add(a.id);

        Test.startTest();
        	AccountProcessor.countContacts(setAccId);
        Test.stopTest();
    }
}
