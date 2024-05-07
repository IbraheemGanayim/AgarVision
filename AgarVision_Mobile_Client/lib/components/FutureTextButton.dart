// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A customizable button widget designed for initiating and displaying the status of asynchronous operations.
///
/// `FutureTextButton` accepts a string [text] to display on the button and a callback function [onPress]
/// that should return a `Future`. An optional [Icon] can be provided to display an icon alongside the text.
class FutureTextButton<T> extends StatefulWidget {
  /// The text to display on the button.
  final String text;

  /// The asynchronous function to be called when the button is pressed.
  /// This function must return a `Future<T>`.
  final Future<T> Function() onPress;

  /// An optional icon to display with the button text.
  final Icon? icon;

  /// Constructs a `FutureTextButton`.
  ///
  /// The [text] and [onPress] arguments must not be null.
  FutureTextButton({required this.text, required this.onPress, this.icon});

  @override
  // ignore: library_private_types_in_public_api
  _FutureTextButtonState createState() => _FutureTextButtonState(text: text);
}

/// The state class for `FutureTextButton`.
///
/// This class handles the UI updates and state changes when the button is pressed.
class _FutureTextButtonState extends State<FutureTextButton> {
  /// The text to display on the button.
  String text;

  /// A boolean to indicate whether the asynchronous operation is currently in progress.
  bool _loading = false;

  /// Constructs a `_FutureTextButtonState`.
  ///
  /// The [text] argument must not be null.
  _FutureTextButtonState({required this.text});

  @override
  Widget build(BuildContext context) {
    // Check if an icon is provided and return the appropriate button widget.
    if (widget.icon != null) {
      return iconButton(widget.icon!);
    }
    return TextButton();
  }

  /// Returns an `ElevatedButton.icon` widget with an icon.
  ///
  /// This button shows the icon and text and changes its label to "Loading..." when an operation is in progress.
  Widget iconButton(Icon icon) {
    return ElevatedButton.icon(
      icon: icon,
      onPressed: onPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      label: Text(
        _loading ? "Loading..." : text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  /// Returns an `ElevatedButton` widget without an icon.
  ///
  /// This button shows only text and changes its content to "Loading..." when an operation is in progress.
  Widget TextButton() {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Text(
          _loading ? "Loading..." : text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  /// Handles the button press event.
  ///
  /// This function prevents multiple simultaneous operations by checking [_loading]. It updates the
  /// button's label to "Loading..." during the operation and resets it upon completion.
  Future<void> onPress() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    await widget.onPress.call();
    setState(() {
      _loading = false;
    });
  }
}