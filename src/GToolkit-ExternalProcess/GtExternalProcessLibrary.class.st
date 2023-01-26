Class {
	#name : #GtExternalProcessLibrary,
	#superclass : #FFILibrary,
	#traits : 'TGtWithStringBox + TGtWithArrayBoxU8',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithArrayBoxU8 classTrait',
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
GtExternalProcessLibrary >> detectLibrary: aFileName [
	"Pharo9 introduced a platform specific FFILibraryFinder which should be used instead of this custom implementation"

	^ ({ Smalltalk imageDirectory . Smalltalk vmDirectory . Smalltalk vmBinary parent / 'Plugins'. FileSystem workingDirectory }
		collect: [ :aPath | aPath asFileReference / aFileName ])
			detect: #exists
			ifFound: #fullName
			ifNone: [ aFileName ]
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
	^ self class environment
		at: #FFIMacLibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libProcess.dylib' ]
		ifAbsent: [ self detectLibrary: 'libProcess.dylib' ]
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
	^ self class environment
		at: #FFIUnix32LibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libProcess.so' ]
		ifAbsent: [ self detectLibrary: 'libProcess.so' ]
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> unix64LibraryName [
	^ self class environment
		at: #FFIUnix64LibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libProcess.so' ]
		ifAbsent: [ self detectLibrary: 'libProcess.so' ]
]

{ #category : #'api - library' }
GtExternalProcessLibrary >> win32LibraryName [
	^ self class environment
		at: #FFIWindowsLibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findAnyLibrary: #('Process.dll') ]
		ifAbsent: [ self detectLibrary: 'Process.dll' ]
]
