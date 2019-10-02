# ghosts_on_the_train

Oh no! There are ghosts on the train! Team up with your fellow commuters to bust their ghostly butts.

https://github.com/nickmeinhold/ghosts_on_the_train

## Debugging with RemoteDevTools 

see https://github.com/MichaelMarner/dart-redux-remote-devtools

Get the local ip from Network Preferences and update main_rdt.dart
`remotedev --port 8000`
Run Debug Mobile configuration from launch.json 
open `http://localhost:8000`

## Generated Code 

Models use [built_value](https://pub.dev/packages/built_value).

Run codegen with: 
`flutter pub run build_runner build`