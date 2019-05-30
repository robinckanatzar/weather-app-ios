import Foundation

protocol ScreenResolverProtocol {
    func resolve<Screen>(screenType: Screen.Type) -> Screen
    func resolve<Screen, Arg1>(screenType: Screen.Type, argument: Arg1) -> Screen
}
