/*
https://trailhead.salesforce.com/content/learn/modules/apex_integration_services/apex_integration_webservices

Developer Intermediate > Apex Integration Services > Apex SOAP Callouts

Your Challenge
Generate an Apex class using WSDL2Apex and write a test class.
Generate an Apex class using WSDL2Apex for a SOAP web service, write unit tests that achieve 100% code coverage for the class using a mock response, and run your Apex tests.

    Use WSDL2Apex to generate a class called 'ParkService' in public scope using this WSDL file. After you click the 'Parse WSDL' button don't forget to change the name of the Apex Class Name from 'parksServices' to 'ParkService'.
    Create a class called 'ParkLocator' that has a 'country' method that uses the 'ParkService' class and returns an array of available park names for a particular country passed to the web service. Possible country names that can be passed to the web service include Germany, India, Japan and United States.
    Create a test class named ParkLocatorTest that uses a mock class called ParkServiceMock to mock the callout response.
    The unit tests must cover all lines of code included in the ParkLocator class, resulting in 100% code coverage.
    Run your test class at least once (via 'Run All' tests the Developer Console) before attempting to verify this challenge
*/

public class ParkLocator {
    public static List<String> country(String countryName){
    	ParkService.ParksImplPort park = new ParkService.ParksImplPort();
    	return (List<String>)park.byCountry(countryName);
   }
}

@isTest
global class ParkServiceMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        ParkService.byCountryResponse response_x = 
            new ParkService.byCountryResponse();
            
        List<String> myStrings = new List<String> {'Park1','Park2','Park3'};
    
        response_x.return_x = myStrings;
        // end
        response.put('response_x', response_x); 
   }
}

@isTest
private class ParkLocatorTest  {
    @isTest static void testCallout() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        // Call the method that invokes a callout
        List<String> result = new List<String>();
        List<String> expectedvalue = new List<String>{'Park1','Park2','Park3'};
        
        result = ParkLocator.country('India');
        // Verify that a fake result is returned
        System.assertEquals(expectedvalue, result); 
    }
}