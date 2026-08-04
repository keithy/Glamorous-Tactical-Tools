Extension { #name : 'UnixResolver' }

{ #category : '*Tactical-Fixes' }
UnixResolver >> preferences [

	<origin>
	
	"http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html"

	^ self directoryFromEnvVariableNamed: 'XDG_CONFIG_HOME' or: [ self home / '.config' ]
]

{ #category : '*Tactical-Fixes' }
UnixResolver >> temp [

	<origin>
	
^self directoryFromEnvVariableNamed: 'TMPDIR' or: [  
	 '/tmp' asFileReference]
]
