Class {
	#name : #GtNativeExternalProcessStdioPiped,
	#superclass : #GtNativeExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessStdioPiped class >> primCreate [
	^ self ffiCall: #(void* process_stdio_piped())
]
