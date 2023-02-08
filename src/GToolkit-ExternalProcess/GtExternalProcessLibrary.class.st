Class {
	#name : #GtExternalProcessLibrary,
	#superclass : #FFILibrary,
	#traits : 'TGtWithStringBox + TGtWithArrayBoxU8 + TGtWithPhlowRust',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithArrayBoxU8 classTrait + TGtWithPhlowRust classTrait',
	#category : #'GToolkit-ExternalProcess-Library'
}

{ #category : #logger }
GtExternalProcessLibrary class >> initEnvLogger [
	self uniqueInstance initEnvLogger
]

{ #category : #'system startup' }
GtExternalProcessLibrary class >> initialize [
	SessionManager default registerUserClassNamed: self name
]

{ #category : #'system startup' }
GtExternalProcessLibrary class >> startUp: isANewSession [
	isANewSession
		ifTrue: [
			self initEnvLogger ]
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> hasModule [
	"Return if there is a loadable and working Skia library installed, false otherwise"
	<return: #Boolean>
	| aResult |

	aResult := nil.
	
	[ aResult := self primTest ]
		on: Error
		do: [ :e | 
			NonInteractiveTranscript stderr nextPutAll: e description; cr.
			aResult := false ].

	^ aResult ifNil: [ false ]
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> initEnvLogger [
	[ self primInitEnvLogger ]
		on: Error
		do: [ :e | NonInteractiveTranscript stdout nextPutAll: '[Process] Could not init env logger'; cr ]
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> macLibraryName [
	^ FFIMacLibraryFinder findLibrary: 'libProcess.dylib'
]

{ #category : #'private - ffi' }
GtExternalProcessLibrary >> primInitEnvLogger [
	^ self ffiCall: #(void process_init_env_logger())
]

{ #category : #'private - ffi' }
GtExternalProcessLibrary >> primTest [
	^ self ffiCall: #(bool process_test())
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> unix32LibraryName [
	^ FFIUnix32LibraryFinder findLibrary: 'libProcess.so'
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> unix64LibraryName [
	^ FFIUnix64LibraryFinder findLibrary: 'libProcess.so'
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> win32LibraryName [
	^ FFIWindowsLibraryFinder findLibrary: 'Process.dll'
]
