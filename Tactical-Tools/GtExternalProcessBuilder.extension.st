Extension { #name : 'GtExternalProcessBuilder' }

{ #category : '*Tactical-Tools' }
GtExternalProcessBuilder >> outputProvider [
	"Executes the command as a child process, waiting for it to finish and
	collecting all of its output.
	
	By default, stdout and stderr are captured (and used to provide the
	resulting output). Stdin is not inherited from the parent and any
	attempt by the child process to read from the stdin stream will result
	in the stream immediately closing."

	^ self createNativeCommand output
]
