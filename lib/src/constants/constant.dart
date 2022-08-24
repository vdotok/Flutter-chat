import 'package:flutter/material.dart';

//Phone Size//
Size? size;

//**COLORS**/

//Primary Colors for this application//
const backgroundGradientColor = Color(0xFFEEDF4C);
const backgroundGradientColor2 = Color(0xFFF9EE8B);
const chatRoomBackgroundColor = Color(0xFFFFFFFF);
const greycolor = Color(0xFFFAFAFB);
const darkIndigoColor = Color(0xFF8C81AA);
const lightgreycolor = Color(0xFFFFE0EBE9);
const greenColor = Color(0xFF54C295);
const darkGreyColor = Color(0xFF8C81AA);
const tileGreenColor = Color(0xFFC1D7D3);
const focusedBorderColor = Color(0xFFD1E1DE);
const backgroundChatColor = Color(0xFFF9F9FA);

//Login SignUp color//
const textTypeColor = Color(0xFF659B91);

//ChatRoom Colors//
const refreshButtonColor = Color(0xFF190354);
const refreshTextColor = Color(0xFFF0F5F4);
const chatRoomColor = Color(0xFF659B91);
const addIconBoundaryColor = Color(0xFFFFFFFF);
const chatRoomTextColor = Color(0xFFD1CDDD);
const logoutButtonColor = Color(0xFF8C81AA);
const personNameColor = Color(0xff1f2021);
const horizontalDotIconColor = Color(0XFFD1CDDD);
const messageStatusColor = Color(0xFFA39ABB);
const listdividerColor = Color(0xFFB2CDC8);
const counterColor = Color(0xFFF76C6C);
const personOfflineColor = Color(0xFFF76C6C);
const counterTextColor = Color(0xFFFEFEF5);

//New Chat Screen Color//
const searchTextColor = Color(0xffB2CDC8);
const searchbarContainerColor = Color(0xffF0F5F4);
const addGroupChatColor = Color(0xff1e2f2c);
const contactNameColor = Color(0xff1e2f2c);

//Create Group Screen Colors//
const selectcontactColor = Color(0xFF190354);

//Contact List Screen//
const contactColor = Color(0xFF190354);

//Popup Screen Color//
const textfieldhint = Color(0XffC1D7D3);
const doneButtonColor = Color(0xfff2e33a);
const doneButtontextColor = Color(0xFF190354);
const groupChtnmeColor = Color(0xff1f2021);
const createGroupColor = Color(0xff8f9090);

//Chat Screen Colors//
const appbarBackgroundColor = Color(0xffFFFFFF);
const sendMessageColoer = Color(0xff494411);
const messageTimeColor = Color(0xff84afa7);
const receiverMessagecolor = Color(0xff659b91);
const typeMessageColor = Color(0xffA3C3BD);
const chatScreenBackgroundColor = Color(0xFFE5E5E5);
const messageBoxColor = Color(0xffFFFFFF);
const userTypingColor = Color(0xFF29B37B);
const userTitleColor = Color(0xFF3D5D57);
const attachmentNameColor = Color(0xff3d5d57);
const popupGreyColor = Color(0xFFC3C4C5);
const popupDeleteButtonColor = Color(0xFFE9446A);

//fonts for the text
const primaryFontFamily = "Manrope";
const secondaryFontFamily = "Inter";
const searchFontFamily = "Poppins";

//Constants for This Application
class ReceiptType {
  static var sent = 1;
  static var delivered = 2;
  static var seen = 3;
}

class MediaType {
  static int image = 0;
  static int audio = 1;
  static int video = 2;
  static int file = 3;
}

class MessageType {
  static const String text = "text";
  static const String media = "media";
  static const String file = "file";
  static const String thumbnail = "thumbnail";
  static const String path = "path";
  static const String typing = "typing";
  static const String sensory = "sensory";
}

//Google API key for auto places
//copied from internet
// const places_API_key = 'AIzaSyAJUDV0OFr87xCIz-fb9AwirXBl3X1nvIc';

//mukhtiyar's provided key
// const places_API_key = 'AIzaSyBvzWwukb4Xaci6v7Quk1BmSh-kYz558Q8';

// Zohaib bhai provided key
// const places_API_key = 'AIzaSyBKZRBquhQ-IZahbLAkRmH1N37RotWSveU';

//Compressed Image's Quality
// const quality = 20;
// const kbSize = 100;

// const Map<String, int> receiptType = {"SENT": 0, "DELIVERED": 1, "SEEN": 2};
// const Map<String, int> mediaType = {
//   "IMAGE": 1,
//   "AUDIO": 2,
//   "VIDEO": 3,
//   "FILE": 4
// };

// const Map<String, String> messageType = {
//   "text": "text",
//   "MEDIA": "MEDIA",
//   "FILE": "FILE",
//   "THUMBNAIL": "THUMBNAIL",
//   "PATH": "PATH",
//   "TYPING": "TYPING",
//   "typing": "typing",
//   "ACKNOWLEDGE": "ACKNOWLEDGE",
//   "RECEIPTS": "RECEIPTS"
// };

const whiteColor = Color(0xFFFFFFFF);
const redColor = Color(0XFF3B434D);
const textColor = Color(0xFF707A89);
const secondaryColor = Color(0xFF11243D);

const primaryColor = Color(0XFF3B434D);
const textfieldBorderColor = Color(0xFFE6E6EB);
const textfieldBackgrounColor = Color(0xFFFDFDFF);
const commentLeadingtextColor = Color(0XFF272727);
const commentBottomtextColor = Color(0XFF7B7B7B);
const commentNavigationIconColor = Color(0XFFE3E3E3);
const commentCountColor = Color(0XFF878787);

const greyColor = Color(0xFF888888);
const lightgreyColor = Color(0xFFC2C2CC);
const blackColor = Color(0xFF000000);
const locationiconColor = Color(0XFFD0D0D0);
const placeholderTextColor = Color(0xFF9D9D9D);
const screenBackgroundColor = Color(0xFFF2F2F2);
const lightskinColor = Color(0xFF979797);
const blackShadeColor = Color(0xFF231818);
const dividerColor = Color(0XFFD5D5E0);
const navyColor = Color(0xFF11243D);
const greyColor2 = Color(0xFF878787);
const geryColor = Color(0XFF4A4A5D);

const listTrailing = Color(0xFF333333);
const listViewSeparatorColor = Color(0xFFF0F0F0);
const captionBox = Color(0xFFFCFCFC);

const iconColor = Color(0xFF9B9B9B);
const borderColor = Color(0xFFCCCCCC);

const shapeGreyColor = Color(0xFF9B9B8b);

const font_Family = "Poppins";
const double font_size = 14;
const double btn_font_size = 18;

const rgbColor = Color.fromRGBO(0, 0, 0, 0.104895);
const rgbColor2 = Color.fromRGBO(0, 0, 0, 0.116341);
const rgbColor3 = Color.fromRGBO(0, 0, 0, 0.12);

// color codes of previous app design
const primaryLightColor = Color(0xFFf0fffb);
const textLightColor = Color(0xFF6A727D);
const lightGreyColor = Color(0xFFF0F0F0);
