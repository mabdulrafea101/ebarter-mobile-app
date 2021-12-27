import 'package:fluttercommerce/models/order.dart';
import 'package:fluttercommerce/resources/providers/get_order_list_provider.dart';
import 'package:fluttercommerce/resources/providers/order_create_provider.dart';
import 'package:fluttercommerce/resources/providers/patch_order_provider.dart';

class OrderRepository {
  final OrderCreateProvider _orderCreateProvider = OrderCreateProvider();
  final GetOrderListProvider _getOrderListProvider = GetOrderListProvider();
  final PatchOrderProvider _patchOrderProvider = PatchOrderProvider();
  Future<String> createOrder(
    String token,
    String status,
    int extraPayment,
    int parcelFromSeller,
    int parcelFromBuyer,
    int product1,
    int product2,
  ) =>
      _orderCreateProvider.setData(token, status, extraPayment,
          parcelFromSeller, parcelFromBuyer, product1, product2);

  Future<List<Order>> getOrderList(String token) =>
      _getOrderListProvider.getProductData(token);

  Future<String> patchOrder(
    int orderId,
    String status,
    int product1,
    int product2,
  ) =>
      _patchOrderProvider.setData(orderId, status, product1, product2);
}
