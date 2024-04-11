import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PostController extends GetxController {
  final _isLiking = false.obs;
  bool get isLiking => _isLiking.value;
  final _showAllDescription = false.obs;
  bool get showAllDescription => _showAllDescription.value;
  void setLiking(bool value) {
    _isLiking.value = value;
  }

  void ShowDescription(bool value) {
    _showAllDescription.value = value;
    update();
  }
}
