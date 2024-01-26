import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knock_at/constants/gaps.dart';
import 'package:knock_at/constants/sizes.dart';
import 'package:knock_at/features/authentication/views/address_screen.dart';
import 'package:knock_at/features/authentication/views/email_screen.dart';
import 'package:knock_at/features/authentication/views/name_screen.dart';
import 'package:knock_at/features/authentication/views/phone_number_screen.dart';
import 'package:knock_at/features/authentication/views/terms_and_conditions_screen.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  UserInfoScreenState createState() => UserInfoScreenState();
}

class UserInfoScreenState extends ConsumerState<UserInfoScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 5,
      vsync: this, // Add this line
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double _progress =
      0.2; // Example progress value, update this based on user interaction

  void _onTapKeyboardDismiss() {
    FocusScope.of(context).unfocus();
  }

  // Update this function to change progress value
  void _updateProgress() {
    setState(() {
      _progress += 0.2;
    });
  }

  void _goToNextTab() {
    _updateProgress();
    _tabController.animateTo(_tabController.index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapKeyboardDismiss,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            '회원가입',
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: _progress, // Current progress
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            NameScreen(onNext: _goToNextTab),
            PhoneNumberScreen(onNext: _goToNextTab),
            AddressScreen(onNext: _goToNextTab),
            EmailScreen(onNext: _goToNextTab),
            const TermsAndConditionsScreen(),
          ],
        ),
      ),
    );
  }
}
