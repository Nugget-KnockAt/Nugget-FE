import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin extends StatefulWidget {
  const KakaoLogin({super.key});

  @override
  State<KakaoLogin> createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;
  @override
  void initState() {
    super.initState();
    _checkKakaoInstalled();
  }

  void _checkKakaoInstalled() async {
    final isInstalled = await isKakaoTalkInstalled();
    if (isInstalled) {
      setState(() {
        _isKakaoTalkInstalled = isInstalled;
      });
    } else {
      setState(() {
        _isKakaoTalkInstalled = isInstalled;
      });
    }
  }

  void _authorizeWithKakao() async {
    try {
      await AuthCodeClient.instance.authorizeWithTalk(
        redirectUri:
            'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=b721de5fbf402ff1131e42e1ce771b92&redirect_uri=http://localhost:8080/login/oauth2/kakao/callback',
      );
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          title: const Text('Kakao Login'),
        ),
      ),
    );
  }
}
