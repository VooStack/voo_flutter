import 'package:voo_toast/src/domain/entities/toast.dart';

abstract class ToastRepository {
  Stream<List<Toast>> get toastsStream;
  List<Toast> get currentToasts;
  
  void show(Toast toast);
  void dismiss(String toastId);
  void dismissAll();
  void clearQueue();
}