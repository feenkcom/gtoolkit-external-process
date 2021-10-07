Class {
	#name : #BaselineOfGToolkitExternalProcess,
	#superclass : #BaselineOf,
	#classVars : [
		'PostLoaded'
	],
	#category : #BaselineOfGToolkitExternalProcess
}

{ #category : #baseline }
BaselineOfGToolkitExternalProcess >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:main/boxer-bindings' ];
			baseline: 'GToolkitExamplesEngine' with: [
				spec repository: 'github://feenkcom/gtoolkit-examples:main/src' ].
		spec package: 'GToolkit-ExternalProcess' with: [
				spec requires: #('GToolkitBoxer' 'GToolkitExamplesEngine' ). ]. ].
]
