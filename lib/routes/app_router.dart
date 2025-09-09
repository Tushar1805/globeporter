import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/location/eta_example_screen.dart';
import 'package:globeporter/presentation/authentication/view/login_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_1_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_2_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_3_screen.dart';
import 'package:globeporter/presentation/authentication/view/onboarding/onboarding_4_screen.dart';
import 'package:globeporter/presentation/authentication/view/otp_screen.dart';
import 'package:globeporter/presentation/authentication/view/select_lang_screen.dart';
import 'package:globeporter/presentation/authentication/view/sign_up_screen.dart';
import 'package:globeporter/presentation/chats/view/chat_screen.dart';
import 'package:globeporter/presentation/customer/view/create_request_screen.dart';
import 'package:globeporter/presentation/customer/view/customer_dashboard.dart';
import 'package:globeporter/presentation/customer/view/track_driver_screen.dart';
import 'package:globeporter/presentation/driver/view/accept_ride_notification_screen.dart';
import 'package:globeporter/presentation/settings/view/customer_profile_screen.dart';
// import 'package:globeporter/presentation/customer/model/customer_ride_response.dart' as customer;
import 'package:globeporter/presentation/customer/model/booking_details_response.dart' as booking;
import 'package:globeporter/presentation/customer/view/my_request_details_screen.dart';
import 'package:globeporter/presentation/customer/view/my_request_screen.dart';
import 'package:globeporter/presentation/customer/view/request_details_screen.dart';
import 'package:globeporter/presentation/driver/view/document_verification_screen.dart';
import 'package:globeporter/presentation/driver_ride_back/view/new_ride_screen.dart';
import 'package:globeporter/presentation/driver/widgets/document_upload_screen.dart';
import 'package:globeporter/presentation/driver/view/driver_dashboard.dart';
import 'package:globeporter/presentation/settings/view/driver_profile_screen.dart';
import 'package:globeporter/presentation/driver/view/item_details_screen.dart';
import 'package:globeporter/presentation/driver/view/owner_details_screen.dart';
import 'package:globeporter/presentation/driver/view/start_trip_screen.dart';
import 'package:globeporter/presentation/driver/view/trip_info_screen.dart';
import 'package:globeporter/presentation/driver/widgets/full_image_preview.dart';
import 'package:globeporter/presentation/driver/widgets/image_review_screen.dart';
import 'package:globeporter/presentation/driver/widgets/normal_upload_screen.dart';
import 'package:globeporter/presentation/settings/view/transaction_history_screen.dart';
import 'package:globeporter/presentation/settings/view/view_documents_screen.dart';
import 'package:globeporter/presentation/settings/view/wallet_screen.dart';
import 'package:globeporter/presentation/notification/view/notification_screen.dart';
import 'package:globeporter/presentation/settings/view/refer_screen.dart';
import 'package:globeporter/presentation/widgets/contact_picker_widget.dart';
import 'package:globeporter/routes/app_routes.dart';
import '../presentation/authentication/view/splash_screen.dart';
import 'error_screen.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> slideTransitionPage<T>({
  required Widget child,
  required LocalKey key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: splashScreen,
  errorBuilder: (context, state) => const ErrorScreen(),
  routes: [
    GoRoute(
      name: splashScreen,
      path: splashScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: SplashScreen(
            data: params?['route'] as RemoteMessage?,
          ),
        );
      },
    ),

    //* Background notification routing
    GoRoute(
      name: customerDashboard,
      path: customerDashboard,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: CustomerDashboard(
            type: params?['type'] as String?,
          ),
        );
      },
      routes: [
        GoRoute(
          name: "myRequestDetailsNotificationScreen",
          path: "myRequestDetailsNotificationScreen",
          pageBuilder: (final context, final state) {
            final params = state.extra as Map<String, dynamic>?;
            return slideTransitionPage(
              key: state.pageKey,
              child: MyRequestDetailsScreen(
                type: params?['type'] as String?,
                bookingId: params?['bookingId'] as String?,
              ),
            );
          },
        ),
        GoRoute(
          name: "chatNotificationScreen",
          path: "chatNotificationScreen",
          pageBuilder: (final context, final state) {
            final params = state.extra as Map<String, dynamic>?;
            return slideTransitionPage(
              key: state.pageKey,
              child: ChatScreen(
                senderId: params?['senderId'] as String,
                receiverId: params?['receiverId'] as String,
                type: params?['type'] as String,
                senderName: params?['senderName'] as String,
                receiverName: params?['receiverName'] as String,
                receiverImageUrl: params?['receiverImageUrl'] as String?,
              ),
            );
          },
        ),
        GoRoute(
          name: "trackDriverNotificationScreen",
          path: "trackDriverNotificationScreen",
          pageBuilder: (final context, final state) {
            final params = state.extra as Map<String, dynamic>?;
            return slideTransitionPage(
              key: state.pageKey,
              child: TrackDriverScreen(
                type: params?['type'] as String?,
                data: params?['data'] as booking.Data?,
              ),
            );
          },
        ),
      ],
    ),

    GoRoute(
        name: driverDashboard,
        path: driverDashboard,
        pageBuilder: (context, state) => slideTransitionPage(
              key: state.pageKey,
              child: const DriverDashboard(),
            ),
        routes: [
          GoRoute(
            name: "driverRideNotification2Screen",
            path: "driverRideNotification2Screen",
            pageBuilder: (final context, final state) {
              final params = state.extra as Map<String, dynamic>?;
              return slideTransitionPage(
                key: state.pageKey,
                child: DriverRideNotificationScreen(
                  bookingId: params?['bookingId'] as String,
                ),
              );
            },
          ),
        ]),
    GoRoute(
      name: setLanguageScreen,
      path: setLanguageScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: SelectLangScreen(
            onPop: params?['onPop'] as bool?,
          ),
        );
      },
    ),
    GoRoute(
      name: onboardingScreen1,
      path: onboardingScreen1,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen1(),
      ),
    ),
    GoRoute(
      name: onboardingScreen2,
      path: onboardingScreen2,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen2(),
      ),
    ),
    GoRoute(
      name: onboardingScreen3,
      path: onboardingScreen3,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen3(),
      ),
    ),
    GoRoute(
      name: onboardingScreen4,
      path: onboardingScreen4,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen4(),
      ),
    ),
    GoRoute(
      name: loginScreen,
      path: loginScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: LoginScreen(
            status: params?['status'] as int?,
          ),
        );
      },
    ),
    GoRoute(
      name: signUpScreen,
      path: signUpScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: SignUpScreen(
            countryCode: params?['countryCode'] as String,
            phoneNumber: params?['phoneNumber'] as String,
            userId: params?['userId'] as int,
            otp: params?['otp'] as int?,
          ),
        );
      },
    ),
    GoRoute(
      name: otpScreen,
      path: otpScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: OtpScreen(
            countryCode: params?['countryCode'] as String,
            email: params?['email'] as String,
            phone: params?['phone'] as String,
            name: params?['name'] as String,
            userId: params?['userId'] as int,
            otp: params?['otp'] as int?,
          ),
        );
      },
    ),
    GoRoute(
      name: createRequestScreen,
      path: createRequestScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const CreateRequestScreen(),
      ),
    ),
    GoRoute(
      name: requestDetailsScreen,
      path: requestDetailsScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: RequestDetailsScreen(
            type: params?['type'] as String?,
            onSubmitTap: params?['onSubmitTap'] as VoidCallback?,
          ),
        );
      },
    ),
    GoRoute(
      name: myRequestScreen,
      path: myRequestScreen,
      pageBuilder: (final context, final state) {
        return slideTransitionPage(
          key: state.pageKey,
          child: MyRequestScreen(),
        );
      },
    ),
    GoRoute(
      name: myRequestDetailsScreen,
      path: myRequestDetailsScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;

        // 1. Try getting from existing extra
        String? bookingId = params?['bookingId'] as String?;
        String? type = params?['type'] as String?;

        // 2. If null, fallback to query parameters (for deep links)
        bookingId ??= state.uri.queryParameters['bookingId'];
        type ??= state.uri.queryParameters['type'];

        return slideTransitionPage(
          key: state.pageKey,
          child: MyRequestDetailsScreen(
            type: type?.toLowerCase(),
            bookingId: bookingId,
          ),
        );
      },
    ),
    GoRoute(
      name: trackDriverScreen,
      path: trackDriverScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: TrackDriverScreen(
            type: params?['type'] as String?,
            data: params?['data'] as booking.Data?,
          ),
        );
      },
    ),
    GoRoute(
      name: itemDetailsScreen,
      path: itemDetailsScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: ItemDetailsScreen(
            type: params?['type'] as String?,
            bookingId: params?['bookingId'] as String,
          ),
        );
      },
    ),
    GoRoute(
      name: tripInfoScreen,
      path: tripInfoScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: TripInfoScreen(
            type: params?['type'] as String?,
            data: params?['data'] as booking.Data,
          ),
        );
      },
    ),
    GoRoute(
      name: startTripScreen,
      path: startTripScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: StartTripScreen(
            type: params?['type'] as String?,
            data: params?['data'] as booking.Data,
          ),
        );
      },
    ),
    GoRoute(
      name: walletScreen,
      path: walletScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const WalletScreen(),
      ),
    ),
    GoRoute(
      name: notificationScreen,
      path: notificationScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const NotificationScreen(),
      ),
    ),
    GoRoute(
      name: customerProfileScreen,
      path: customerProfileScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const CustomerProfileScreen(),
      ),
    ),
    GoRoute(
      name: driverProfileScreen,
      path: driverProfileScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const DriverProfileScreen(),
      ),
    ),
    GoRoute(
      name: referAndEarnScreen,
      path: referAndEarnScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const ReferAndEarnScreen(),
      ),
    ),
    GoRoute(
      name: ownerDetailsScreen,
      path: ownerDetailsScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: OwnerDetailsScreen(
            currentScreenIndex: params?['currentIndex'] as int?,
          ),
        );
      },
    ),
    GoRoute(
      name: uploadDocumentScreen,
      path: uploadDocumentScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        // Ensure function is present
        final void Function(File?, bool?) onCaptured =
            (params?['onImageCaptured'] as void Function(File?, bool?));
        return slideTransitionPage(
          key: state.pageKey,
          child: DocumentCameraScreen(
            title: params?['title'] as String,
            hintText: params?['hintText'] as String,
            imageList: params?['imageList'] as List<File?>,
            onImageCaptured: onCaptured,
            type: params?['type'] as String,
            front: params?['front'] as bool?,
          ),
        );
      },
    ),
    GoRoute(
      name: normalUploadScreen,
      path: normalUploadScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        // Ensure function is present
        final void Function(File?) onCaptured =
            (params?['onImageCaptured'] as void Function(File?));
        return slideTransitionPage(
          key: state.pageKey,
          child: SelfieCameraScreen(
            title: params?['title'] as String,
            image: params?['image'] as File?,
            onImageCaptured: onCaptured,
          ),
        );
      },
    ),
    GoRoute(
      name: fullImagePreviewScreen,
      path: fullImagePreviewScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: FullImagePreviewScreen(
            imageFile: params?['imageFile'] as File,
          ),
        );
      },
    ),
    GoRoute(
      name: imageReviewScreen,
      path: imageReviewScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        // Ensure function is present
        final void Function(File?, bool?) onCaptured =
            (params?['onSubmit'] as void Function(File?, bool?));
        return slideTransitionPage(
          key: state.pageKey,
          child: ImageReviewScreen(
            imageFile: params?['imageFile'] as File,
            title: params?['title'] as String,
            isFront: params?['isFront'] as bool,
            onSubmit: onCaptured,
          ),
        );
      },
    ),
    GoRoute(
      name: chatScreen,
      path: chatScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: ChatScreen(
            senderId: params?['senderId'] as String,
            receiverId: params?['receiverId'] as String,
            type: params?['type'] as String,
            senderName: params?['senderName'] as String,
            receiverName: params?['receiverName'] as String,
            receiverImageUrl: params?['receiverImageUrl'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      name: newRideScreen,
      path: newRideScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const NewRideScreen(),
      ),
    ),
    GoRoute(
      name: documentVerificationScreen,
      path: documentVerificationScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: DocumentVerificationScreen(),
      ),
    ),
    GoRoute(
      name: viewDocumentsScreen,
      path: viewDocumentsScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: ViewUploadedDocuments(),
      ),
    ),
    GoRoute(
      name: contactPickerScreen,
      path: contactPickerScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const ContactPickerScreen(),
      ),
    ),
    GoRoute(
      name: transactionHistoryScreen,
      path: transactionHistoryScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const TransactionHistoryScreen(),
      ),
    ),
    GoRoute(
      name: driverRideNotificationScreen,
      path: driverRideNotificationScreen,
      pageBuilder: (final context, final state) {
        final params = state.extra as Map<String, dynamic>?;
        return slideTransitionPage(
          key: state.pageKey,
          child: DriverRideNotificationScreen(
            bookingId: params?['bookingId'] as String,
          ),
        );
      },
    ),
    GoRoute(
      name: etaExampleScreen,
      path: etaExampleScreen,
      pageBuilder: (context, state) => slideTransitionPage(
        key: state.pageKey,
        child: const EtaSimulatorWidget(),
      ),
    ),
  ],
);
