// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  ///  and
  public static let and = L10n.tr("Base", "and")
  /// Blood glucose unit
  public static let bloodGlucoseUnit = L10n.tr("Base", "blood_glucose_unit")
  /// By continuing, you agree to UVIO’s
  public static let byContinuing = L10n.tr("Base", "by_continuing")
  /// Complete
  public static let complete = L10n.tr("Base", "complete")
  /// Cone
  public static let cone = L10n.tr("Base", "cone")
  /// CREATE ACCOUNT
  public static let createAccount = L10n.tr("Base", "create_account")
  /// DONE
  public static let done = L10n.tr("Base", "done")
  /// Don’t have an account yet? 
  public static let dontHaveAccount = L10n.tr("Base", "dont_have_account")
  /// Email Address
  public static let emailAddress = L10n.tr("Base", "email_address")
  /// Female
  public static let female = L10n.tr("Base", "female")
  /// Forgot Password?
  public static let forgotPassword = L10n.tr("Base", "forgot_password")
  /// My full name
  public static let fullName = L10n.tr("Base", "full_name")
  /// Gestational diabetes
  public static let gestationalDiabetes = L10n.tr("Base", "gestational_diabetes")
  /// Hyper (High Glucose)
  public static let hyperHighGlucose = L10n.tr("Base", "hyper_high_glucose")
  /// Hypers and hypos
  public static let hypersAndHypos = L10n.tr("Base", "hypers_and_hypos")
  /// Hypo (Low Glucose)
  public static let hypoLowGlucose = L10n.tr("Base", "hypo_low_glucose")
  /// I'm not sure which type I have
  public static let iNotSure = L10n.tr("Base", "i_not_sure")
  /// LADA
  public static let lada = L10n.tr("Base", "lada")
  /// Male
  public static let male = L10n.tr("Base", "male")
  /// mg/dL
  public static let mgDL = L10n.tr("Base", "mg/dL")
  /// mmol/l
  public static let mmolL = L10n.tr("Base", "mmol/l")
  /// MODY
  public static let mody = L10n.tr("Base", "mody")
  /// Next
  public static let next = L10n.tr("Base", "next")
  /// Non-binary
  public static let nonBinary = L10n.tr("Base", "non_binary")
  /// Password
  public static let password = L10n.tr("Base", "password")
  /// Prediabetes
  public static let prediabetes = L10n.tr("Base", "prediabetes")
  ///  Privacy Policy.
  public static let privacyPolicy = L10n.tr("Base", "privacy_policy")
  /// Provide own
  public static let provideOwn = L10n.tr("Base", "provideOwn")
  /// Sign In
  public static let signIn = L10n.tr("Base", "sign_in")
  /// Sign In with Apple
  public static let signInWihtApple = L10n.tr("Base", "sign_in_wiht_apple")
  /// Sign In with Email
  public static let signInWithEmail = L10n.tr("Base", "sign_in_with_email")
  /// Sign In with Facebook
  public static let signInWithFacebook = L10n.tr("Base", "sign_in_with_facebook")
  /// Sign In with Google
  public static let signInWithGoogle = L10n.tr("Base", "sign_in_with_google")
  /// Sign Up
  public static let signUp = L10n.tr("Base", "sign_up")
  /// Sign Up with Apple
  public static let signUpWihtApple = L10n.tr("Base", "sign_up_wiht_apple")
  /// Sign Up with Email
  public static let signUpWithEmail = L10n.tr("Base", "sign_up_with_email")
  /// Sign Up with Facebook
  public static let signUpWithFacebook = L10n.tr("Base", "sign_up_with_facebook")
  /// Sign Up with Google
  public static let signUpWithGoogle = L10n.tr("Base", "sign_up_with_google")
  /// Skip
  public static let skip = L10n.tr("Base", "skip")
  /// Specify another
  public static let specifyAnother = L10n.tr("Base", "specify_another")
  /// Take back teh Control over your Diabetes
  public static let takeBack = L10n.tr("Base", "take_back")
  /// Take back the Control over your Diabetes
  public static let takeBackControl = L10n.tr("Base", "take_back_control")
  /// Target level
  public static let targetLevel = L10n.tr("Base", "target_level")
  /// Target range
  public static let targetRange = L10n.tr("Base", "target_range")
  ///  Terms of Service
  public static let termsOfService = L10n.tr("Base", "terms_of_service")
  /// Type 1 diabetes
  public static let type1Diabetes = L10n.tr("Base", "type_1_diabetes")
  /// Type 2 diabetes
  public static let type2Diabetes = L10n.tr("Base", "type_2_diabetes")
  /// UVIO
  public static let uvio = L10n.tr("Base", "uvio")
  /// What is your Birth Date?
  public static let whatIsYourBD = L10n.tr("Base", "what_is_your_BD")
  /// What is your Gender?
  public static let whatIsYourGender = L10n.tr("Base", "what_is_your_gender")
  /// What is your Name?
  public static let whatName = L10n.tr("Base", "what_name")
  /// Which type of diabetes do you have?
  public static let whichTypeDiabetes = L10n.tr("Base", "which_type_diabetes")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
