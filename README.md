# Playgrounds
Playgrounds to check different ideas, also some POCs

Configured as a project to easily use CocoaPods in playgrounds.


### List of playgrounds
- __ISP-OtherSide__\
Playgorund demostrating ISP rule from consumer perspective, so injecting only whats needed. 
[Check also this Medium post](https://zalogatomek.medium.com/interface-segregation-principle-look-from-a-different-side-e61bcedc8d58)

- __ISP-OtherSide-Part2__\
Second part of ISP rule, showing same problem but with reactive approach.

- __RuntimeWarnings__\
Trying to achieve runtime warnings in Xcode, working similar to `assertionFailure`, but without breaking app execution. Hacky, but working.

- __Rx+DisposeBag__\
Check, if its safe to use disposeBag inside struct

- __SwiftUI+Coordinator__\
Simple implementation of Coordinator (FlowController/Router) pattern in SwiftUI

- __Swinject+UnitTests_DependencyOverride__\
POC showing posibility to override dependencies for unit testing with [Swinject](https://github.com/Swinject/Swinject).
