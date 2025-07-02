import 'package:datasource/states/data_state.dart';
import 'package:equatable/equatable.dart';

abstract class DriverState extends Equatable {
  const DriverState();

  @override
  List<Object> get props => [];
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class AmountDeductedState extends SuccessState {
  AmountDeductedState(super.message);
}
