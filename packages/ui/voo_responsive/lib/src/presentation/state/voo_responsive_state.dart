import 'package:equatable/equatable.dart';
import 'package:voo_responsive/src/domain/entities/screen_info.dart';

abstract class VooResponsiveState extends Equatable {
  const VooResponsiveState();
}

class ResponsiveInitial extends VooResponsiveState {
  @override
  List<Object> get props => [];
}

class ResponsiveUpdated extends VooResponsiveState {
  final ScreenInfo screenInfo;

  const ResponsiveUpdated(this.screenInfo);

  @override
  List<Object> get props => [screenInfo];
}