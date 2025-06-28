import 'package:colorize/colorize.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';

bool _isLogEnabled = !kReleaseMode;

void logI(final String tag,
    {final String? message,
    final Exception? exception,
    final StackTrace? stacktrace,}) {
  if (!_isLogEnabled) {
    return;
  }
  Fimber.i(
    _mergeTagWithMessage(tag, message: message),
    ex: exception,
    stacktrace: stacktrace,
  );
}

void logD(final String tag,
    {final String? message,
    final Exception? exception,
    final StackTrace? stacktrace,}) {
  if (!_isLogEnabled) {
    return;
  }
  Fimber.d(
    _mergeTagWithMessage(tag, message: message),
    ex: exception,
    stacktrace: stacktrace,
  );
}

void logV(final String tag,
    {final String? message,
    final Exception? exception,
    final StackTrace? stacktrace,}) {
  if (!_isLogEnabled) {
    return;
  }
  Fimber.v(
    _mergeTagWithMessage(tag, message: message),
    ex: exception,
    stacktrace: stacktrace,
  );
}

void logW(final String tag,
    {final String? message,
    final Exception? exception,
    final StackTrace? stacktrace,}) {
  if (!_isLogEnabled) {
    return;
  }
  Fimber.w(
    _mergeTagWithMessage(tag, message: message),
    ex: exception,
    stacktrace: stacktrace,
  );
}

void logE(final String tag,
    {final String? message,
    final Object? exception,
    final StackTrace? stacktrace,}) {
  if (!_isLogEnabled) {
    return;
  }
  Fimber.e(
    _mergeTagWithMessage(tag, message: message),
    ex: exception,
    stacktrace: stacktrace,
  );
}

String _mergeTagWithMessage(final String tag, {final String? message}) =>
    message == null ? tag : '$tag - $message';

void logBlueText(final String msg) {
  if (!_isLogEnabled) {
    return;
  }
  color(msg, front: Styles.LIGHT_BLUE);
}

void logGreenText(final String msg) {
  if (!_isLogEnabled) {
    return;
  }
  color(msg, front: Styles.LIGHT_GREEN);
}

void logYellowText(final String msg) {
  if (!_isLogEnabled) {
    return;
  }
  color(msg, front: Styles.LIGHT_YELLOW);
}

void logRedText(final String msg) {
  if (!_isLogEnabled) {
    return;
  }
  color(msg, front: Styles.LIGHT_RED);
}
