Class {
	#name : 'TTDictionaryProjectEnv',
	#superclass : 'TTDictionaryConfigEnv',
	#category : 'Tactical-Project-Example',
	#package : 'Tactical-Project',
	#tag : 'Example'
}

{ #category : 'as yet unclassified' }
TTDictionaryProjectEnv class >> searchPathFor: whoami [
	"Prefer / (a,'.env) over / a , 'env' " 

	| hubId projectId |
 
	hubId := whoami hubId asLowercase.
	projectId := whoami projectId asLowercase.  
 
	"#project origin is Hub current projectDir ($PROJECT_DIR)"
	
	^ {

		#'project-env-override' -> (#file: // #project / '.env') resolve. "gitignored"
		#'project-local-override' -> (#file: // #project / 'local.env') resolve. "gitignored"
		
		"#'project' -> (#file: // #project / (projectId, '.env')) resolve."
		#'project-config' -> (#file: // #project / 'config'/ 'config.env') resolve.
		
		"#'project-platform' -> (#file: // #project / (hubId, '.env')) resolve."
 	 #'project-config-platform-' -> (#file: // #project / 'config' / (hubId , '.env')) resolve.

		#'user-project' -> (#file: // #config / projectId /  'config.env') resolve.
	  #'user-project-prefs' -> (#file: // #preferences / (projectId, '.env') ) resolve.	   
	}
]
