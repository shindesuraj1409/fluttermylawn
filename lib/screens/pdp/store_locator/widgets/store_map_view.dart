import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_lawn/models/pdp/local_store_locator_model.dart';
import 'package:my_lawn/screens/pdp/store_locator/widgets/store_error_message_widgets.dart';
import 'package:my_lawn/screens/pdp/store_locator/widgets/store_card_widget.dart';
import 'package:my_lawn/services/store_locator/store_locator_response.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:uuid/uuid.dart';

class StoreMapView extends StatefulWidget {
  final LocalStoresData data;
  final BitmapDescriptor selectedStoreMarker;
  final BitmapDescriptor unselectedStoreMarker;

  StoreMapView({
    this.data,
    this.selectedStoreMarker,
    this.unselectedStoreMarker,
  });

  @override
  _StoreMapViewState createState() => _StoreMapViewState();
}

class _StoreMapViewState extends State<StoreMapView>
    with AutomaticKeepAliveClientMixin<StoreMapView> {
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

        return _StoresMap(
          stores: widget.data.stores,
          selectedStoreMarker: widget.selectedStoreMarker,
          unselectedStoreMarker: widget.unselectedStoreMarker,
        );
      default:
        throw UnimplementedError('Incorrect state reached');
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _StoresMap extends StatefulWidget {
  final List<Store> stores;
  final BitmapDescriptor selectedStoreMarker;
  final BitmapDescriptor unselectedStoreMarker;
  _StoresMap({
    this.stores,
    this.selectedStoreMarker,
    this.unselectedStoreMarker,
  });

  @override
  __StoresMapState createState() => __StoresMapState();
}

class __StoresMapState extends State<_StoresMap> {
  Store selectedStore;

  void _onMarkerClicked(Store store) {
    setState(() {
      selectedStore = store;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stores = widget.stores;
    var markers = <Marker>{};

    if (stores.isNotEmpty) {
      markers = stores
          .map(
            (store) => Marker(
              markerId: MarkerId((store.id?.toString() ?? Uuid().v4())),
              consumeTapEvents: true,
              position: LatLng(store.latitude, store.longitude),
              draggable: false,
              icon: selectedStore != null && selectedStore.id == store.id
                  ? widget.selectedStoreMarker
                  : widget.unselectedStoreMarker,
              onTap: () {
                _onMarkerClicked(store);
              },
            ),
          )
          .toSet();
    } else {
      selectedStore = null;
    }

    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          markers: markers,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              stores[0].latitude,
              stores[0].longitude,
            ),
            zoom: 10,
          ),
        ),
        if (selectedStore != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StoreCard(store: selectedStore),
              ],
            ),
          ),
      ],
    );
  }
}
