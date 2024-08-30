
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/domain/enums/payment.dart';

class PaymentService {

  static const PaymentService instance = PaymentService();
  const PaymentService();

  Future<ResponseResult> readyPayment({required int amount, required Payment payment}) async {
    return await ApiService.instance.get(
        uri: '/user/cash/charge/${payment.url}?amount=$amount',
        authorization: true
    );
  }

}