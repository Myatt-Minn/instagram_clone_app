import 'package:firebaseproj/providers/user_provider.dart';
import 'package:firebaseproj/resources/auth_method.dart';
import 'package:firebaseproj/screens/loginscreen.dart';
import 'package:firebaseproj/utils/colors.dart';
import 'package:firebaseproj/utils/global_variables.dart';
import 'package:firebaseproj/widgets/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveScreen(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRefreshedUser();
  }

  getRefreshedUser() async {
    setState(() {
      isLoading = true;
    });
    UserProvider _userPro = Provider.of(context, listen: false);
    await _userPro.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : LayoutBuilder(builder: (context, constraint) {
            if (constraint.maxWidth > webScreenSize) {
              //web screen
              return widget.webScreenLayout;
            }
            //mobile screen
            return widget.mobileScreenLayout;
          });
  }
}
