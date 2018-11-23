/*
https://trailhead.salesforce.com/content/learn/modules/apex_database/apex_database_soql


Developer Beginner > Apex Basics & Database > Write SOQL Queries

Your Challenge
Create an Apex class that returns contacts based on incoming parameters.
For this challenge, you will need to create a class that has a method accepting two strings. The method searches for contacts that have a last name matching the first string and a mailing postal code matching the second. It gets the ID and Name of those contacts and returns them.

    The Apex class must be called ContactSearch and be in the public scope
    The Apex class must have a public static method called searchForContacts
        The method must accept two incoming strings as parameters
        The method should then find any contact that has a last name matching the first string, and mailing postal code (API name: MailingPostalCode) matching the second string
        The method should finally return a list of Contact records of type List that includes the ID and Name fields

*/

public class ContactSearch {
  public static List<Contact> searchForContacts(String lname,String mcode){
    try{
      Contact mylist[] = [
        SELECT ID,Name 
        FROM Contact 
        WHERE LastName=:lname 
        AND MailingPostalCode=:mcode
        ];
      return mylist;
    }catch(DmlException e){
      System.debug('A DML exception has occurred: ' +
      e.getMessage());
      return null;
    }
  }
}