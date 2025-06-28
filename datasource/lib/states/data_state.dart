import 'package:equatable/equatable.dart';

abstract class DataState {}

abstract class PageState extends Equatable implements DataState {}

abstract class PromptState extends Equatable implements DataState {}

class InitialState extends PageState {
  @override
  List<Object> get props => [];
}

class LoadingState extends PageState {
  LoadingState(this.loadingMessage);

  final String? loadingMessage;

  @override
  List<String?> get props => [loadingMessage];
}

class LoadedState<T> extends PageState {
  final String? message;
  final T? data;

  LoadedState({this.message, required this.data});

  @override
  List<T?> get props => [data];
}

class ErrorState extends PageState {
  ErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<String> get props => [errorMessage];
}

class InternetCheckLoading extends PageState {
  InternetCheckLoading(this.errorMessage);

  final String errorMessage;

  @override
  List<String> get props => [errorMessage];
}

class SuccessState extends PageState {
  SuccessState(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class GeneralState extends PageState {
  GeneralState(this.message);

  final String message;
  @override
  List<Object> get props => [];
}

class ErrorPromptState extends PromptState {
  ErrorPromptState(this.errorMessage);

  final String errorMessage;

  @override
  List<String> get props => [errorMessage];
}

class LoadingPromptState extends PromptState {
  LoadingPromptState(this.loadingMessage);

  final String? loadingMessage;

  @override
  List<String?> get props => [loadingMessage];
}

class LanguageChangeState extends PageState {
  LanguageChangeState(this.language);

  final String? language;

  @override
  List<String?> get props => [language];
}
