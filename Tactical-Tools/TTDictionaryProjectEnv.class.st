Class {
	#name : 'TTDictionaryProjectEnv',
	#superclass : 'TTDictionaryConfigEnv',
	#category : 'Tactical-Tools-Vault',
	#package : 'Tactical-Tools',
	#tag : 'Vault'
}

{ #category : 'as yet unclassified' }
TTDictionaryProjectEnv class >> searchPathFor: whoami [
	"Prefer / (a,'.env) over / a , 'env' " 

	| vmId hubId userId projectId |
	
	(whoami askFor: #isWhoAmI) ifFalse: [ self error: 'Must provide identity' ].
	
	vmId := whoami vmId asLowercase.
	hubId := whoami hubId asLowercase.
	projectId := whoami projectId asLowercase. "$PROJECT_ID"
	userId := whoami userId asLowercase.
	
	"(#project is $PROJECT_DIR)"
	
	^ {

		"Project origin defined by $PROJECT"
		#'project-override' -> (File // #project / '.env') resolve. "gitignored"
		#'project' -> (File // #project / (projectId, '.env')) resolve.
		#'project-config' -> (File // #project / 'config'/ (projectId, '.env')) resolve.
		#'project-platform' -> (File // #project / (hubId, '.env')) resolve.
 	 #'project-platform-config' -> (File // #project / 'config' / (hubId , '.env')) resolve.

		#'user-project' -> (File // #config / projectId / (hubId , '.env')) resolve.
	  #'user-project-prefs' -> (File // #preferences / (projectId, '.', hubId , '.env') ) resolve.	   
	}
]
