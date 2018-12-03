/*
https://trailhead.salesforce.com/content/learn/modules/asynchronous_apex/async_apex_queueable?trail_id=force_com_dev_intermediate

Developer Intermediate > Asynchronous Apex > Control Process with Queueable Apex

Your Challenge
Create an Queueable Apex class that inserts Contacts for Accounts.
Create a Queueable Apex class that inserts the same Contact for each Account for a specific state. Write unit tests that achieve 100% code coverage for the class.

    Create an Apex class called 'AddPrimaryContact' that implements the Queueable interface.
    Create a constructor for the class that accepts as its first argument a Contact sObject and a second argument as a string for the State abbreviation.
    The execute method must query for a maximum of 200 Accounts with the BillingState specified by the State abbreviation passed into the constructor and insert the Contact sObject record associated to each Account. Look at the sObject clone() method.
    Create an Apex test class called 'AddPrimaryContactTest'.
    In the test class, insert 50 Account records for BillingState "NY" and 50 Account records for BillingState "CA". Create an instance of the AddPrimaryContact class, enqueue the job and assert that a Contact record was inserted for each of the 50 Accounts with the BillingState of "CA".
    The unit tests must cover all lines of code included in the AddPrimaryContact class, resulting in 100% code coverage.
    Run your test class at least once (via 'Run All' tests the Developer Console) before attempting to verify this challenge.
*/

public class AddPrimaryContact implements Queueable {
    private Contact con;
    private String stateAbb;
    public AddPrimaryContact(Contact con, String stateAbb) {
        this.con = con;
        this.stateAbb = stateAbb;
    }
    public void execute(QueueableContext context) {
        List<Account> ListAccount = [SELECT ID, Name FROM ACCOUNT WHERE BillingState = :stateAbb LIMIT 200];
        List<Contact> lstContact = new List<Contact>();
        for (Account acc:ListAccount){
                Contact cont = con.clone(false,false,false,false);
                cont.AccountId =  acc.id;
	            lstContact.add( cont );
                if(lstContact.size()>0){
                	insert con;
            	}
        }
	}
}

@isTest
public class AddPrimaryContactTest 
{
     @isTest static void TestList()
     {
         List<Account> Teste = new List <Account>();
         for(Integer i=0;i<50;i++)
         {
             Teste.add(new Account(BillingState = 'CA', name = 'Test'+i));
         }
         for(Integer j=0;j<50;j++)
         {
             Teste.add(new Account(BillingState = 'NY', name = 'Test'+j));
         }
         insert Teste;

         Contact co = new Contact();
         co.FirstName='demo';
         co.LastName ='demo';
         insert co;
         String state = 'CA';
      
          AddPrimaryContact apc = new AddPrimaryContact(co, state);
          Test.startTest();
            System.enqueueJob(apc);
          Test.stopTest();
      }
 }