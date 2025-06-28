import 'package:core/resources/shared_app_strings.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({final Key? key, this.loadingMessage}) : super(key: key);

  final String? loadingMessage;

  @override
  Widget build(final BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (loadingMessage != null) ...[
              Text(
                loadingMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
            ],
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      );
}

class LoadingWithoutText extends StatelessWidget {
  const LoadingWithoutText({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryColor
                : Colors.white,
          ),
        ),
      );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({final Key? key,}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        constraints: BoxConstraints.expand(),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).primaryColor
                  : Colors.white,
            ),
          ),
        ),
      );
}

class Error extends StatelessWidget {
  const Error({required this.error, final Key? key, this.onRetryPressed})
      : super(key: key);
  final String error;

  final VoidCallback? onRetryPressed;

  @override
  Widget build(final BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              child: Text(SharedAppStrings.retry),
              onPressed: () => onRetryPressed?.call(),
            ),
          ],
        ),
      );
}
