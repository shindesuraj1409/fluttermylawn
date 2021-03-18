import 'package:flutter/material.dart';
import 'package:my_lawn/models/pdp/local_store_locator_model.dart';
import 'package:my_lawn/screens/pdp/store_locator/widgets/store_error_message_widgets.dart';
import 'package:my_lawn/screens/pdp/store_locator/widgets/store_card_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class StoreListView extends StatefulWidget {
  final LocalStoresData data;
  StoreListView({this.data});

  @override
  _StoreListViewState createState() => _StoreListViewState();
}

class _StoreListViewState extends State<StoreListView>
    with AutomaticKeepAliveClientMixin<StoreListView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (widget.data.state) {
      case LocalStoreState.loading:
      case LocalStoreState.initial:
        return Center(child: ProgressSpinner());
      case LocalStoreState.unknownError:
      case LocalStoreState.locationNotFoundError:
      case LocalStoreState.placesApiError:
      case LocalStoreState.storeLocatorError:
        return ErrorMessage(widget.data.state);
      case LocalStoreState.permissionError:
        return Container(); // This is because we show dialog instead and keep screen blank during this state.
      case LocalStoreState.success:
        if (widget.data.stores.isEmpty) {
          return NoStoreFound();
        }
        return Padding(
          // Note : This is calculated as `TextField's` height of "48" and its padding vertical of "8" in both direction
          // So, it is calculated as  48(TextField height) + 8(top padding) + 8(bottom padding) = 64
          padding: const EdgeInsets.only(top: 64),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 48),
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return StoreCard(store: widget.data.stores[index]);
            },
            itemCount: widget.data.stores.length,
          ),
        );
      default:
        throw UnimplementedError('Incorrect state reached');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
