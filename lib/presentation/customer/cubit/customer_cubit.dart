import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/customer/repository/customer_repository.dart';
import 'package:globeporter/presentation/customer/states/customer_states.dart';

class CustomerCubit extends BaseCubit {
  final CustomerRepository _customerRepository;
  CustomerCubit(this._customerRepository);
  bool show = false;

  void switchShow() {
    show = true;
    emit(CustomerGeneralState('Switched'));
  }
}
