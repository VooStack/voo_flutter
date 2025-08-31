import 'package:equatable/equatable.dart';

/// Base class for all validation rules
abstract class VooValidationRule<T> extends Equatable {
  final String errorMessage;
  
  const VooValidationRule({required this.errorMessage});
  
  String? validate(T? value);
  
  @override
  List<Object?> get props => [errorMessage];
}