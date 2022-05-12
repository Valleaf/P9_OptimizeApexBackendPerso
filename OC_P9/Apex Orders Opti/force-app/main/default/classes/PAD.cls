public with sharing class PAD {
	public static final string bypassTrigger;	//List of triggers that can be bypassed
	public static final string userRoleName;	//User Role Name
	public static final string userProfileName;	//User Profile Name
	public static Set<String> triggerTokens = new Set<String>(); //List of code that should be bypassed

	public static boolean canTrigger(string ApexName){	//If no bypass
		return canExecuteTrigger(ApexName);
	}

	public static boolean canExecuteTrigger(String triggerName){
		//If trigger should be bypassed
		List<String> userTriggerChainSplitted = (bypassTrigger != null ? bypassTrigger.split(';') : new List<String>());

		Set<String> userTriggerTokenNotEmpty = new Set<String>();

		for(String token: userTriggerChainSplitted) {	
			if(token.length() != 0) {
				userTriggerTokenNotEmpty.add(token);
			}
		}
		
		triggerTokens.addAll(userTriggerTokenNotEmpty);
		
		if(triggerTokens.contains(triggerName)){
			return false;
		}else return true;
	}

	//bypass trigger in this session
	public static void addTriggerBypass(String triggerName){
		triggerTokens.add(triggerName);
	}

	//remove bypass trigger in this session
	public static void removeTriggerBypass(String triggerName){
		triggerTokens.remove(triggerName);
	} 
}