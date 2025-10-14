import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/screens/forgot_password_screen.dart';
import 'package:lawyer_consultant_for_lawyers/src/screens/payment_detail_screen.dart';
import 'package:lawyer_consultant_for_lawyers/src/screens/subscription_pricing_plan_screen.dart';

import 'screens/about_us_screen.dart';
import 'screens/agora_call/join_channel_audio.dart';
import 'screens/agora_call/join_channel_video.dart';
import 'screens/appointment_detail_screen.dart';
import 'screens/appointment_history_screen.dart';
import 'screens/blog_detail_screen.dart';
import 'screens/blogs_screen.dart';
import 'screens/booked_service_detail_screen.dart';
import 'screens/booked_services_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/invitations_screen.dart';
import 'screens/languages_screen.dart';
import 'screens/live_chat_screen.dart';
import 'screens/live_service_chat_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/schedule_app_slots_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/lawyer_profile_screen.dart';
import 'screens/wallet_screen.dart';
import 'widgets/bottom_navigation_widget.dart';

appRoutes() => [
      GetPage(name: '/splashscreen', page: () => const SplashScreen()),
      GetPage(name: '/introscreen', page: () => const IntroScreen()),
      GetPage(name: '/homescreen', page: () => BottomNavigationWidget()),
      GetPage(name: '/lawyerprofilescreen', page: () => LawyerProfileScreen()),
      // GetPage(
      //     name: '/notificationsscreen',
      //     page: () =>  NotificationsScreen()),
      GetPage(
          name: '/invitationsscreen', page: () => const InvitationsScreen()),
      GetPage(name: '/userprofilescreen', page: () => LawyerProfileScreen()),
      GetPage(name: '/contactusscreen', page: () => const ContactUsScreen()),
      GetPage(name: '/aboutusscreen', page: () => AboutUsScreen()),
      GetPage(
          name: '/appointmenthistoryscreen',
          page: () => const AppointmentHistoryScreen()),
      GetPage(
          name: '/appointmenthistorydetailscreen',
          page: () => const AppointmentDetailScreen()),
      GetPage(
          name: '/bookedservicesscreen', page: () => BookedServicesScreen()),
      GetPage(
          name: '/bookedservicedetailscreen',
          page: () => const BookedServiceDetailScreen()),
      GetPage(name: '/walletscreen', page: () => const WalletScreen()),
      GetPage(
          name: '/pricingplanscreen',
          page: () => SubscriptionPricingPlanScreen()),
      GetPage(name: '/paymentdetailscreen', page: () => PaymentDetailScreen()),
      GetPage(name: '/blogsscreen', page: () => const BlogsScreen()),
      GetPage(name: '/blogdetailscreen', page: () => BlogDetailScreen()),

      // GetPage(name: '/eventsscreen', page: () =>  EventsScreen()),
      // GetPage(name: '/eventdetailscreen', page: () => EventDetailScreen()),
      GetPage(name: '/signinscreen', page: () => SigninScreen()),
      GetPage(name: '/signupscreen', page: () => SignupScreen()),
      GetPage(name: '/scheduleappslots', page: () => ScheduleAppSlotsScreen()),
      GetPage(name: '/videocallscreen', page: () => JoinChannelVideo()),
      GetPage(name: '/audiocallscreen', page: () => const JoinChannelAudio()),
      GetPage(name: '/livechatscreen', page: () => LiveChatScreen()),
      GetPage(
          name: '/liveservicechatscreen', page: () => LiveServiceChatScreen()),
      GetPage(
          name: '/forgotpasswordscreen', page: () => ForgotPasswordScreen()),
      GetPage(
          name: '/privacypolicyscreen',
          page: () => const PrivacyPolicyScreen()),
      GetPage(name: '/languagesscreen', page: () => const LanguagesScreen()),
    ];

class PageRoutes {
  static String splashScreen = '/splashscreen';
  static String introScreen = '/introscreen';
  static String homeScreen = '/homescreen';
  static String lawyerProfileScreen = '/lawyerprofilescreen';
  static String notificationsScreen = '/notificationsscreen';
  static String invitationsScreen = '/invitationsscreen';
  static String userProfileScreen = '/userprofilescreen';
  static String contactusScreen = '/contactusscreen';
  static String aboutusScreen = '/aboutusscreen';
  static String appointmentHistoryScreen = '/appointmenthistoryscreen';
  static String appointmentHistoryDetailScreen =
      '/appointmenthistorydetailscreen';
  static String bookedServicesScreen = '/bookedservicesscreen';
  static String bookedServiceDetailScreen = '/bookedservicedetailscreen';
  static String walletScreen = '/walletscreen';
  static String pricingPlanScreen = '/pricingplanscreen';
  static String paymentDetailScreen = '/paymentdetailscreen';
  static String blogsScreen = '/blogsscreen';
  static String blogDetailScreen = '/blogdetailscreen';
  static String eventsScreen = '/eventsscreen';
  static String eventDetailScreen = '/eventdetailscreen';
  static String signinScreen = '/signinscreen';
  static String signupScreen = '/signupscreen';
  static String videoCallScreen = '/videocallscreen';
  static String audioCallScreen = '/audiocallscreen';
  static String scheduleAppSlots = '/scheduleappslots';
  static String liveChatScreen = '/livechatscreen';
  static String liveServiceChatScreen = '/liveservicechatscreen';
  static String forgotPasswordScreen = '/forgotpasswordscreen';
  static String privacyPolicyScreen = '/privacypolicyscreen';
  static String languagesScreen = '/languagesscreen';

  Map<String, WidgetBuilder> appRoutes() {
    return {
      splashScreen: (context) => const SplashScreen(),
      introScreen: (context) => const IntroScreen(),
      homeScreen: (context) => BottomNavigationWidget(),
      lawyerProfileScreen: (context) => LawyerProfileScreen(),
      // notificationsScreen: (context) =>  NotificationsScreen(),
      invitationsScreen: (context) => const InvitationsScreen(),
      userProfileScreen: (context) => LawyerProfileScreen(),
      contactusScreen: (context) => const ContactUsScreen(),
      aboutusScreen: (context) => AboutUsScreen(),
      appointmentHistoryScreen: (context) => const AppointmentHistoryScreen(),
      appointmentHistoryDetailScreen: (context) =>
          const AppointmentDetailScreen(),
      bookedServicesScreen: (context) => BookedServicesScreen(),
      bookedServiceDetailScreen: (context) => const BookedServiceDetailScreen(),
      walletScreen: (context) => const WalletScreen(),
      pricingPlanScreen: (context) => SubscriptionPricingPlanScreen(),
      paymentDetailScreen: (context) => PaymentDetailScreen(),
      blogsScreen: (context) => const BlogsScreen(),
      blogDetailScreen: (context) => BlogDetailScreen(),
      // eventsScreen: (context) =>  EventsScreen(),
      // eventDetailScreen: (context) => EventDetailScreen(),
      signinScreen: (context) => SigninScreen(),
      signupScreen: (context) => SignupScreen(),
      scheduleAppSlots: (context) => ScheduleAppSlotsScreen(),
      videoCallScreen: (context) => JoinChannelVideo(),
      audioCallScreen: (context) => const JoinChannelAudio(),
      liveChatScreen: (context) => LiveChatScreen(),
      liveServiceChatScreen: (context) => LiveServiceChatScreen(),
      forgotPasswordScreen: (context) => ForgotPasswordScreen(),
      privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),
      languagesScreen: (context) => const LanguagesScreen(),
    };
  }
}
