trigger betterOpportunities on Opportunity (before update, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {               
        for (Opportunity opp : Trigger.new) {
            //System.debug(opp.Amount);  //10
            //System.debug(Trigger.oldMap.get(opp.Id).Amount); removed comments from 'Prod' code
            
            //Opportunity opp1 = [SELECT Id, Amount FROM Opportunity WHERE Id = :opp.Id]; No need for SOQL since we are accessing trigger.new
            opp.description = 'Updated by trigger';
            //opp.Amount = 30; not hard coding values as it will over right user input
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate && !TriggerControl.hasRun) {   
        /* 
    	* Did not repeat code from above as trigger.new context is not able to be modified in after trigger context
     	* added actual real-world scenario     
*/
        //add list to store tasks 
        //check to see whether trigger hasRun
        if (!TriggerControl.hasRun)(
        	triggerControl.hasRun = true);
        
        List <Task> addTaskToOpp = new List<Task>();

        for (Opportunity opp : trigger.new){
            //add task
        	Task newTasksForOpp = new Task(
            WhatId = opp.Id,
            Subject = 'Follow up task',
            Description = 'Added by Opportunity after trigger')
         	;
            addTaskToOpp.add(newTasksForOpp);
        }    
		insert addTaskToOpp;
        //reset trigger flag
    	TriggerControl.hasRun = false;
    }

/*ignore the fact that the code is randomly placed here.  The focus is on comments    
insert account; //What happens to line 32 if there is an error on line 31?
insert task;	//An error occurs then previous transaction is rolled back. No records are saved.
*/
}