import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HOPE Rehabilitation'**
  String get appTitle;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'HOPE'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart Rehab System'**
  String get appTagline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @chooseYourRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get chooseYourRole;

  /// No description provided for @roleIntro.
  ///
  /// In en, this message translates to:
  /// **'Start your journey in physical therapy.\nChoose your role.'**
  String get roleIntro;

  /// No description provided for @rolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get rolePatient;

  /// No description provided for @rolePatientDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a new rehabilitation session'**
  String get rolePatientDesc;

  /// No description provided for @roleDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get roleDoctor;

  /// No description provided for @roleDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'View session history and results'**
  String get roleDoctorDesc;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @readyToBegin.
  ///
  /// In en, this message translates to:
  /// **'Ready to Begin?'**
  String get readyToBegin;

  /// No description provided for @sessionIntro.
  ///
  /// In en, this message translates to:
  /// **'We will guide you through assessment and exercise with your HOPE glove.'**
  String get sessionIntro;

  /// No description provided for @startNewSession.
  ///
  /// In en, this message translates to:
  /// **'Start New Session'**
  String get startNewSession;

  /// No description provided for @linkGloveDevice.
  ///
  /// In en, this message translates to:
  /// **'Link Glove Device'**
  String get linkGloveDevice;

  /// No description provided for @linkGloveToSession.
  ///
  /// In en, this message translates to:
  /// **'Link Glove to Session'**
  String get linkGloveToSession;

  /// No description provided for @linkGloveDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the device ID printed on your glove. The glove sends data over WiFi — no pairing needed.'**
  String get linkGloveDesc;

  /// No description provided for @deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// No description provided for @linkDevice.
  ///
  /// In en, this message translates to:
  /// **'Link Device'**
  String get linkDevice;

  /// No description provided for @assessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get assessment;

  /// No description provided for @waitingForAssessment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Assessment'**
  String get waitingForAssessment;

  /// No description provided for @assessmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Put on the glove and perform the assessment motions. The glove sends sensor data over WiFi and the server will process your results automatically.'**
  String get assessmentDesc;

  /// No description provided for @noGloveSimulate.
  ///
  /// In en, this message translates to:
  /// **'No glove? Simulate it:'**
  String get noGloveSimulate;

  /// No description provided for @simulateGloveAssessment.
  ///
  /// In en, this message translates to:
  /// **'Simulate Glove (Assessment)'**
  String get simulateGloveAssessment;

  /// No description provided for @simulateGloveExercise.
  ///
  /// In en, this message translates to:
  /// **'Simulate Glove (Exercise)'**
  String get simulateGloveExercise;

  /// No description provided for @assessmentResults.
  ///
  /// In en, this message translates to:
  /// **'Assessment Results'**
  String get assessmentResults;

  /// No description provided for @functionsPassed.
  ///
  /// In en, this message translates to:
  /// **'{passed}/{total} functions passed'**
  String functionsPassed(int passed, int total);

  /// No description provided for @continueToCheckin.
  ///
  /// In en, this message translates to:
  /// **'Continue to Check-in'**
  String get continueToCheckin;

  /// No description provided for @dailyCheckin.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get dailyCheckin;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @qSleep.
  ///
  /// In en, this message translates to:
  /// **'How many hours did you sleep?'**
  String get qSleep;

  /// No description provided for @qTemperature.
  ///
  /// In en, this message translates to:
  /// **'What is your body temperature?'**
  String get qTemperature;

  /// No description provided for @qBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'What is your blood sugar level?'**
  String get qBloodSugar;

  /// No description provided for @qBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'What is your blood pressure?'**
  String get qBloodPressure;

  /// No description provided for @qHeadache.
  ///
  /// In en, this message translates to:
  /// **'Do you have a headache?'**
  String get qHeadache;

  /// No description provided for @qDizzy.
  ///
  /// In en, this message translates to:
  /// **'Do you feel dizzy?'**
  String get qDizzy;

  /// No description provided for @qFatigue.
  ///
  /// In en, this message translates to:
  /// **'Do you feel fatigued or unusually tired?'**
  String get qFatigue;

  /// No description provided for @qArmPain.
  ///
  /// In en, this message translates to:
  /// **'Do you have any pain in your affected arm or hand?'**
  String get qArmPain;

  /// No description provided for @qHandMovement.
  ///
  /// In en, this message translates to:
  /// **'Are you able to move your hand today as usual?'**
  String get qHandMovement;

  /// No description provided for @qFalls.
  ///
  /// In en, this message translates to:
  /// **'Have you experienced any falls or injuries since your last session?'**
  String get qFalls;

  /// No description provided for @hoursUnit.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hoursUnit;

  /// No description provided for @celsiusUnit.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get celsiusUnit;

  /// No description provided for @mgdlUnit.
  ///
  /// In en, this message translates to:
  /// **'mg/dL'**
  String get mgdlUnit;

  /// No description provided for @systolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get systolic;

  /// No description provided for @diastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get diastolic;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @exerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise: {name}'**
  String exerciseLabel(String name);

  /// No description provided for @exerciseDesc.
  ///
  /// In en, this message translates to:
  /// **'Perform the exercise while wearing the glove. When you\'re done, tap the \"Done\" button below.'**
  String get exerciseDesc;

  /// No description provided for @waitingForExercise.
  ///
  /// In en, this message translates to:
  /// **'Waiting for exercise data...'**
  String get waitingForExercise;

  /// No description provided for @doneFetchResults.
  ///
  /// In en, this message translates to:
  /// **'Done — Fetch Results'**
  String get doneFetchResults;

  /// No description provided for @exerciseResults.
  ///
  /// In en, this message translates to:
  /// **'Exercise Results'**
  String get exerciseResults;

  /// No description provided for @featureScores.
  ///
  /// In en, this message translates to:
  /// **'Feature Scores'**
  String get featureScores;

  /// No description provided for @finishSession.
  ///
  /// In en, this message translates to:
  /// **'Finish Session'**
  String get finishSession;

  /// No description provided for @overallPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% overall'**
  String overallPercent(String percent);

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistory;

  /// No description provided for @noSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get noSessionsFound;

  /// No description provided for @assessSummary.
  ///
  /// In en, this message translates to:
  /// **'{passed}/{total} PASS'**
  String assessSummary(int passed, int total);

  /// No description provided for @noAssessment.
  ///
  /// In en, this message translates to:
  /// **'No assessment'**
  String get noAssessment;

  /// No description provided for @exerciseSummary.
  ///
  /// In en, this message translates to:
  /// **'Exercise: {percent}%'**
  String exerciseSummary(String percent);

  /// No description provided for @sessionDetail.
  ///
  /// In en, this message translates to:
  /// **'Session Detail'**
  String get sessionDetail;

  /// No description provided for @failedToLoadSession.
  ///
  /// In en, this message translates to:
  /// **'Failed to load session'**
  String get failedToLoadSession;

  /// No description provided for @tabAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get tabAssessment;

  /// No description provided for @tabExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get tabExercise;

  /// No description provided for @tabInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabInfo;

  /// No description provided for @noAssessmentData.
  ///
  /// In en, this message translates to:
  /// **'No assessment data'**
  String get noAssessmentData;

  /// No description provided for @noExerciseData.
  ///
  /// In en, this message translates to:
  /// **'No exercise data'**
  String get noExerciseData;

  /// No description provided for @questionnaire.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get questionnaire;

  /// No description provided for @sessionVideo.
  ///
  /// In en, this message translates to:
  /// **'Session Video'**
  String get sessionVideo;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'PASS'**
  String get pass;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'FAIL'**
  String get fail;

  /// No description provided for @statusCreated.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get statusCreated;

  /// No description provided for @statusQuestionnaireDone.
  ///
  /// In en, this message translates to:
  /// **'questionnaire done'**
  String get statusQuestionnaireDone;

  /// No description provided for @statusAssessed.
  ///
  /// In en, this message translates to:
  /// **'assessed'**
  String get statusAssessed;

  /// No description provided for @statusExercised.
  ///
  /// In en, this message translates to:
  /// **'exercised'**
  String get statusExercised;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get statusCompleted;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get statusInProgress;

  /// No description provided for @statusAccumulatingAssessment.
  ///
  /// In en, this message translates to:
  /// **'collecting assessment data...'**
  String get statusAccumulatingAssessment;

  /// No description provided for @statusAccumulatingExercise.
  ///
  /// In en, this message translates to:
  /// **'collecting exercise data...'**
  String get statusAccumulatingExercise;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get statusUnknown;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dashboardWelcomePatient.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Ali'**
  String get dashboardWelcomePatient;

  /// No description provided for @dashboardWelcomeDoctor.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Dr. Kenzy'**
  String get dashboardWelcomeDoctor;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise scores over time'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercise data yet — finish a session to see your progress here.'**
  String get dashboardEmpty;

  /// No description provided for @dashboardEmptyForCategory.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get dashboardEmptyForCategory;

  /// No description provided for @dashboardSession.
  ///
  /// In en, this message translates to:
  /// **'Session {n}'**
  String dashboardSession(int n);

  /// No description provided for @nextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next Exercise'**
  String get nextExercise;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} of {total}: {name}'**
  String exerciseProgress(int current, int total, String name);

  /// No description provided for @redoAssessment.
  ///
  /// In en, this message translates to:
  /// **'Redo Assessment'**
  String get redoAssessment;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @deleteSessionConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get deleteSessionConfirmTitle;

  /// No description provided for @deleteSessionConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove the session, its sensor data, and any uploaded video. This cannot be undone.'**
  String get deleteSessionConfirmBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deletedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Session deleted'**
  String get deletedConfirm;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have internet. Check your connection and try again.'**
  String get noInternet;

  /// No description provided for @recordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record Video'**
  String get recordVideo;

  /// No description provided for @recordVideoOfYourself.
  ///
  /// In en, this message translates to:
  /// **'Record video of yourself'**
  String get recordVideoOfYourself;

  /// No description provided for @reRecord.
  ///
  /// In en, this message translates to:
  /// **'Re-record'**
  String get reRecord;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap the red button to start recording'**
  String get tapToStart;

  /// No description provided for @videoRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording…'**
  String get videoRecording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopRecording;

  /// No description provided for @uploadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Uploading video…'**
  String get uploadingVideo;

  /// No description provided for @videoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Video uploaded'**
  String get videoUploaded;

  /// No description provided for @videoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Video upload failed'**
  String get videoUploadFailed;

  /// No description provided for @videoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video unavailable'**
  String get videoUnavailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cameraNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Camera not available'**
  String get cameraNotAvailable;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @labelSleepHours.
  ///
  /// In en, this message translates to:
  /// **'Sleep (hours)'**
  String get labelSleepHours;

  /// No description provided for @labelBodyTemperature.
  ///
  /// In en, this message translates to:
  /// **'Body temperature (°C)'**
  String get labelBodyTemperature;

  /// No description provided for @labelBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar (mg/dL)'**
  String get labelBloodSugar;

  /// No description provided for @labelBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get labelBloodPressure;

  /// No description provided for @labelHeadache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get labelHeadache;

  /// No description provided for @labelDizzy.
  ///
  /// In en, this message translates to:
  /// **'Dizziness'**
  String get labelDizzy;

  /// No description provided for @labelFatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get labelFatigue;

  /// No description provided for @labelArmPain.
  ///
  /// In en, this message translates to:
  /// **'Arm/hand pain'**
  String get labelArmPain;

  /// No description provided for @labelHandMovement.
  ///
  /// In en, this message translates to:
  /// **'Hand movement OK'**
  String get labelHandMovement;

  /// No description provided for @labelFallsInjuries.
  ///
  /// In en, this message translates to:
  /// **'Falls/injuries since last session'**
  String get labelFallsInjuries;

  /// No description provided for @questionnaireSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get questionnaireSkipped;

  /// No description provided for @questionnaireNotFilled.
  ///
  /// In en, this message translates to:
  /// **'Not filled'**
  String get questionnaireNotFilled;

  /// No description provided for @languageToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get languageToggleTooltip;

  /// No description provided for @welcomeSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Ali 👋'**
  String get welcomeSnackbar;

  /// No description provided for @patientSessions.
  ///
  /// In en, this message translates to:
  /// **'Ali\'s Sessions'**
  String get patientSessions;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @tabHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get tabHelp;

  /// No description provided for @tabSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get tabSessions;

  /// No description provided for @tabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tabDashboard;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpTitle;

  /// No description provided for @helpWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to HOPE'**
  String get helpWelcome;

  /// No description provided for @helpWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Your smart rehabilitation assistant. Follow the steps, complete the tasks, and track your progress easily.'**
  String get helpWelcomeDesc;

  /// No description provided for @helpHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get helpHowToUse;

  /// No description provided for @helpExercisesGuide.
  ///
  /// In en, this message translates to:
  /// **'Exercises Guide'**
  String get helpExercisesGuide;

  /// No description provided for @helpReach.
  ///
  /// In en, this message translates to:
  /// **'Reach'**
  String get helpReach;

  /// No description provided for @helpReachDesc.
  ///
  /// In en, this message translates to:
  /// **'Move your hand toward the target object smoothly.'**
  String get helpReachDesc;

  /// No description provided for @helpReachTip.
  ///
  /// In en, this message translates to:
  /// **'Try to keep your movement straight and controlled'**
  String get helpReachTip;

  /// No description provided for @helpGrasp.
  ///
  /// In en, this message translates to:
  /// **'Grasp'**
  String get helpGrasp;

  /// No description provided for @helpGraspDesc.
  ///
  /// In en, this message translates to:
  /// **'Close your fingers to hold the object. Apply enough force to hold it firmly.'**
  String get helpGraspDesc;

  /// No description provided for @helpGraspTip.
  ///
  /// In en, this message translates to:
  /// **'Apply enough force to hold it firmly'**
  String get helpGraspTip;

  /// No description provided for @helpManipulation.
  ///
  /// In en, this message translates to:
  /// **'Manipulation'**
  String get helpManipulation;

  /// No description provided for @helpManipulationDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust or move the object inside your hand.'**
  String get helpManipulationDesc;

  /// No description provided for @helpManipulationTip.
  ///
  /// In en, this message translates to:
  /// **'Focus on control, not speed'**
  String get helpManipulationTip;

  /// No description provided for @helpRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get helpRelease;

  /// No description provided for @helpReleaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Open your hand to let go of the object.'**
  String get helpReleaseDesc;

  /// No description provided for @helpReleaseTip.
  ///
  /// In en, this message translates to:
  /// **'Release slowly and gently'**
  String get helpReleaseTip;

  /// No description provided for @helpResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding Your Results'**
  String get helpResultsTitle;

  /// No description provided for @helpResultSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get helpResultSuccess;

  /// No description provided for @helpResultSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'You performed the movement correctly'**
  String get helpResultSuccessDesc;

  /// No description provided for @helpResultTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get helpResultTryAgain;

  /// No description provided for @helpResultTryAgainDesc.
  ///
  /// In en, this message translates to:
  /// **'The movement needs improvement'**
  String get helpResultTryAgainDesc;

  /// No description provided for @helpResultLowForce.
  ///
  /// In en, this message translates to:
  /// **'Low Force'**
  String get helpResultLowForce;

  /// No description provided for @helpResultLowForceDesc.
  ///
  /// In en, this message translates to:
  /// **'Try to grip stronger'**
  String get helpResultLowForceDesc;

  /// No description provided for @helpResultSpeed.
  ///
  /// In en, this message translates to:
  /// **'Too Slow / Too Fast'**
  String get helpResultSpeed;

  /// No description provided for @helpResultSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Aim for smooth and controlled motion'**
  String get helpResultSpeedDesc;

  /// No description provided for @helpElectrodePlacement.
  ///
  /// In en, this message translates to:
  /// **'Electrode Placement'**
  String get helpElectrodePlacement;

  /// No description provided for @helpTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get helpTroubleshooting;

  /// No description provided for @helpTroubleNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Glove not responding?'**
  String get helpTroubleNoResponse;

  /// No description provided for @helpTroubleNoResponseFix.
  ///
  /// In en, this message translates to:
  /// **'Check connection and restart the system'**
  String get helpTroubleNoResponseFix;

  /// No description provided for @helpTroubleNoData.
  ///
  /// In en, this message translates to:
  /// **'No data showing?'**
  String get helpTroubleNoData;

  /// No description provided for @helpTroubleNoDataFix.
  ///
  /// In en, this message translates to:
  /// **'Make sure the glove is worn correctly'**
  String get helpTroubleNoDataFix;

  /// No description provided for @helpTroubleStrange.
  ///
  /// In en, this message translates to:
  /// **'Strange readings?'**
  String get helpTroubleStrange;

  /// No description provided for @helpTroubleStrangeFix.
  ///
  /// In en, this message translates to:
  /// **'Adjust the glove and try again'**
  String get helpTroubleStrangeFix;

  /// No description provided for @helpSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get helpSafetyTitle;

  /// No description provided for @helpSafety1.
  ///
  /// In en, this message translates to:
  /// **'Stop if you feel pain'**
  String get helpSafety1;

  /// No description provided for @helpSafety2.
  ///
  /// In en, this message translates to:
  /// **'Do not force your movement'**
  String get helpSafety2;

  /// No description provided for @helpSafety3.
  ///
  /// In en, this message translates to:
  /// **'Follow your therapist\'s instructions'**
  String get helpSafety3;

  /// No description provided for @helpSafety4.
  ///
  /// In en, this message translates to:
  /// **'Take breaks when needed'**
  String get helpSafety4;

  /// No description provided for @helpAbout.
  ///
  /// In en, this message translates to:
  /// **'About HOPE'**
  String get helpAbout;

  /// No description provided for @helpAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'HOPE is a smart rehabilitation system designed to help you improve hand movement through guided exercises and real-time feedback.'**
  String get helpAboutDesc;

  /// No description provided for @helpTip.
  ///
  /// In en, this message translates to:
  /// **'Consistency is key! Practice regularly and track your improvement over time.'**
  String get helpTip;

  /// No description provided for @accumulationProgress.
  ///
  /// In en, this message translates to:
  /// **'Collecting sensor data...'**
  String get accumulationProgress;

  /// No description provided for @accumulationTimeRemaining.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds} remaining'**
  String accumulationTimeRemaining(String minutes, String seconds);

  /// No description provided for @batchesReceived.
  ///
  /// In en, this message translates to:
  /// **'Batches received: {count}'**
  String batchesReceived(int count);

  /// No description provided for @deviceDisconnectedWarning.
  ///
  /// In en, this message translates to:
  /// **'Device may be disconnected — no data received recently. Check the glove connection.'**
  String get deviceDisconnectedWarning;

  /// No description provided for @waitingForDevice.
  ///
  /// In en, this message translates to:
  /// **'Waiting for glove data...'**
  String get waitingForDevice;

  /// No description provided for @dataCollectionComplete.
  ///
  /// In en, this message translates to:
  /// **'Data collection complete, processing...'**
  String get dataCollectionComplete;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
