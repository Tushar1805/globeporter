import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/settings/model/create_order_response.dart';
import 'package:globeporter/presentation/settings/model/wallet_data_response.dart';
import 'package:globeporter/presentation/settings/model/wallet_history_response.dart';
import 'package:globeporter/resources/app_api.dart';

class WalletRepository extends BaseRepository {
  Future<CreateOrderResponse> createOrder({
    required final String lang,
    required final String accessToken,
    required final int amount, //& in rupee
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: createOrderUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'amount': amount,
      },
    );

    return CreateOrderResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<Map<String, dynamic>> addMoneyToWallet({
    required final String lang,
    required final String accessToken,
    required final String transactionId,
    required final String paymentMode,
    required final String transactionDate,
    required final String transactionTime,
    required final String amount, //& in rupee
    required final String paymentStatus,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: addMoneyToWalletUrl,
      accessToken: accessToken,
      requestModel: {
        "lang": lang,
        "transaction_id": transactionId,
        "payment_mode": paymentMode,
        "transaction_date": transactionDate,
        "transaction_time": transactionTime,
        "transaction_amount": amount,
        "payment_status": paymentStatus // Failed or Paid
      },
    );

    return responseData;
  }

  Future<WalletDataResponse> getWalletData({
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getWalletDataUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return WalletDataResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<WalletHistoryResponse> getWalletHistory({
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getWalletHistoryUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return WalletHistoryResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }
}
