// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// Température Max.
  static let detailMaxTempTitle = L10n.tr("Localizable", "detail_max_temp_title")
  /// Température Min.
  static let detailMinTempTitle = L10n.tr("Localizable", "detail_min_temp_title")
  /// %@ °C
  static func detailTemperatureCelcius(_ p1: String) -> String {
    return L10n.tr("Localizable", "detail_temperature_celcius", p1)
  }
  /// Index UV
  static let detailUvIndexTitle = L10n.tr("Localizable", "detail_uv_index_title")
  /// %@ / %@
  static func detailWindDirectionAndSpeed(_ p1: String, _ p2: String) -> String {
    return L10n.tr("Localizable", "detail_wind_direction_and_speed", p1, p2)
  }
  /// Vent
  static let detailWindTitle = L10n.tr("Localizable", "detail_wind_title")
  /// %@ °C
  static func homeTemperature(_ p1: String) -> String {
    return L10n.tr("Localizable", "home_temperature", p1)
  }
  /// ANNULER
  static let settingsCancelButton = L10n.tr("Localizable", "settings_cancel_button")
  /// OK
  static let settingsOkButton = L10n.tr("Localizable", "settings_ok_button")
  /// Paramètres
  static let settingsTitle = L10n.tr("Localizable", "settings_title")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
