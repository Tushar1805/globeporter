import 'package:core/custom_exception.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globeporter/resources/app_strings.dart';

class BaseCubit extends Cubit<DataState> {
  BaseCubit() : super(InitialState());

  void handleExceptions(final Object e) {
    final message = e is CustomException
        ? e
        : e is NoInternetException
            ? noInternetString
            : someErrorOccurredString;

    customPrint('ERROR: $message: $e');

    emit(ErrorState(message.toString()));
  }
}
