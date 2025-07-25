import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// Instructions to select language
  ///
  /// In en, this message translates to:
  /// **'Select Your Language'**
  String get selectLanguage;

  /// Information about how to change language
  ///
  /// In en, this message translates to:
  /// **'Your selected language can be changed\nanytime from Settings.'**
  String get selectLanguageDesc;

  /// No description provided for @continueString.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueString;

  /// No description provided for @skipString.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipString;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Your trusted delivery & logistics partner'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Local Deliveries Made Easy'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Book mini trucks, bikes, or autos\nin minutes for all your delivery needs.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Tracking'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with live tracking,\nestimated arrival time, and driver details.'**
  String get onboarding3Desc;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'Trusted by Millions'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Desc.
  ///
  /// In en, this message translates to:
  /// **'From single items to house shifting,\nPorter is built to serve you better.'**
  String get onboarding4Desc;

  /// No description provided for @enterMobileString.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number to continue\nusing delivery and other features'**
  String get enterMobileString;

  /// No description provided for @enterMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterMobileHint;

  /// No description provided for @nameString.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameString;

  /// No description provided for @emailString.
  ///
  /// In en, this message translates to:
  /// **'Email Id'**
  String get emailString;

  /// No description provided for @otpString.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otpString;

  /// No description provided for @loginString.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginString;

  /// No description provided for @registerString.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerString;

  /// No description provided for @driverAskString.
  ///
  /// In en, this message translates to:
  /// **'Are You Driver?'**
  String get driverAskString;

  /// No description provided for @yesString.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesString;

  /// No description provided for @noString.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noString;

  /// No description provided for @updatePersonalDetailsString.
  ///
  /// In en, this message translates to:
  /// **'Update Personal Details'**
  String get updatePersonalDetailsString;

  /// No description provided for @vehicleIdString.
  ///
  /// In en, this message translates to:
  /// **'Vehicle ID'**
  String get vehicleIdString;

  /// No description provided for @driverLicenceString.
  ///
  /// In en, this message translates to:
  /// **'Driver Licence'**
  String get driverLicenceString;

  /// No description provided for @vehicleNo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle No.'**
  String get vehicleNo;

  /// No description provided for @submitString.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitString;

  /// No description provided for @currentLocationString.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocationString;

  /// No description provided for @urbanString.
  ///
  /// In en, this message translates to:
  /// **'Urban'**
  String get urbanString;

  /// No description provided for @ruralString.
  ///
  /// In en, this message translates to:
  /// **'Rural'**
  String get ruralString;

  /// No description provided for @createRequestString.
  ///
  /// In en, this message translates to:
  /// **'Create Request'**
  String get createRequestString;

  /// No description provided for @mapString.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapString;

  /// No description provided for @pickupLocationString.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocationString;

  /// No description provided for @selectItemsString.
  ///
  /// In en, this message translates to:
  /// **'Select items'**
  String get selectItemsString;

  /// No description provided for @descriptionString.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionString;

  /// No description provided for @receiverNameString.
  ///
  /// In en, this message translates to:
  /// **'Receiver Name'**
  String get receiverNameString;

  /// No description provided for @contactNoString.
  ///
  /// In en, this message translates to:
  /// **'Contact No.'**
  String get contactNoString;

  /// No description provided for @destinationLocationString.
  ///
  /// In en, this message translates to:
  /// **'Destination Location'**
  String get destinationLocationString;

  /// No description provided for @pickImageString.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImageString;

  /// No description provided for @addMoreItemsString.
  ///
  /// In en, this message translates to:
  /// **'Add more Items'**
  String get addMoreItemsString;

  /// No description provided for @packagingTypeString.
  ///
  /// In en, this message translates to:
  /// **'Packaging Type'**
  String get packagingTypeString;

  /// No description provided for @quantityString.
  ///
  /// In en, this message translates to:
  /// **'Qty.'**
  String get quantityString;

  /// No description provided for @myRequestString.
  ///
  /// In en, this message translates to:
  /// **'My Request'**
  String get myRequestString;

  /// No description provided for @statusString.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusString;

  /// No description provided for @typeString.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeString;

  /// No description provided for @dateString.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateString;

  /// No description provided for @productNameString.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productNameString;

  /// No description provided for @productTypeString.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get productTypeString;

  /// No description provided for @selectReasonString.
  ///
  /// In en, this message translates to:
  /// **'Please Select Reason'**
  String get selectReasonString;

  /// No description provided for @acceptString.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptString;

  /// No description provided for @declineString.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineString;

  /// No description provided for @itemDetailsString.
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get itemDetailsString;

  /// No description provided for @itemImageString.
  ///
  /// In en, this message translates to:
  /// **'Item Image'**
  String get itemImageString;

  /// No description provided for @goString.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get goString;

  /// No description provided for @deductionMessageString.
  ///
  /// In en, this message translates to:
  /// **'will be deducted from your wallet.'**
  String get deductionMessageString;

  /// No description provided for @walletString.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletString;

  /// No description provided for @balanceString.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceString;

  /// No description provided for @rsString.
  ///
  /// In en, this message translates to:
  /// **'rs'**
  String get rsString;

  /// No description provided for @addAmountDescString.
  ///
  /// In en, this message translates to:
  /// **'Add an amount to your wallet to continue \n using the services.'**
  String get addAmountDescString;

  /// No description provided for @addAmountString.
  ///
  /// In en, this message translates to:
  /// **'Add Amount'**
  String get addAmountString;

  /// No description provided for @okString.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okString;

  /// No description provided for @reachedPickupLocationMsgString.
  ///
  /// In en, this message translates to:
  /// **'You’ve reached at the \n Pickup Location'**
  String get reachedPickupLocationMsgString;

  /// No description provided for @startTripString.
  ///
  /// In en, this message translates to:
  /// **'Start the Trip'**
  String get startTripString;

  /// No description provided for @reachedDropLocationMsgString.
  ///
  /// In en, this message translates to:
  /// **'You’ve reached at the\nDrop Location'**
  String get reachedDropLocationMsgString;

  /// No description provided for @orSignUpString.
  ///
  /// In en, this message translates to:
  /// **'or sign up with'**
  String get orSignUpString;

  /// No description provided for @uploadDocumentString.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocumentString;

  /// No description provided for @uploadString.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadString;

  /// No description provided for @uploadedString.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploadedString;

  /// No description provided for @updateString.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateString;

  /// No description provided for @notificationString.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationString;

  /// No description provided for @todayString.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayString;

  /// No description provided for @yesterdayString.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayString;

  /// No description provided for @noRequestString.
  ///
  /// In en, this message translates to:
  /// **'No Request!'**
  String get noRequestString;

  /// No description provided for @orderHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Only the last 2 years of order history are \n displayed. For previous records, feel free \n to connect with our support team.'**
  String get orderHistoryDesc;

  /// No description provided for @benefitString.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefitString;

  /// No description provided for @recentPickupString.
  ///
  /// In en, this message translates to:
  /// **'Recent Pickup Address'**
  String get recentPickupString;

  /// No description provided for @referFreindString.
  ///
  /// In en, this message translates to:
  /// **'Refer your friends!'**
  String get referFreindString;

  /// No description provided for @inviteString.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get inviteString;

  /// No description provided for @supportLegalString.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportLegalString;

  /// No description provided for @helpSupportString.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportString;

  /// No description provided for @termsConditionString.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditionString;

  /// No description provided for @settingString.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingString;

  /// No description provided for @chooseLanguageString.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguageString;

  /// No description provided for @logoutString.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutString;

  /// No description provided for @referEarnString.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referEarnString;

  /// No description provided for @ownerString.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerString;

  /// No description provided for @vehicleString.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleString;

  /// No description provided for @driverString.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driverString;

  /// No description provided for @photoString.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoString;

  /// No description provided for @ownerDetailsString.
  ///
  /// In en, this message translates to:
  /// **'Owner Details'**
  String get ownerDetailsString;

  /// No description provided for @uploadTheFollowingString.
  ///
  /// In en, this message translates to:
  /// **'Upload the following'**
  String get uploadTheFollowingString;

  /// No description provided for @ownerAdhaarCardString.
  ///
  /// In en, this message translates to:
  /// **'Owner Adhaar Card'**
  String get ownerAdhaarCardString;

  /// No description provided for @ownerPanCardString.
  ///
  /// In en, this message translates to:
  /// **'Owner Pan Card'**
  String get ownerPanCardString;

  /// No description provided for @vehicleRcString.
  ///
  /// In en, this message translates to:
  /// **'Vehicle RC'**
  String get vehicleRcString;

  /// No description provided for @uploadRcString.
  ///
  /// In en, this message translates to:
  /// **'Upload RC'**
  String get uploadRcString;

  /// No description provided for @vehicleTypeString.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleTypeString;

  /// No description provided for @vehiclePhotoString.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get vehiclePhotoString;

  /// No description provided for @phoneNumberString.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberString;

  /// No description provided for @licenceNumberString.
  ///
  /// In en, this message translates to:
  /// **'Licence Number'**
  String get licenceNumberString;

  /// No description provided for @driverAdhaarCardString.
  ///
  /// In en, this message translates to:
  /// **'Driver Adhaar Card'**
  String get driverAdhaarCardString;

  /// No description provided for @driverPanCardString.
  ///
  /// In en, this message translates to:
  /// **'Driver Pan Card'**
  String get driverPanCardString;

  /// No description provided for @driverPhotoString.
  ///
  /// In en, this message translates to:
  /// **'Driver Photo'**
  String get driverPhotoString;

  /// No description provided for @detailsString.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsString;

  /// No description provided for @frontSideString.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get frontSideString;

  /// No description provided for @backSide.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get backSide;

  /// No description provided for @validPhoneNumberString.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid phone number'**
  String get validPhoneNumberString;

  /// No description provided for @validEnterPhoneNumberString.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get validEnterPhoneNumberString;

  /// No description provided for @validNameString.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid name'**
  String get validNameString;

  /// No description provided for @valideEmailString.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get valideEmailString;

  /// No description provided for @registrationFailedString.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registrationFailedString;

  /// No description provided for @notADriverString.
  ///
  /// In en, this message translates to:
  /// **'Not a Driver'**
  String get notADriverString;

  /// No description provided for @pleaseUploadString.
  ///
  /// In en, this message translates to:
  /// **'Please upload'**
  String get pleaseUploadString;

  /// No description provided for @pleaseEnterString.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get pleaseEnterString;

  /// No description provided for @adhaarCardString.
  ///
  /// In en, this message translates to:
  /// **'adhaar card'**
  String get adhaarCardString;

  /// No description provided for @panCardString.
  ///
  /// In en, this message translates to:
  /// **'pan card'**
  String get panCardString;

  /// No description provided for @photoSmallString.
  ///
  /// In en, this message translates to:
  /// **'photo'**
  String get photoSmallString;

  /// No description provided for @rcString.
  ///
  /// In en, this message translates to:
  /// **'RC'**
  String get rcString;

  /// No description provided for @licenceString.
  ///
  /// In en, this message translates to:
  /// **'Licence'**
  String get licenceString;

  /// No description provided for @homeString.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeString;

  /// No description provided for @myTripsString.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTripsString;

  /// No description provided for @chatsString.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatsString;

  /// No description provided for @profileString.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileString;

  /// No description provided for @typeAMessageString.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeAMessageString;

  /// No description provided for @newRideString.
  ///
  /// In en, this message translates to:
  /// **'New Ride'**
  String get newRideString;

  /// No description provided for @offerRideString.
  ///
  /// In en, this message translates to:
  /// **'OFFER RIDE'**
  String get offerRideString;

  /// No description provided for @newString.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newString;

  /// No description provided for @retakeString.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakeString;

  /// No description provided for @hiString.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hiString;

  /// No description provided for @welecomeToString.
  ///
  /// In en, this message translates to:
  /// **'welcome to'**
  String get welecomeToString;

  /// No description provided for @fewStepsAwayString.
  ///
  /// In en, this message translates to:
  /// **'You are now a few steps away from getting your first trip'**
  String get fewStepsAwayString;

  /// No description provided for @etcString.
  ///
  /// In en, this message translates to:
  /// **'etc.'**
  String get etcString;

  /// No description provided for @verifiedString.
  ///
  /// In en, this message translates to:
  /// **'✔ Verified'**
  String get verifiedString;

  /// No description provided for @pendingString.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingString;

  /// No description provided for @verificationString.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationString;

  /// No description provided for @verificationInProcessString.
  ///
  /// In en, this message translates to:
  /// **'Verification is in process'**
  String get verificationInProcessString;

  /// No description provided for @validString.
  ///
  /// In en, this message translates to:
  /// **'valid'**
  String get validString;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
