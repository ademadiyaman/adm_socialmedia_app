import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key? key,
      required this.buttonText,
      this.butonColor = Colors.lightBlue,
      this.textColor = Colors.redAccent,
      this.radius = 15,
      this.yukseklik = 60,
      required this.butonIcon,
      required this.onPressed})
      : assert(buttonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(radius),
      )),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (butonIcon != null) ...[
            butonIcon,
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 12),
            ),
            Opacity(opacity: 0, child: butonIcon)
          ],
          if (butonIcon == null) ...[
            Container(),
            Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
            Container(),
          ]
        ],
      ),
      color: butonColor,
    );
  }
}
