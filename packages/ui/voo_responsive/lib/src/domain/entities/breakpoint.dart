import 'package:equatable/equatable.dart';
import 'package:voo_responsive/src/domain/enums/device_type.dart';

class Breakpoint extends Equatable {
  final String name;
  final double minWidth;
  final double? maxWidth;
  final DeviceType deviceType;
  final Map<String, dynamic>? metadata;

  const Breakpoint({required this.name, required this.minWidth, this.maxWidth, required this.deviceType, this.metadata});

  static const Breakpoint mobile = Breakpoint(name: 'mobile', minWidth: 0, maxWidth: 599, deviceType: DeviceType.mobile);

  static const Breakpoint tablet = Breakpoint(name: 'tablet', minWidth: 600, maxWidth: 1023, deviceType: DeviceType.tablet);

  static const Breakpoint desktop = Breakpoint(name: 'desktop', minWidth: 1024, maxWidth: 1439, deviceType: DeviceType.desktop);

  static const Breakpoint widescreen = Breakpoint(name: 'widescreen', minWidth: 1440, deviceType: DeviceType.widescreen);

  static const List<Breakpoint> defaults = [mobile, tablet, desktop, widescreen];

  bool matches(double width) {
    final minCheck = width >= minWidth;
    final maxCheck = maxWidth == null || width <= maxWidth!;
    return minCheck && maxCheck;
  }

  Breakpoint copyWith({String? name, double? minWidth, double? maxWidth, DeviceType? deviceType, Map<String, dynamic>? metadata}) => Breakpoint(
    name: name ?? this.name,
    minWidth: minWidth ?? this.minWidth,
    maxWidth: maxWidth ?? this.maxWidth,
    deviceType: deviceType ?? this.deviceType,
    metadata: metadata ?? this.metadata,
  );

  @override
  List<Object?> get props => [name, minWidth, maxWidth, deviceType, metadata];
}
