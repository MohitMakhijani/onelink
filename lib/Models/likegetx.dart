import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PostController extends GetxController {
  final _isLiking = false.obs;

  bool get isLiking => _isLiking.value;

  void setLiking(bool value) {
    _isLiking.value = value;
  }
}