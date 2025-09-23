import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/repositories/toast_repository.dart';

class ShowToastUseCase {
  const ShowToastUseCase(this._repository);

  final ToastRepository _repository;

  void call(Toast toast) {
    _repository.show(toast);
  }
}
