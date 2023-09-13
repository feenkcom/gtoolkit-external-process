"
#External process builder
A process builder, providing fine-grained control over how a new process should be spawned.
A default configuration can be generated using:
{{gtExample:GtExternalProcessExamples>>defaultProcessBuilder}}
 
Additional builder methods allow the configuration to be changed (for example, by adding arguments) prior to spawning:
{{gtExample:GtExternalProcessExamples>>echoHello}}
"
Class {
	#name : #GtExternalProcessBuilder,
	#superclass : #Object,
	#instVars : [
		'command',
		'arguments',
		'environmentVariablesCommands',
		'stdout',
		'stderr',
		'stdin',
		'workingDirectory',
		'windowsProcessCreationFlags'
	],
	#classVars : [
		'WINDOWS_CREATE_NO_WINDOW',
		'WINDOWS_DETACHED_PROCESS'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #initialization }
GtExternalProcessBuilder class >> initialize [
	"See https://docs.microsoft.com/en-us/windows/win32/procthread/process-creation-flags"
	
	WINDOWS_DETACHED_PROCESS := 16r00000008.
	WINDOWS_CREATE_NO_WINDOW := 16r08000000
]

{ #category : #'instance creation' }
GtExternalProcessBuilder class >> new: aProgram [
	"Constructs a new process builder for launching the program at
	path `aProgram`, with the following default configuration:
	
	* No arguments to the program
	* Inherit the current process's environment
	* Inherit the current process's working directory
	* Inherit stdin/stdout/stderr for `spawn` or `status`, but create pipes for `output`
	
	Builder methods are provided to change these defaults and
	otherwise configure the process.
	
	If `aProgram` is not an absolute path, the `PATH` will be searched in an OS-defined way.
	
	The search path to be used may be controlled by setting the
	`PATH` environment variable on the Process, but this has some implementation limitations on Windows
	(see issue https://github.com/rust-lang/rust/issues/37519)."

	^ self new command: aProgram
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> arg: anArgumentString [
	"Adds an argument to pass to the program.
	Only one argument can be passed per use. So instead of:
	```
	GtExternalProcessBuilder new
		command: 'sh';
		arg: '-C /path/to/repo'
	```
	usage would be:
	```
	GtExternalProcessBuilder new
		command: 'sh';
		arg: '-C';
		arg: '/path/to/repo'
	```
	
	To pass multiple arguments see #args:.
	
	Note that the argument is not passed through a shell, but given
	literally to the program. This means that shell syntax like quotes,
	escaped characters, word splitting, glob patterns, substitution, etc.
	have no effect.Note that the argument is not passed through a shell, but given
	literally to the program. This means that shell syntax like quotes,
	escaped characters, word splitting, glob patterns, substitution, etc.
	have no effect."

	arguments add: anArgumentString
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> args: aCollection [
	"Adds multiple arguments to pass to the program.
	To pass a single argument see #arg:.
	
	Note that the arguments are not passed through a shell, but given
	literally to the program. This means that shell syntax like quotes,
	escaped characters, word splitting, glob patterns, substitution, etc.
	have no effect."

	arguments addAll: aCollection
]

{ #category : #accessing }
GtExternalProcessBuilder >> arguments [

	^ arguments
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> arguments: aCollection [
	"Add given arguments. See #args: for more info"

	self args: aCollection
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> clearEnv [
	"Clears the entire environment map for the child process."

	environmentVariablesCommands add: (#clear -> nil)
]

{ #category : #accessing }
GtExternalProcessBuilder >> command [
	^ command
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> command: aProgram [
	"Sets the process builder to launch the program at path `aProgram`.
	
	If `aProgram` is not an absolute path, the `PATH` will be searched in an OS-defined way.
	
	The search path to be used may be controlled by setting the
	`PATH` environment variable on the Process, but this has some implementation limitations on Windows
	(see issue https://github.com/rust-lang/rust/issues/37519)."

	command := aProgram
]

{ #category : #private }
GtExternalProcessBuilder >> createNativeCommand [
	| anExternalCommand |
	
	anExternalCommand := GtNativeExternalProcessCommand new: self command.
	arguments do: [ :eachArgument | anExternalCommand arg: eachArgument ].
	
	environmentVariablesCommands do: [ :eachCommand |
		eachCommand key = #set
			ifTrue: [
				anExternalCommand
					setEnv: eachCommand value key asString
					value: eachCommand value value asString ].
		eachCommand key = #remove
			ifTrue: [
				anExternalCommand
					removeEnv: eachCommand value ].
		eachCommand key = #clear
			ifTrue: [ anExternalCommand clearEnv ] ].

	workingDirectory ifNotNil: [ anExternalCommand workingDirectory: workingDirectory ].

	stdout asNativeStdioIn: self workingDirectory during: [ :anStdio | anExternalCommand stdout: anStdio ].
	stderr asNativeStdioIn: self workingDirectory during: [ :anStdio | anExternalCommand stderr: anStdio ].
	stdin asNativeStdioIn: self workingDirectory during: [ :anStdio | anExternalCommand stdin: anStdio ].

	OSPlatform current isWindows
		ifTrue: [ anExternalCommand windowsProcessCreationFlags: windowsProcessCreationFlags ].
	
	^ anExternalCommand
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> env: aNameSymbol value: aValueString [
	"Inserts or updates an environment variable mapping.

	Note that environment variable names are case-insensitive (but case-preserving) on Windows,
	and case-sensitive on all other platforms."

	self
		assert: [ aNameSymbol isString ]
		description: [ 'Env.var name must be a String but was {1}' format: { aNameSymbol class name } ].
		
	self
		assert: [ aValueString isString ]
		description: [ 'Env.var value must be a String but was {1}' format: { aValueString class name } ].

	environmentVariablesCommands add: (#set -> (aNameSymbol -> aValueString))
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> envs: aCollectionOfAssociations [
	"Adds or updates multiple environment variable mappings."

	aCollectionOfAssociations do: [ :eachAssociation |
		self env: eachAssociation key value: eachAssociation value ]
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> fileStderr: aFileReference [
	"Set the child to redirect the standard error (stderr) into a file."

	self stderr: (GtExternalProcessFileStdio new fileReference: aFileReference)
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> fileStdin: aFileReference [
	"Set the child to read the standard input (stdin) from a file."

	self stdin: (GtExternalProcessFileStdio new fileReference: aFileReference)
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> fileStdout: aFileReference [
	"Set the child to redirect the standard output (stdout) into a file."

	self stdout: (GtExternalProcessFileStdio new fileReference: aFileReference)
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> inheritStderr [
	"Set the child to inherit the standard error (stderr) handle from the parent."

	self stderr: GtExternalProcessInheritedStdio new
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> inheritStdin [
	"Set the child to inherit the standard input (stdin) handle from the parent."

	self stdin: GtExternalProcessInheritedStdio new
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> inheritStdout [
	"Set the child to inherit the standard output (stdout) handle from the parent."

	self stdout: GtExternalProcessInheritedStdio new
]

{ #category : #initialization }
GtExternalProcessBuilder >> initialize [
	super initialize.
	
	arguments := OrderedCollection new.
	environmentVariablesCommands := OrderedCollection new.
	stdout := GtExternalProcessDefaultStdio new.
	stderr := GtExternalProcessDefaultStdio new.
	stdin := GtExternalProcessDefaultStdio new.
	
	"windows specific"
	windowsProcessCreationFlags := WINDOWS_CREATE_NO_WINDOW
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> nullStderr [
	"Suppress the standard error (stderr) by redirecting it into the void."

	self stderr: GtExternalProcessNullStdio new
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> nullStdin [
	"Suppress the standard inout (stdin) by reading from the void."

	self stdin: GtExternalProcessNullStdio new
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> nullStdout [
	"Suppress the standard output (stdout) by redirecting it into the void."

	self stdout: GtExternalProcessNullStdio new
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> output [
	"Executes the command as a child process, waiting for it to finish and
	collecting all of its output.
	
	By default, stdout and stderr are captured (and used to provide the
	resulting output). Stdin is not inherited from the parent and any
	attempt by the child process to read from the stdin stream will result
	in the stream immediately closing."

	^ self createNativeCommand output
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> pipeStderr [
	"A new pipe should be arranged to connect the standard error (stderr) handle of parent and child processes."

	self stderr: GtExternalProcessPipedStdio new
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> pipeStdin [
	"A new pipe should be arranged to connect the standard input (stdin) handle of parent and child processes."

	self stdin: GtExternalProcessPipedStdio new
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> pipeStdout [
	"A new pipe should be arranged to connect the standard output (stdout) handle of parent and child processes."

	self stdout: GtExternalProcessPipedStdio new
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> removeEnv: aNameSymbol [
	"Removes an environment variable mapping.

	Note that environment variable names are case-insensitive (but case-preserving) on Windows,
	and case-sensitive on all other platforms."

	self
		assert: [ aNameSymbol isString ]
		description: [ 'Env.var name must be a String but was {1}' format: { aNameSymbol class name } ].

	environmentVariablesCommands add: (#remove -> aNameSymbol)
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> spawn [
	"Executes the command as a child process, returning a handle to it.
	By default, stdin, stdout and stderr are inherited from the parent."

	^ self createNativeCommand spawn
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> status [
	"Executes a command as a child process, waiting for it to finish and collecting its status.
	By default, stdin, stdout and stderr are inherited from the parent."
	<return: #GtNativeExternalProcessExitStatus>

	^ self createNativeCommand status
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> stderr: aGtExternalProcessStdio [
	"Configuration for the child process's standard error (stderr) handle.
	Defaults to `inherit` when used with `#spawn` or `#status`, and defaults to `piped` when used with `#output`"

	stderr := aGtExternalProcessStdio
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> stdin: aGtExternalProcessStdio [
	"Configuration for the child process's standard input (stdin) handle.
	Defaults to `inherit` when used with `#spawn` or `#status`, and defaults to `piped` when used with `#output`"
	stdin := aGtExternalProcessStdio
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> stdout: aGtExternalProcessStdio [
	"Configuration for the child process's standard output (stdout) handle.
	Defaults to `inherit` when used with `#spawn` or `#status`, and defaults to `piped` when used with `#output`"

	stdout := aGtExternalProcessStdio
]

{ #category : #'api - stdio' }
GtExternalProcessBuilder >> stdoutToStdin: anExternalProcessChild [
	"Set the child to read the standard input (stdin) from a an stdout of a given spawed external process."
	
	self
		assert: [ anExternalProcessChild isKindOf: GtNativeExternalProcessChild ]
		description: [ 'In order to pipe an stdout to stdin a process must be #spawn-ed' ].

	self stdin: (GtExternalProcessStdoutToStdio new externalProcessChild: anExternalProcessChild)
]

{ #category : #accessing }
GtExternalProcessBuilder >> workingDirectory [
	<return: #FileReference>
	"Return the working directory in which the command should be executed.
	When not set, the current working directory of the VM is used"

	^ workingDirectory ifNil: [ FileLocator workingDirectory ]
]

{ #category : #'api - configuration' }
GtExternalProcessBuilder >> workingDirectory: aFileReference [
	"Sets the working directory for the child process.
	
	# Platform-specific behavior

	If the program path is relative (e.g., `./script.sh`), it's ambiguous
	whether it should be interpreted relative to the parent's working
	directory or relative to `workingDirectory`.
	The behavior in this case is platform specific and unstable,
	and it's recommended to use #asAbsolute to get an absolute program path instead."

	workingDirectory := aFileReference asFileReference
]
