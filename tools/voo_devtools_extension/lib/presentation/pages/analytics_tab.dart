import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_list.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_details_panel.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  bool _showDetails = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return BlocConsumer<AnalyticsBloc, AnalyticsState>(
      listener: (context, state) {
        if (_showDetails && state.selectedEvent == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
          const AnalyticsFilterBar(),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: AnalyticsList(
                      events: state.filteredEvents,
                      selectedEventId: state.selectedEvent?.id,
                      scrollController: _scrollController,
                      isLoading: state.isLoading,
                      error: state.error,
                      onEventTap: (event) {
                        context.read<AnalyticsBloc>().add(SelectAnalyticsEvent(event));
                        if (!_showDetails) {
                          setState(() => _showDetails = true);
                        }
                      },
                    ),
                  ),
                  if (_showDetails && state.selectedEvent != null)
                    SizedBox(
                      width: 400,
                      child: AnalyticsDetailsPanel(
                        event: state.selectedEvent!,
                        onClose: () => setState(() => _showDetails = false),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}