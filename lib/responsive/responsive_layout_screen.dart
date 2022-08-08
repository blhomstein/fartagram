import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/providers/user_provider.dart';
import 'package:social_media/utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webscreenLayout;
  final Widget mobilescreenLayout;
  const ResponsiveLayout(
      {Key? key,
      required this.webscreenLayout,
      required this.mobilescreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webscreensize) {
          //web screen layout
          return widget.webscreenLayout;
        }
        //mobile screen layout
        return widget.mobilescreenLayout;
      },
    );
  }
}
