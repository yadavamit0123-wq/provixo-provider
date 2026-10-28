import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class LoginTypeSelectionScreen extends StatelessWidget {
  const LoginTypeSelectionScreen({super.key});

  static Route route(RouteSettings settings) {
    return CupertinoPageRoute(
      builder: (BuildContext context) => const LoginTypeSelectionScreen(),
    );
  }

  void _goToLogin(BuildContext context, UserType userType) {
    Navigator.pushNamed(
      context,
      Routes.loginFormScreen,
      arguments: {'userType': userType},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.loginTypeImage, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      'selectLoginTypeToContinue'.translate(context: context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: CustomRoundedButton(
                            onTap: () => _goToLogin(context, UserType.provider),
                            buttonTitle: 'loginAsProvider'.translate(
                              context: context,
                            ),
                            widthPercentage: 1,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.accentColor,
                            showBorder: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomRoundedButton(
                            onTap: () => _goToLogin(context, UserType.handyman),
                            buttonTitle: 'loginAsHandyman'.translate(
                              context: context,
                            ),
                            widthPercentage: 1,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.accentColor,
                            showBorder: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
