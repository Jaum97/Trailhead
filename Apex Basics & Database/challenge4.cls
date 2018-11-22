/*
https://trailhead.salesforce.com/content/learn/modules/apex_database/apex_database_sosl

Developer Beginner > Apex Basics & Database > Write SOSL Queries

Your Challenge
Create an Apex class that returns both contacts and leads based on a parameter.
To pass this challenge, create an Apex class that returns both contacts and leads that have first or last name matching the incoming parameter.

    The Apex class must be called ContactAndLeadSearch and be in the public scope
    The Apex class must have a public static method called searchContactsAndLeads
        The method must accept an incoming string as a parameter
        The method should then find any contact or lead that matches the string as part of either the first or last name
        The method should finally use a return type of List<List< SObject>>
    NOTE: Because SOSL indexes data for searching, you must create a Contact record and Lead record before checking this challenge. Both records must have the last name Smith. The challenge uses these records for the SOSL search
    */

public class ContactAndLeadSearch {
  public static List<List<SObject>> searchContactsAndLeads(String mystring){
    try{
      List<List<SObject>> mylist = [
          FIND :mystring 
          IN ALL FIELDS 
          RETURNING Contact(FirstName,LastName),Lead(FirstName,LastName)
      ];
      return mylist;
    }catch(DmlException e){
      System.debug('A DML exception has occurred: ' +
      e.getMessage());
      return null;
    }
  }
}