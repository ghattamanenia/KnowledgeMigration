public with sharing class ProcessInstanceDAO {

	public static List<ProcessInstance> getProcessInstance(String qhId){
		return [SELECT 
					Id, 
					(SELECT 
						Id, 
						ActorId
					FROM 
						Workitems)
				FROM 
					ProcessInstance
				Where 
					TargetObjectId = :qhId
				order by CreatedDate Desc
				limit 1];
	}
}