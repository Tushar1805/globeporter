import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/customer/repository/customer_repository.dart';

class CustomerCubit extends BaseCubit {
  final CustomerRepository _customerRepository;
  CustomerCubit(this._customerRepository);
}
