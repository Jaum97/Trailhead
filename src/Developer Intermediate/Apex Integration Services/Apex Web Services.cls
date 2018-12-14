/*
https://trailhead.salesforce.com/content/learn/modules/apex_integration_services/apex_integration_webservices

Developer Intermediate > Apex Integration Services > Apex Web Services

Your Challenge
Create an Apex REST service that returns an account and it's contacts.
To pass this challenge, create an Apex REST class that is accessible at '/Accounts/<Account_ID>/contacts'. The service will return the account's ID and Name plus the ID and Name of all contacts associated with the account. Write unit tests that achieve 100% code coverage for the class and run your Apex tests.

    The Apex class must be called 'AccountManager'.
    The Apex class must have a method called 'getAccount' that is annotated with @HttpGet and returns an Account object.
    The method must return the ID and Name for the requested record and all associated contacts with their ID and Name.
    The unit tests must be in a separate Apex class called 'AccountManagerTest'.
    The unit tests must cover all lines of code included in the AccountManager class, resulting in 100% code coverage.
    Run your test class at least once (via 'Run All' tests the Developer Console) before attempting to verify this challenge.
*/

@RestResource(urlMapping='/Account/*')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        // grab the accountId from the end of the URL
        String accountId = request.requestURI.substringBetween('Accounts/','/contacts');
        Account result = [SELECT Id,Name,
                         (SELECT Id,Name FROM Contacts)
                         FROM Account
                         WHERE Id = :accountId
                         LIMIT 1];
        return result;
    }

}

@isTest
private class AccountManagerTest{
    static testMethod void testMethod1(){
        Account objAccount = new Account(Name = 'test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'test Contact',
                                         AccountId = objAccount.Id);
        insert objContact;
        Id recordId = objAccount.Id;
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://curious-goat-4cli40-dev-ed.my.salesforce.com/services/apexrest/Accounts/'
            + recordId +'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount!= null);
        System.assertEquals('test Account', thisAccount.Name);
    }
}
