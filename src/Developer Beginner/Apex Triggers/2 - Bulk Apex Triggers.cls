/*
https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_bulk?trail_id=force_com_dev_beginner

Developer Beginner > Apex Triggers > Bulk Apex Triggers

Your Challenge
Create an Apex trigger for Opportunity that adds a task to any opportunity set to 'Closed Won'.
To complete this challenge, you need to add a trigger for Opportunity. The trigger will add a task to any opportunity inserted or updated with the stage of 'Closed Won'. The task's subject must be 'Follow Up Test Task'.

    The Apex trigger must be called 'ClosedOpportunityTrigger'
    With 'ClosedOpportunityTrigger' active, if an opportunity is inserted or updated with a stage of 'Closed Won', it will have a task created with the subject 'Follow Up Test Task'.
    To associate the task with the opportunity, fill the 'WhatId' field with the opportunity ID.
    This challenge specifically tests 200 records in one operation.
*/

trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> mylist = new List<Task>();
    
    for(Opportunity opp : [SELECT Id FROM Opportunity WHERE StageName = 'Closed Won' AND Id IN : Trigger.New]) {

		if(Trigger.isInsert) {
				mylist.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
		}
		if(Trigger.isUpdate) {
			if(Opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
				mylist.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
			}
		}       
    }
    if(mylist.size()>0){      
     insert mylist;        
    }
}