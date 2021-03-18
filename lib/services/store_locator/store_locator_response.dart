import 'package:data/data.dart';

class StoreLocatorResponse {
  final int errorCode;
  final String errorDescription;
  final List<ProductLocalSeller> localSellers;
  final List<ProductOnlineSeller> onlineSellers;

  StoreLocatorResponse({
    this.errorCode,
    this.errorDescription,
    this.localSellers,
    this.onlineSellers,
  });

  StoreLocatorResponse.fromJson(Map<String, dynamic> map)
      : errorCode = map['ErrorCode'] as int,
        errorDescription = map['ErrorDescription'] as String,
        localSellers = List<ProductLocalSeller>.from(
          map['ProductsLocalSellers']?.map(
                (x) => ProductLocalSeller.fromJson(x),
              ) ??
              [],
        ),
        onlineSellers = List<ProductOnlineSeller>.from(
          map['ProductsOnlineSellers']?.map(
                (x) => ProductOnlineSeller.fromJson(x),
              ) ??
              [],
        );
}

class ProductLocalSeller extends Data {
  final double latitude;
  final double longitude;
  final int productId;
  final String productName;
  final String sku;
  final List<LocalSeller> sellers;

  ProductLocalSeller({
    this.latitude,
    this.longitude,
    this.productId,
    this.productName,
    this.sku,
    this.sellers,
  });

  ProductLocalSeller.fromJson(Map<String, dynamic> map)
      : latitude = map['Latitude'] as double,
        longitude = map['Longitude'] as double,
        productId = map['ProductId'] as int,
        productName = map['ProductName'] as String,
        sku = map['SKU'] as String,
        sellers = List<LocalSeller>.from(
          map['Sellers']?.map(
                (x) => LocalSeller.fromJson(x),
              ) ??
              [],
        );

  @override
  List<Object> get props => [productId];
}

class ProductOnlineSeller extends Data {
  final List<OnlineSeller> sellers;
  ProductOnlineSeller({this.sellers});

  ProductOnlineSeller.fromJson(Map<String, dynamic> map)
      : sellers = List<OnlineSeller>.from(
          map['Sellers']?.map(
                (x) => OnlineSeller.fromJson(x),
              ) ??
              [],
        );

  @override
  List<Object> get props => [sellers];
}

class OnlineSeller extends Data {
  final int id;
  final String name;
  final String smallLogoUrl;
  final bool inStock;
  final String addToCartRedirectUrl;
  final String redirectUrl;
  OnlineSeller({
    this.id,
    this.name,
    this.smallLogoUrl,
    this.inStock,
    this.addToCartRedirectUrl,
    this.redirectUrl,
  });

  OnlineSeller.fromJson(Map<String, dynamic> map)
      : id = map['SellerId'],
        name = map['SellerName'],
        smallLogoUrl = map['SmallSellerLogoUrl'],
        inStock = map['InStock'],
        addToCartRedirectUrl = map['AddToCartRedirectURL'],
        redirectUrl = map['RedirectURL'];

  @override
  List<Object> get props => [id];
}

class LocalSeller extends Data {
  final int id;
  final String name;
  final List<Store> stores; // Single seller can have multiple stores

  LocalSeller({
    this.id,
    this.name,
    this.stores,
  });

  LocalSeller.fromJson(Map<String, dynamic> map)
      : id = map['SellerId'] as int,
        name = map['SellerName'] as String,
        stores = List<Store>.from(
          map['Stores']?.map(
                (x) => Store.fromJson(x),
              ) ??
              [],
        );

  @override
  List<Object> get props => [id];
}

class Store extends Data {
  // Store address info
  final int id;
  final String name;
  final String address;
  final String city;
  final String state;

  // Distance info
  final double distanceKm;
  final double distanceMi;

  // Address and Phone info
  final double latitude;
  final double longitude;
  final String zipCode;
  final String phone;

  Store({
    this.id,
    this.name,
    this.address,
    this.city,
    this.state,
    this.distanceKm,
    this.distanceMi,
    this.latitude,
    this.longitude,
    this.zipCode,
    this.phone,
  });

  Store.fromJson(Map<String, dynamic> map)
      : id = map['StoreId'] as int,
        name = map['StoreName'] as String,
        address = map['Address1'] as String,
        city = map['City'] as String,
        state = map['State'] as String,
        distanceKm = map['DistanceKM'] as double,
        distanceMi = map['DistanceMi'] as double,
        latitude = map['Latitude'] as double,
        longitude = map['Longitude'] as double,
        zipCode = map['PostalCode'] as String,
        phone = map['Phone'] as String;

  @override
  List<Object> get props => [id];
}
