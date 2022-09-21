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
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.41/boxer-bindings' ].
		spec
			baseline: 'GToolkitExamplesEngine' with: [
				spec repository: 'github://feenkcom/gtoolkit-examples:v0.8.64/src' ].

		spec package: 'GToolkit-ExternalProcess' with: [
			spec requires: #('GToolkitBoxer' 'GToolkitExamplesEngine') ].
	]
]
