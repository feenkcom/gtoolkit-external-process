Class {
	#name : #GtNativeExternalProcessExitStatus,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalProcessExitStatus class >> ffiLibrary [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNativeExternalProcessExitStatus class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_exit_status_drop(void** aHandle))
]

{ #category : #accessing }
GtNativeExternalProcessExitStatus >> code [
	<return: #Number or: #nil>

	^ self hasCode
		ifTrue: [ self primCode ]
		ifFalse: [ nil ]
]

{ #category : #'gt-extension' }
GtNativeExternalProcessExitStatus >> gtInfoFor: aView [
	<gtView>

	^ ({
		'success' -> self isSuccess.
		'exit code' -> (self isExitedWithCode
			ifTrue: [ self code ]
			ifFalse: [ 'terminated by signal without code' ]).
	 } asOrderedDictionary gtItemsFor: aView)
			title: 'Info';
			priority: 2
]

{ #category : #testing }
GtNativeExternalProcessExitStatus >> hasCode [
	^ self primHasCode
]

{ #category : #testing }
GtNativeExternalProcessExitStatus >> isExitedWithCode [
	"Return true if the process exited with a status code"

	^ self hasCode
]

{ #category : #testing }
GtNativeExternalProcessExitStatus >> isSuccess [
	^ self primSuccess
]

{ #category : #testing }
GtNativeExternalProcessExitStatus >> isTerminatedBySignal [
	"Return true if the process was terminated by a signal"

	^ self hasCode not
]

{ #category : #'private - ffi' }
GtNativeExternalProcessExitStatus >> primCode [
	^ self ffiCall: #(int32 process_exit_status_code(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessExitStatus >> primHasCode [
	^ self ffiCall: #(bool process_exit_status_has_code(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessExitStatus >> primSuccess [
	^ self ffiCall: #(bool process_exit_status_success(self))
]
