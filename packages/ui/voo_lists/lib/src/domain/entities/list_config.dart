import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_lists/src/domain/enums/list_animation_type.dart';
import 'package:voo_lists/src/domain/enums/list_behavior.dart';
import 'package:voo_lists/src/domain/enums/list_layout.dart';

class ListConfig extends Equatable {
  final ListLayout layout;
  final ListBehavior behavior;
  final ListAnimationType animationType;
  final bool showDividers;
  final bool showGroupHeaders;
  final bool enablePullToRefresh;
  final bool enableInfiniteScroll;
  final bool enableSearch;
  final bool enableSelection;
  final bool enableMultiSelection;
  final bool enableReordering;
  final bool enableSwipeToDismiss;
  final EdgeInsets? padding;
  final double? itemSpacing;
  final double? groupSpacing;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final bool reverse;
  final Widget? emptyStateWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Duration animationDuration;
  final Curve animationCurve;

  const ListConfig({
    this.layout = ListLayout.vertical,
    this.behavior = ListBehavior.standard,
    this.animationType = ListAnimationType.fadeIn,
    this.showDividers = true,
    this.showGroupHeaders = true,
    this.enablePullToRefresh = false,
    this.enableInfiniteScroll = false,
    this.enableSearch = false,
    this.enableSelection = false,
    this.enableMultiSelection = false,
    this.enableReordering = false,
    this.enableSwipeToDismiss = false,
    this.padding,
    this.itemSpacing,
    this.groupSpacing,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.reverse = false,
    this.emptyStateWidget,
    this.loadingWidget,
    this.errorWidget,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  ListConfig copyWith({
    ListLayout? layout,
    ListBehavior? behavior,
    ListAnimationType? animationType,
    bool? showDividers,
    bool? showGroupHeaders,
    bool? enablePullToRefresh,
    bool? enableInfiniteScroll,
    bool? enableSearch,
    bool? enableSelection,
    bool? enableMultiSelection,
    bool? enableReordering,
    bool? enableSwipeToDismiss,
    EdgeInsets? padding,
    double? itemSpacing,
    double? groupSpacing,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    bool? shrinkWrap,
    bool? reverse,
    Widget? emptyStateWidget,
    Widget? loadingWidget,
    Widget? errorWidget,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => ListConfig(
    layout: layout ?? this.layout,
    behavior: behavior ?? this.behavior,
    animationType: animationType ?? this.animationType,
    showDividers: showDividers ?? this.showDividers,
    showGroupHeaders: showGroupHeaders ?? this.showGroupHeaders,
    enablePullToRefresh: enablePullToRefresh ?? this.enablePullToRefresh,
    enableInfiniteScroll: enableInfiniteScroll ?? this.enableInfiniteScroll,
    enableSearch: enableSearch ?? this.enableSearch,
    enableSelection: enableSelection ?? this.enableSelection,
    enableMultiSelection: enableMultiSelection ?? this.enableMultiSelection,
    enableReordering: enableReordering ?? this.enableReordering,
    enableSwipeToDismiss: enableSwipeToDismiss ?? this.enableSwipeToDismiss,
    padding: padding ?? this.padding,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    groupSpacing: groupSpacing ?? this.groupSpacing,
    physics: physics ?? this.physics,
    scrollDirection: scrollDirection ?? this.scrollDirection,
    shrinkWrap: shrinkWrap ?? this.shrinkWrap,
    reverse: reverse ?? this.reverse,
    emptyStateWidget: emptyStateWidget ?? this.emptyStateWidget,
    loadingWidget: loadingWidget ?? this.loadingWidget,
    errorWidget: errorWidget ?? this.errorWidget,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  @override
  List<Object?> get props => [
    layout,
    behavior,
    animationType,
    showDividers,
    showGroupHeaders,
    enablePullToRefresh,
    enableInfiniteScroll,
    enableSearch,
    enableSelection,
    enableMultiSelection,
    enableReordering,
    enableSwipeToDismiss,
    padding,
    itemSpacing,
    groupSpacing,
    physics,
    scrollDirection,
    shrinkWrap,
    reverse,
    animationDuration,
    animationCurve,
  ];
}
