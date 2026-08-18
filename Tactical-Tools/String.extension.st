Extension { #name : 'String' }

{ #category : '*Tactical-Tools' }
String >> // it [

"start of // aka double dispatch"

^ Hub current startDoubleSlashFromString: self with: it 
]

{ #category : '*Tactical-Tools' }
String >> fileReferenceFrom: aHub [
	
	"double dispatch"
	^ aHub fileReferenceFromString: self
	
]

{ #category : '*Tactical-Tools' }
String >> gtCloneGithubRepository [

	<ttFix:'was misparsing organisation as https'>
	
	| remote |
	remote := IceGitRemote url: self.
	^ GtGitRepository fromIcebergRepository: (IceRepository repositoryClass creatorClass new
		   remote: remote;
		   location: IceLibgitRepository repositoriesLocation / remote owner / remote projectName;
		   createRepository)
]

{ #category : '*Tactical-Tools' }
String >> templateResolveUsing: aVault [

	^ self
]
