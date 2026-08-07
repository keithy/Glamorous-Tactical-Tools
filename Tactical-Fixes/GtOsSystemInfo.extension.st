Extension { #name : 'GtOsSystemInfo' }

{ #category : '*Tactical-Fixes' }
GtOsSystemInfo >> findExecutable: aString [
	"Do a `which` on the supplied executable name
	Run this in a shell to ensure that all logon configuration is performed
	and the PATH is fully expanded."

	| shell builder output path |

	shell := Smalltalk os environment at: 'SHELL' ifAbsent: '/bin/sh'.
	builder := GtExternalProcessBuilder new
		
		command: shell;
		addAllEnvVariablesFromParentWithoutOverride;
		args: {
			(shell endsWith: 'csh') ifTrue: [ '-d' ] ifFalse: [ '-l' ].
			'-c'.
			'/usr/bin/which ', aString asString }.
	output := builder output.
	output status isSuccess
		ifFalse: [ ^ self error: 'Unable to find: ', aString asString, ', process failed to run' ].
	path := output stdout trimBoth.
	path ifEmpty: [ self error: 'Unable to find: ', aString asString, ', executable not found' ].
	^ path asFileReference
]
