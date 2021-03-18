import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/places/place_details_data.dart';
import 'package:my_lawn/data/places/place_prediction_data.dart';

abstract class GoogleResponseStatus extends Equatable {
  static const okay = 'OK';
  static const zeroResults = 'ZERO_RESULTS';
  static const overQueryLimit = 'OVER_QUERY_LIMIT';
  static const requestDenied = 'REQUEST_DENIED';
  static const invalidRequest = 'INVALID_REQUEST';
  static const unknownErrorStatus = 'UNKNOWN_ERROR';
  static const notFound = 'NOT_FOUND';
  static const maxWaypointsExceeded = 'MAX_WAYPOINTS_EXCEEDED';
  static const maxRouteLengthExceeded = 'MAX_ROUTE_LENGTH_EXCEEDED';

  final String status;

  /// JSON error_message
  final String errorMessage;

  bool get isOkay => status == okay;
  bool get hasNoResults => status == zeroResults;
  bool get isOverQueryLimit => status == overQueryLimit;
  bool get isDenied => status == requestDenied;
  bool get isInvalid => status == invalidRequest;
  bool get unknownError => status == unknownErrorStatus;
  bool get isNotFound => status == notFound;

  GoogleResponseStatus.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        errorMessage = json['error_message'] as String;
}

class PlacesAutoCompleteResponse extends GoogleResponseStatus {
  final List<PlacePrediction> predictions;

  PlacesAutoCompleteResponse.fromJson(Map<String, dynamic> json)
      : predictions = List<PlacePrediction>.from(
          json['predictions']?.map(
                (prediction) => PlacePrediction.fromJson(prediction),
              ) ??
              [],
        ),
        super.fromJson(json);

  @override
  List<Object> get props => [predictions, status, errorMessage];
}

class PlaceDetailsResponse extends GoogleResponseStatus {
  final PlaceDetails placeDetails;

  PlaceDetailsResponse.fromJson(Map<String, dynamic> json)
      : placeDetails = json['result'] != null
            ? PlaceDetails.fromJson(json['result'])
            : null,
        super.fromJson(json);

  @override
  List<Object> get props => [placeDetails, status, errorMessage];
}
