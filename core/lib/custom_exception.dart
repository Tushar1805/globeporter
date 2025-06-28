import 'dart:convert';

import 'package:core/utils/core_utils.dart';

class CustomException implements Exception {
  CustomException([this._message, this._prefix]);

  final String? _message;
  final String? _prefix;

  String toString() {
    if (_prefix != null) {
      return '$_prefix$_message';
    }

    return _message ?? '';
  }
}

String _extractMessage(final String jsonResponse) {
  try {
    final decodedResponse = jsonDecode(jsonResponse) as Map<String, dynamic>;
    customPrint(decodedResponse['msg']);
    return decodedResponse['msg']?.toString() ?? 'Unknown error occurred';
  } catch (e) {
    return 'Unknown error occurred';
  }
}

class FetchDataException extends CustomException {
  FetchDataException(final String message)
      : super(_extractMessage(message), 'Error During Communication: ');
}

class BadRequestException extends CustomException {
  BadRequestException(final String message)
      : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(final String message)
      : super(_extractMessage(message), 'Unauthorised: ');
}

class InvalidInputException extends CustomException {
  InvalidInputException(final String message)
      : super(message, 'Invalid Input: ');
}

class NoInternetException extends CustomException {
  NoInternetException() : super('Oops! No Internet Connection', '');
}

class InternalServerException extends CustomException {
  InternalServerException(final String message)
      : super(message, 'Internal Server Error: ');
}

class ApiErrorException extends CustomException {
  ApiErrorException(final String message) : super(message);
}

class NoGpsException extends CustomException {
  NoGpsException(final String message) : super(message);
}
