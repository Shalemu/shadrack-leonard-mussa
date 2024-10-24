import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Used for encoding and decoding JSON
import 'package:mauzoApp/core/app_export.dart'; // Replace with your app export utilities // Custom styling
import 'package:mauzoApp/domain/googleauth/google_auth_helper.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/home_vtwo_page.dart';
import 'package:mauzoApp/widgets/custom_button.dart'; // Custom button widget
import 'package:mauzoApp/widgets/custom_text_form_field.dart'; // Custom text field
import 'package:mauzoApp/widgets/spacing.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Store token after successful login
Future<void> storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_token', token);
  await prefs.setBool('isLoggedIn', true); // Store login status
}

Future<void> saveUserCredentials(
    String shopId, String adminId, String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('shop_id', shopId);
  await prefs.setString('admin_id', adminId);
  await prefs.setString('user_id', userId);
}

// Save user's first and last name in SharedPreferences
Future<void> saveUserData(String fname, String lname) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('fname', fname);
  await prefs.setString('lname', lname);
}

// Retrieve user's full name from SharedPreferences
Future<String> getUserFullName() async {
  final prefs = await SharedPreferences.getInstance();
  final fname = prefs.getString('fname') ?? '';
  final lname = prefs.getString('lname') ?? '';
  return '$fname $lname'; // Combine first and last name
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(), // Set LoginPage as the starting screen
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isShowPassword = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage; // Variable to hold error message
  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Clear any previous error messages
      _isLoading = true; // Start loading
    });

    const String apiUrl = 'https://mauzo360.com/login/app-auth'; // API URL

    // Validate username for 10-digit phone number
    if (_formKey.currentState?.validate() != true) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      return; // Stop if the form is invalid
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('API Response: $data'); // Debug print

        if (data['status'] == 1) {
          final String token = data['Token'] ?? ''; // Use empty string if null
          final String shopId =
              data['shop']['id']?.toString() ?? ''; // Extract shop ID
          final String adminId =
              data['user']['admin_id']?.toString() ?? ''; // Extract admin ID
          final String userId = data['user']['user_id']?.toString() ?? '';
          final String fname = data['user']['fname'] ?? '';
          final String lname = data['user']['lname'] ?? '';
          await saveUserData(fname, lname); // Extract user ID

          // Debug prints to check the extracted values
          print('Token: $token');
          print('Shop ID: $shopId');
          print('Admin ID: $adminId');
          print('User ID: $userId');

          // Check for empty values
          if (token.isEmpty ||
              shopId.isEmpty ||
              adminId.isEmpty ||
              userId.isEmpty) {
            setState(() {
              _errorMessage = 'One or more credentials are missing.';
            });
            return;
          }

          // Store the token and user credentials
          await storeToken(token);
          await saveUserCredentials(shopId, adminId, userId);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeVtwoPage(
                itemName: _usernameController.text,
                token: token,
                deviceKey: '',
              ),
            ),
          );
        } else {
          // Set API error message
          setState(() {
            _errorMessage = data['message']?.toString() ?? 'Unknown error';
          });
        }
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error occurred: $error';
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700, // Background color
            body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(height: 30), // Custom spacing

                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: getPadding(left: 24, top: 20, right: 24),
                            child: Text(
                              "lbl_sign_in".tr, // Localized text
                              style: AppStyle.txtNotoSansJPBold24,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: getPadding(left: 24, top: 6, right: 24),
                            child: Text(
                              "lbl_welcome_back".tr,
                              style: AppStyle.txtNotoSansJPRegular16.copyWith(
                                letterSpacing: 0.40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30), // Space for error message
                        if (_errorMessage !=
                            null) // Show error message if it exists
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center, // Center the text
                            ),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          width: size.width,
                          focusNode: FocusNode(),
                          controller: _usernameController,
                          hintText: "Username",
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          prefix: Icon(Icons.person),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your username";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          width: size.width,
                          controller: _passwordController,
                          hintText: "Password",
                          isObscureText: !_isShowPassword,
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          prefix: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                _isShowPassword = !_isShowPassword;
                              });
                            },
                            child: Icon(
                              _isShowPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: getPadding(left: 24, top: 18, right: 24),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.forgotPasswordScreen);
                              },
                              child: Text(
                                "msg_forgot_password".tr,
                                style: AppStyle.txtNotoSansJPBold14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          child: _isLoading
                              ? Center(
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.orange[400]!),
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                )
                              : CustomButton(
                                  text: "Login",
                                  shape: ButtonShape.RoundedBorder16,
                                  fontStyle: ButtonFontStyle.NotoSansJPMedium14,
                                  onTap: _login,
                                ),
                        ),

                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding:
                                    getPadding(left: 24, top: 25, right: 24),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                          height: getVerticalSize(1.00),
                                          width: getHorizontalSize(139.00),
                                          margin: getMargin(top: 9, bottom: 10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment(
                                                      0.0034842889659598233,
                                                      -0.5002556563231337),
                                                  end: Alignment(
                                                      0.9999999443990735,
                                                      -0.5004710619341495),
                                                  colors: [
                                                ColorConstant.gray200,
                                                ColorConstant.gray20000
                                              ]))),
                                      Padding(
                                          padding: getPadding(left: 16),
                                          child: Text("lbl_or".tr,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: AppStyle
                                                  .txtNotoSansJPRegular14)),
                                      Container(
                                          height: getVerticalSize(1.00),
                                          width: getHorizontalSize(139.00),
                                          margin: getMargin(
                                              left: 16, top: 9, bottom: 10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment(
                                                      0.0034842889659598233,
                                                      -0.5002556563231337),
                                                  end: Alignment(
                                                      0.9999999443990735,
                                                      -0.5004710619341495),
                                                  colors: [
                                                ColorConstant.gray200,
                                                ColorConstant.gray20000
                                              ])))
                                    ]))),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              onTapButton();
                            },
                            child: Container(
                              margin: getMargin(left: 24, top: 22, right: 24),
                              decoration: AppDecoration.outlineGray200.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding: getPadding(
                                          left: 20, top: 16, bottom: 16),
                                      child: CommonImageView(
                                          svgPath: ImageConstant.imgGoogle,
                                          height: getSize(24.00),
                                          width: getSize(24.00))),
                                  Padding(
                                      padding: getPadding(
                                          left: 55, top: 19, bottom: 15),
                                      child: Text("msg_sign_in_with_google".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: AppStyle
                                              .txtNotoSansJPMedium14Gray902))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                margin: getMargin(left: 24, top: 12, right: 24),
                                decoration: AppDecoration.outlineGray200
                                    .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                          padding: getPadding(
                                              left: 20, top: 16, bottom: 16),
                                          child: CommonImageView(
                                              svgPath: ImageConstant
                                                  .imgAntdesignappl,
                                              height: getSize(24.00),
                                              width: getSize(24.00))),
                                      Padding(
                                          padding: getPadding(
                                              left: 59, top: 19, bottom: 15),
                                          child: Text(
                                              "msg_sign_in_with_apple".tr,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: AppStyle
                                                  .txtNotoSansJPMedium14Gray902))
                                    ]))),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: getHorizontalSize(261.00),
                                margin: getMargin(
                                    left: 24, top: 24, right: 24, bottom: 5),
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Get.toNamed(
                                        AppRoutes.signUpEmptyStateScreen);
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "msg_already_have_account".tr,
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.bluegray301,
                                                fontSize: getFontSize(12),
                                                fontFamily: 'Noto Sans JP',
                                                fontWeight: FontWeight.w500)),
                                        TextSpan(
                                            text: "msg_create_an_account".tr,
                                            style: TextStyle(
                                                color: ColorConstant.primary,
                                                fontSize: getFontSize(14),
                                                fontFamily: 'Noto Sans JP',
                                                fontWeight: FontWeight.w600)),
                                      ]),
                                      textAlign: TextAlign.center),
                                ))),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: getHorizontalSize(261.00),
                                margin: getMargin(
                                    left: 24, top: 20, right: 24, bottom: 10),
                                child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "msg_by_sign_in_i_accept2".tr,
                                          style: TextStyle(
                                              color: ColorConstant.bluegray301,
                                              fontSize: getFontSize(10),
                                              fontFamily: 'Noto Sans JP',
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: "msg_terms_of_service".tr,
                                          style: TextStyle(
                                              color: ColorConstant.primary,
                                              fontSize: getFontSize(10),
                                              fontFamily: 'Noto Sans JP',
                                              fontWeight: FontWeight.w500)),
                                      TextSpan(
                                          text: "lbl_and".tr,
                                          style: TextStyle(
                                              color: ColorConstant.bluegray301,
                                              fontSize: getFontSize(10),
                                              fontFamily: 'Noto Sans JP',
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: "msg_community_guidelines".tr,
                                          style: TextStyle(
                                              color: ColorConstant.primary,
                                              fontSize: getFontSize(10),
                                              fontFamily: 'Noto Sans JP',
                                              fontWeight: FontWeight.w500)),
                                      TextSpan(
                                          text: "lbl_and_have_read".tr,
                                          style: TextStyle(
                                              color: ColorConstant.bluegray301,
                                              fontSize: getFontSize(10),
                                              fontFamily: 'Noto Sans JP',
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: "lbl_privacy_policy".tr,
                                          style: TextStyle(
                                              color: ColorConstant.primary,
                                              fontSize: getFontSize(10),
                                              fontFamily: 'Noto Sans JP',
                                              fontWeight: FontWeight.w500))
                                    ]),
                                    textAlign: TextAlign.center))),
                      ])),
            )));
  }

  onTapImgArrowleft() {
    Get.back();
  }

  onTapButton() async {
    await GoogleAuthHelper().googleSignInProcess().then((googleUser) {
      if (googleUser != null) {
        //TODO Actions to be performed after signin
      } else {
        Get.snackbar('Error', 'user data is empty');
      }
    }).catchError((onError) {
      Get.snackbar('Error', onError.toString());
    });
  }
}
