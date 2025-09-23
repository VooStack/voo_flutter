import 'package:voo_toast/src/domain/repositories/toast_repository.dart';

class DismissToastUseCase {
  const DismissToastUseCase(this._repository);

  final ToastRepository _repository;

  void call(String toastId) {
    _repository.dismiss(toastId);
  }
}
