import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharityApp {
  // App Information
  static const String appName = 'charité';
  static final String authtype = 'auth_type';
  // Firestore
  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Firestore firestore = Firestore.instance;
  static String store = 'store';
  // Firebase Collection name
  static String collectionO = "orders";
  static String collectionUser = "users";
  static String collectionagents = "agents";
  static String collectionOrders = "orders"; // subCollection
  static String collectionDonations = "donations"; // subCollection

  static String collectionAllItems = "items";
  static String userCartList = 'userCart';
  static String userOrderList = 'userOrder';
  static String subCollectionAddress = 'userAddress';
  static String userItem = 'useritems';
  static String userItem2 = 'useritems2';
  static String isSubscribe = 'is_subscribe';
  //Strings
  static String signInText = "Sign in using Phone Number";
  static String signIn = "Sign In";
  static String next = "Next";
  static String tapButton =
      "Tap Next to verify your account with phone number. "
      "You don`t need to enter verification code manually if number is installed in your phone";
  static String enterPhoneNumber = "Enter your phone number";
  static String sendSMS =
      "We will send an SMS message to verify your phone number.";
  static String enterName = "Enter your name";
  static String done = "Done";

  // User Detail
  static final String userName = 'name';
  static final String userWallet = 'wallet';
  static final String userissubscribed = 'is_subscribed';
  static final String userPhone = 'phonenumber';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';
  static final String userJoinedTeams = 'joinedTeams';
  static final String usermethos = 'signin_method';

  // BOOKs field

  // Order fields
  static final String addressID = 'donationID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
}
