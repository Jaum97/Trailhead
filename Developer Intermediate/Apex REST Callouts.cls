/*
    https://trailhead.salesforce.com/content/learn/modules/apex_integration_services/apex_integration_rest_callouts?trail_id=force_com_dev_intermediate

    Developer Intermediate > Apex Integration Services > Apex REST Callouts

    Your Challenge
Create an Apex class that calls a REST endpoint and write a test class.
To pass this challenge, create an Apex class that calls a REST endpoint to return the name of an animal, write unit tests that achieve 100% code coverage for the class using a mock response, and run your Apex tests.

    The Apex class must be called 'AnimalLocator', have a 'getAnimalNameById' method that accepts an Integer and returns a String.
    The 'getAnimalNameById' method must call https://th-apex-http-callout.herokuapp.com/animals/:id, using the ID passed into the method. The method returns the value of the 'name' property (i.e., the animal name).
    Create a test class named AnimalLocatorTest that uses a mock class called AnimalLocatorMock to mock the callout response.
    The unit tests must cover all lines of code included in the AnimalLocator class, resulting in 100% code coverage.
    Run your test class at least once (via 'Run All' tests the Developer Console) before attempting to verify this challenge.
*/
public class AnimalLocator {
    public static String getAnimalNameById(Integer animalId){
      	Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+animalId);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        Map<String, Object> animal = new Map<String, Object>();
        if (res.getStatusCode() == 200) {
            //Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            animal = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            animal = (Map<String,Object>) animal.get('animal');
        }
        return (String)animal.get('name');
    }
}

@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
         HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        res.setStatusCode(200);
        return res;
    }
}

@isTest
private class AnimalLocatorTest{
    @isTest static  void AnimalLocatorMock1() {
        Test.SetMock(HttpCallOutMock.class, new AnimalLocatorMock());
        string result = AnimalLocator.getAnimalNameById(3);
        System.assertEquals(result, 'chicken');
    }
}