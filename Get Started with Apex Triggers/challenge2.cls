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

    List<Task> taskList = new List<Task>();
    
    for(Opportunity opp : Trigger.new) {
		
		//Only create Follow Up Task only once when Opp StageName is to 'Closed Won' on Create
		if(Trigger.isInsert) {
			if(Opp.StageName == 'Closed Won') {
				taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
			}
		}
		
		//Only create Follow Up Task only once when Opp StageName changed to 'Closed Won' on Update
		if(Trigger.isUpdate) {
			if(Opp.StageName == 'Closed Won' 
			&& Opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
				taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
			}
		}       
    }

    if(taskList.size()>0) {        
        insert taskList;        
    }    
}