import 'package:equatable/equatable.dart';
import 'package:voo_lists/src/domain/entities/list_item.dart';

abstract class VooListState<T> extends Equatable {
  const VooListState();
}

class ListInitial<T> extends VooListState<T> {
  @override
  List<Object> get props => [];
}

class ListLoading<T> extends VooListState<T> {
  @override
  List<Object> get props => [];
}

class ListLoaded<T> extends VooListState<T> {
  final List<ListItem<T>> items;
  final Set<String> selectedItems;

  const ListLoaded({required this.items, this.selectedItems = const {}});

  @override
  List<Object> get props => [items, selectedItems];
}

class ListError<T> extends VooListState<T> {
  final String message;

  const ListError(this.message);

  @override
  List<Object> get props => [message];
}
