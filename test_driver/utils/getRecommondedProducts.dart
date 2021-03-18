import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:math';

extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)')
        .hasMatch(this);
  }

  int get smallestCoverageArea {
    if (this == null) return null;
    final coverages = split(' ').expand((element) {
      final sanitized = element.replaceAll(',', '');
      return [int.tryParse(sanitized)];
    }).toList();
    coverages.removeWhere((element) => element == null);
    return coverages.isEmpty ? null : coverages.reduce(min);
  }
}

class Product {
  final String name;
  final String description;
  final String shortDescription;
  final String sku;
  final String parentSku;
  final bool applied;
  final String activityId;
  final bool isArchived;
  final bool isSubscribed;
  final bool isRecommended;
  final bool isAddedByMe;
  final bool isAddOn;
  final bool skipped;
  final String miniClaim1;
  final String miniClaimImage1;
  final String miniClaim2;
  final String miniClaimImage2;
  final String miniClaim3;
  final String miniClaimImage3;
  final int quantity;
  final double price;
  final String lawnCondition;
  final String minTemp;
  final String maxTemp;
  final String afterSeed;
  final List<String> categoryList;
  final int coverageArea;

  final List<String> killsWeedList;
  final String analysis;
  final String disposalMethods;
  final String kidsAndPets;
  final String cautions;

  final String howToApply;
  final String howOftenToApply;
  final String whenToApply;
  final String restrictions;
  final String spreaderSetting;
  final String overviewBenefits;

  final String thumbnailLabel;
  final String youtubeUrl;
  final String imageUrl;
  final ProductApplicationWindow applicationWindow;
  final List<Product> childProducts;

  // This field doesn't comes from api and is calculated client side
  // using [getUpdatedPlanWithPricesCalculated] method on [Plan] object
  final double bundlePrice;

  Product({
    this.isAddOn,
    this.howToApply,
    this.howOftenToApply,
    this.whenToApply,
    this.restrictions,
    this.spreaderSetting,
    this.killsWeedList,
    this.analysis,
    this.disposalMethods,
    this.kidsAndPets,
    this.cautions,
    this.categoryList,
    this.coverageArea,
    this.youtubeUrl,
    this.applied = false,
    this.skipped = false,
    this.isArchived = false,
    this.isSubscribed = false,
    this.isAddedByMe = false,
    this.isRecommended,
    this.lawnCondition,
    this.minTemp,
    this.maxTemp,
    this.afterSeed,
    this.name,
    this.description,
    this.shortDescription,
    this.sku,
    this.parentSku,
    this.miniClaim1,
    this.miniClaimImage1,
    this.miniClaim2,
    this.imageUrl,
    this.miniClaimImage2,
    this.miniClaim3,
    this.miniClaimImage3,
    this.quantity,
    this.price,
    this.thumbnailLabel,
    this.applicationWindow,
    this.childProducts,
    this.bundlePrice,
    this.overviewBenefits,
    this.activityId,
  });

  Product.fromJson(Map<String, dynamic> map)
      : applied = false,
        skipped = false,
        isArchived = false,
        isSubscribed = false,
        isAddedByMe = false,
        isRecommended = false,
        isAddOn = map['isAddOn'] ?? false,
        howToApply = map['how_to_use'],
        howOftenToApply = map['how_often_to_aply'],
        whenToApply = map['when_to_apply'],
        restrictions = map['mylawn_restrictions'],
        spreaderSetting = map['spreader_setting'],
        youtubeUrl = map['how_to_use_youtube'] != null
            ? (map['how_to_use_youtube'] as String).split('\n').first
            : null,
        name = (map['name'] ?? map['drupal_product_name'] ?? map['defaultName'])
            as String,
        sku = map['sku'] as String,
        applicationWindow = map['applicationWindow'] == null
            ? null
            : ProductApplicationWindow.fromJson(map['applicationWindow']),
        categoryList = map['mylawn_categories'] != null
            ? (map['mylawn_categories'] as List).map<String>((e) => e).toList()
            : null,
        description = map['description'] as String,
        overviewBenefits = map['overview_benefits'] as String,
        shortDescription = map['shortDescription'] as String,
        parentSku = (map['parentSku'] ?? map['drupalproductid']) as String,
        quantity = map['quantity'] as int,
        price = (map['price']) != null
            ? map['price'] is String
                ? double.tryParse(map['price'])
                : map['price'] as double
            : map['price_range'] != null
                ? map['price_range']['minimum_price']['regular_price']['value']
                : 0.0,
        coverageArea = map['coverage'] != null
            ? map['coverage'] is int
                ? map['coverage'] as int
                : (map['coverage'] as String).smallestCoverageArea
            : null,
        thumbnailLabel = map['thumbnailLabel'] as String,
        miniClaim1 = map['mylawn_mini_claim1_data'] != null &&
                map['mylawn_mini_claim1_data'] is String
            ? jsonDecode(map['mylawn_mini_claim1_data'])[0]
                ['mini_claim_description']
            : null,
        miniClaimImage1 = map['mylawn_mini_claim1_data'] != null &&
                map['mylawn_mini_claim1_data'] is String
            ? jsonDecode(map['mylawn_mini_claim1_data'])[0]['publicimagelink']
            : null,
        miniClaim2 = map['mylawn_mini_claim2_data'] != null &&
                map['mylawn_mini_claim2_data'] is String
            ? jsonDecode(map['mylawn_mini_claim2_data'])[0]
                ['mini_claim_description']
            : null,
        miniClaimImage2 = map['mylawn_mini_claim2_data'] != null &&
                map['mylawn_mini_claim2_data'] is String
            ? jsonDecode(map['mylawn_mini_claim2_data'])[0]['publicimagelink']
            : null,
        miniClaim3 = map['mylawn_mini_claim3_data'] != null &&
                map['mylawn_mini_claim3_data'] is String
            ? jsonDecode(map['mylawn_mini_claim3_data'])[0]
                ['mini_claim_description']
            : null,
        miniClaimImage3 = map['mylawn_mini_claim3_data'] != null &&
                map['mylawn_mini_claim3_data'] is String
            ? jsonDecode(map['mylawn_mini_claim3_data'])[0]['publicimagelink']
            : null,
        lawnCondition = map['mylawn_lawn_condition'].toString(),
        minTemp = map['mylawn_min_temp'],
        imageUrl = map['image'] != null
            ? map['image']['url'] ?? ''
            : map['thumbnailImage'] as String,
        maxTemp = map['mylawn_max_temp'],
        afterSeed = map['mylawn_after_seed'],
        killsWeedList = map['mylawn_weed_type'] != null
            ? (map['mylawn_weed_type'] as List).map<String>((e) => e).toList()
            : null,
        analysis = map['analysis'],
        disposalMethods = map['disposal_methods'],
        kidsAndPets = map['kids_pets'],
        cautions = map['precautions'],
        childProducts = List<Product>.from(
          map['childProducts']?.map(
                (product) => Product.fromJson(product),
              ) ??
              [],
        ),
        bundlePrice = 0.0,
        activityId = null;

  Product copyWithProduct(Product product) {
    return Product(
      applied: product.applied ?? applied,
      skipped: product.skipped ?? skipped,
      isAddOn: product.isAddOn ?? isAddOn,
      isArchived: product.isArchived ?? isArchived,
      isSubscribed: product.isSubscribed ?? isSubscribed,
      isAddedByMe: product.isAddedByMe ?? isAddedByMe,
      isRecommended: product.isRecommended ?? isRecommended,
      coverageArea: product.coverageArea ?? coverageArea,
      categoryList: product.categoryList ?? categoryList,
      name: product.name ?? name,
      description: product.description ?? description,
      shortDescription: product.shortDescription ?? shortDescription,
      sku: product.sku ?? sku,
      parentSku: product.parentSku ?? parentSku,
      miniClaim1: product.miniClaim1 ?? miniClaim1 ?? '',
      miniClaim2: product.miniClaim2 ?? miniClaim2 ?? '',
      miniClaim3: product.miniClaim3 ?? miniClaim3 ?? '',
      miniClaimImage1: product.miniClaimImage1 ?? miniClaimImage1 ?? '',
      miniClaimImage2: product.miniClaimImage2 ?? miniClaimImage2 ?? '',
      miniClaimImage3: product.miniClaimImage3 ?? miniClaimImage3 ?? '',
      lawnCondition: product.lawnCondition ?? lawnCondition,
      minTemp: product.minTemp ?? minTemp,
      maxTemp: product.maxTemp ?? maxTemp,
      afterSeed: product.afterSeed ?? afterSeed,
      quantity: product.quantity ?? quantity,
      price: product.price ?? price,
      imageUrl: product.imageUrl ?? imageUrl,
      youtubeUrl: product.youtubeUrl ?? youtubeUrl,
      thumbnailLabel: product.thumbnailLabel ?? thumbnailLabel,
      applicationWindow: product.applicationWindow ?? applicationWindow,
      kidsAndPets: product.kidsAndPets ?? kidsAndPets,
      killsWeedList: product.killsWeedList ?? killsWeedList,
      analysis: product.analysis ?? analysis,
      cautions: product.cautions ?? cautions,
      disposalMethods: product.disposalMethods ?? disposalMethods,
      howToApply: product.howToApply ?? howToApply,
      howOftenToApply: product.howOftenToApply ?? howOftenToApply,
      overviewBenefits: product.overviewBenefits ?? overviewBenefits,
      whenToApply: product.whenToApply ?? whenToApply,
      restrictions: product.restrictions ?? restrictions,
      spreaderSetting: product.spreaderSetting ?? spreaderSetting,
      childProducts: product.childProducts ?? childProducts,
      bundlePrice: product.bundlePrice ?? bundlePrice,
    );
  }

  Product fillFields(Product product) {
    return Product(
        name: name != null && name.isNotEmpty ? name : product.name,
        description: description != null && description.isNotEmpty
            ? description
            : product.description,
        shortDescription:
            shortDescription != null && shortDescription.isNotEmpty
                ? shortDescription
                : product.shortDescription,
        sku: sku != null && sku.isNotEmpty ? sku : product.sku,
        parentSku: parentSku != null && parentSku.isNotEmpty
            ? parentSku
            : product.parentSku,
        miniClaim1: miniClaim1 != null && miniClaim1.isNotEmpty
            ? miniClaim1
            : product.miniClaim1,
        miniClaim2: miniClaim2 != null && miniClaim2.isNotEmpty
            ? miniClaim2
            : product.miniClaim2,
        miniClaim3: miniClaim3 != null && miniClaim3.isNotEmpty
            ? miniClaim3
            : product.miniClaim3,
        miniClaimImage1: miniClaimImage1 != null && miniClaimImage1.isNotEmpty
            ? miniClaimImage1
            : product.miniClaimImage1,
        miniClaimImage2: miniClaimImage2 != null && miniClaimImage2.isNotEmpty
            ? miniClaimImage2
            : product.miniClaimImage2,
        miniClaimImage3: miniClaimImage3 != null && miniClaimImage3.isNotEmpty
            ? miniClaimImage3
            : product.miniClaimImage3,
        lawnCondition: lawnCondition != null && lawnCondition.isNotEmpty
            ? lawnCondition
            : product.lawnCondition,
        minTemp:
            minTemp != null && minTemp.isNotEmpty ? minTemp : product.minTemp,
        maxTemp:
            maxTemp != null && maxTemp.isNotEmpty ? maxTemp : product.maxTemp,
        afterSeed: afterSeed != null && afterSeed.isNotEmpty
            ? afterSeed
            : product.afterSeed,
        price: price ?? product.price,
        imageUrl: imageUrl != null && imageUrl.isNotEmpty
            ? imageUrl
            : product.imageUrl,
        youtubeUrl: youtubeUrl != null && youtubeUrl.isNotEmpty
            ? youtubeUrl
            : product.youtubeUrl,
        thumbnailLabel: thumbnailLabel != null && thumbnailLabel.isNotEmpty
            ? thumbnailLabel
            : product.thumbnailLabel,
        analysis: analysis != null && analysis.isNotEmpty
            ? analysis
            : product.analysis,
        disposalMethods: disposalMethods != null && disposalMethods.isNotEmpty
            ? disposalMethods
            : product.disposalMethods,
        kidsAndPets: kidsAndPets != null && kidsAndPets.isNotEmpty
            ? kidsAndPets
            : product.kidsAndPets,
        cautions: cautions != null && cautions.isNotEmpty
            ? cautions
            : product.cautions,
        howToApply: howToApply != null && howToApply.isNotEmpty
            ? howToApply
            : product.howToApply,
        howOftenToApply: howOftenToApply != null && howOftenToApply.isNotEmpty
            ? howOftenToApply
            : product.howOftenToApply,
        whenToApply: whenToApply != null && whenToApply.isNotEmpty
            ? whenToApply
            : product.whenToApply,
        overviewBenefits:
            overviewBenefits != null && overviewBenefits.isNotEmpty
                ? overviewBenefits
                : product.overviewBenefits,
        restrictions: restrictions != null && restrictions.isNotEmpty
            ? restrictions
            : product.restrictions,
        spreaderSetting: spreaderSetting != null && spreaderSetting.isNotEmpty
            ? spreaderSetting
            : product.spreaderSetting,
        applied: applied ?? product.applied,
        skipped: skipped ?? product.skipped,
        isAddOn: isAddOn ?? product.isAddOn,
        isArchived: isArchived ?? product.isArchived,
        isSubscribed: isSubscribed ?? product.isSubscribed,
        isAddedByMe: isAddedByMe ?? product.isAddedByMe,
        isRecommended: isRecommended ?? product.isRecommended,
        coverageArea: coverageArea ?? product.coverageArea,
        categoryList: categoryList ?? product.categoryList,
        quantity: quantity ?? product.quantity,
        applicationWindow: applicationWindow ?? product.applicationWindow,
        killsWeedList: killsWeedList ?? product.killsWeedList,
        childProducts: childProducts,
        bundlePrice: bundlePrice ?? product.bundlePrice);
  }

  Product copyWith({
    bool isRecommended,
    bool isAddOn,
    bool applied,
    bool skipped,
    bool isArchived,
    bool isSubscribed,
    bool isAddedByMe,
    int coverageArea,
    String name,
    String approvedName,
    String description,
    String shortDescription,
    String sku,
    String parentSku,
    String miniClaim1,
    String miniClaim2,
    String miniClaim3,
    String miniClaimImage1,
    String miniClaimImage2,
    String miniClaimImage3,
    String lawnCondition,
    String minTemp,
    String maxTemp,
    String afterSeed,
    int quantity,
    double price,
    String imageUrl,
    String youtubeUrl,
    String thumbnailLabel,
    ProductApplicationWindow applicationWindow,
    List<Product> childProducts,
    double bundlePrice,
    List<String> categoryList,
    List<String> killsWeedList,
    String analysis,
    String disposalMethods,
    String kidsAndPets,
    String cautions,
    String howToApply,
    String howOftenToApply,
    String whenToApply,
    String overviewBenefits,
    String restrictions,
    String spreaderSetting,
    String activityId,
  }) {
    return Product(
      applied: applied ?? this.applied,
      skipped: skipped ?? this.skipped,
      isArchived: isArchived ?? this.isArchived,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isAddedByMe: isAddedByMe ?? this.isAddedByMe,
      isRecommended: isRecommended ?? this.isRecommended,
      isAddOn: isAddOn ?? this.isAddOn,
      coverageArea: coverageArea ?? this.coverageArea,
      categoryList: categoryList ?? this.categoryList,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      sku: sku ?? this.sku,
      parentSku: parentSku ?? this.parentSku,
      miniClaim1: miniClaim1 ?? this.miniClaim1 ?? '',
      miniClaim2: miniClaim2 ?? this.miniClaim2 ?? '',
      miniClaim3: miniClaim3 ?? this.miniClaim3 ?? '',
      miniClaimImage1: miniClaimImage1 ?? this.miniClaimImage1 ?? '',
      miniClaimImage2: miniClaimImage2 ?? this.miniClaimImage2 ?? '',
      miniClaimImage3: miniClaimImage3 ?? this.miniClaimImage3 ?? '',
      afterSeed: afterSeed ?? this.afterSeed,
      lawnCondition: lawnCondition ?? this.lawnCondition,
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      thumbnailLabel: thumbnailLabel ?? this.thumbnailLabel,
      applicationWindow: applicationWindow ?? this.applicationWindow,
      kidsAndPets: kidsAndPets ?? this.kidsAndPets,
      killsWeedList: killsWeedList ?? this.killsWeedList,
      analysis: analysis ?? this.analysis,
      cautions: cautions ?? this.cautions,
      disposalMethods: disposalMethods ?? this.disposalMethods,
      howToApply: howToApply ?? this.howToApply,
      howOftenToApply: howOftenToApply ?? this.howOftenToApply,
      whenToApply: whenToApply ?? this.whenToApply,
      overviewBenefits: overviewBenefits ?? this.overviewBenefits,
      restrictions: restrictions ?? this.restrictions,
      spreaderSetting: spreaderSetting ?? this.spreaderSetting,
      childProducts: childProducts ?? this.childProducts,
      bundlePrice: bundlePrice ?? this.bundlePrice,
      activityId: activityId ?? this.activityId,
    );
  }
}

class ProductApplicationWindow {
  final String season;
  final String seasonSlug;
  final int startingWeekNumber;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime shipStartDate;
  final DateTime shipEndDate;

  ProductApplicationWindow({
    this.season,
    this.seasonSlug,
    this.startingWeekNumber,
    this.startDate,
    this.endDate,
    this.shipStartDate,
    this.shipEndDate,
  });

  ProductApplicationWindow.fromJson(Map<String, dynamic> map)
      : season = map['season'] as String,
        seasonSlug = map['seasonSlug'] as String,
        startingWeekNumber = map['startingWeekNumber'] as int,
        startDate = DateTime.parse(map['startDate']),
        endDate = DateTime.parse(map['endDate']),
        shipStartDate = DateTime.parse(map['shipStartDate']),
        shipEndDate = DateTime.parse(map['shipEndDate']);
}

class ProductRecommendedResponse {
  final List<Product> products;
  final List<Product> addOnProducts;

  ProductRecommendedResponse({
    this.products,
    this.addOnProducts,
  });

  factory ProductRecommendedResponse.fromJson(Map<String, dynamic> json) {
    final map = json['products'];
    final products = List<Product>.from(
          map?.map(
                (x) => Product.fromJson(x),
              ) ??
              [],
        ),
        addOnProducts = List<Product>.from(
          json['addOnProducts']?.map(
                (product) => Product.fromJson(product),
              ) ??
              [],
        );
    return ProductRecommendedResponse(
        products: products, addOnProducts: addOnProducts);
  }
}

class ProductResponse {
  final List<Product> products;

  ProductResponse({
    this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final map = json['products'];
    final products = List<Product>.from(
      map['items'].map(
            (x) => Product.fromJson(x),
          ) ??
          [],
    );
    return ProductResponse(products: products);
  }
}

class GetRecommondedProducts {
  final subscriptionCardProductDetails =
  List.generate(4, (i) => List(8), growable: false);
  final addonsList = List.generate(5, (i) => List(2), growable: false);

  factory GetRecommondedProducts() => GetRecommondedProducts._internal();
    GetRecommondedProducts._internal();

    ProductRecommendedResponse productRecommendations;
    ProductResponse products;
    String error;

  // get product recommendation
  Future<void> getProductsRecommended() async {
    final headers = {
      'content-type': 'application/json',
      'x-apikey': '66uDJB56vxrn21s20bIRV4:5Tbtvh57snQ864pkNs1oIG',
      'Accept': 'application/json',
      'Cookie': 'private_content_version=7191642bc3ed7ee429ea856e499bcfa8'
    };
    final request = http.Request(
        'POST',
        Uri.parse(
            'https://rc.api.scotts.com/recommendations/v1/productRecommendations'));
    request.body =
        '''{"databaseVersion":"v1","lawnThickness":"SomeGrass","lawnColor":"MostlyGreen","lawnWeeds":"NoWeeds","lawnSpreader":"NoSpreader","lawnArea":25,"zipCode":"43203","lawnZone":"9","grassType":"BER","source":"scottsprogram.com","sourceService":"LS","transId":"97317d7e-ebeb-4ae4-aa0c-717ddfa884c3"}''';
    request.headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 201) {
      productRecommendations = ProductRecommendedResponse.fromJson(
          jsonDecode(await response.stream.bytesToString())['plan']);
    } else {
      error ??= 'something went wrong';
    }
  }

  // get product graphql
  Future<void> getProducts() async {
    final lSkus = <String>[];
    for (var items in productRecommendations.products) {
      for (var item in items.childProducts) {
        lSkus.add(item.sku);
      }
    }
    final headers = {
      'content-type': 'application/json',
      'x-apikey': '66uDJB56vxrn21s20bIRV4:5Tbtvh57snQ864pkNs1oIG',
      'Accept': 'application/json',
      'Cookie': 'private_content_version=767362b69095625bfa916f061dde6a76'
    };
    final response = await http.post(
      'https://rc.api.scotts.com/products/v1/graphql',
      body: jsonEncode({
        'operationName': 'GetProductsBySku',
        'variables': {
          'lSkus': lSkus,
        },
        'query':
            'query GetProductsBySku(\$lSkus: [String!]) {\n  products(filter: {sku: {in: \$lSkus}}) {\n    total_count\n    items {\n      drupal_product_name\n      sku\n      drupalproductid\n      product_id\n      mylawn_mini_claim1_data\n      mylawn_mini_claim2_data\n      mylawn_mini_claim3_data\n      mylawn_categories\n      problems_filter\n      goals_filter\n      mylawn_sunlight\n      mylawn_weed_type\n      mylawn_grass_types\n      mylawn_usage_per_year\n      mylawn_min_temp\n      mylawn_max_temp\n      mylawn_lawn_condition\n      mylawn_after_seed\n      disposal_methods\n      how_to_use\n      how_often_to_aply\n      when_to_apply\n      mylawn_lawn_zone\n      mylawn_product_color\n      mylawn_restrictions\n      drupal_scotts_short_description\n      coverage_area\n      coverage\n      what_it_controls\n      overview_benefits\n      spreader_setting\n      analysis\n      kids_pets\n      precautions\n      how_to_use_youtube\n      image {\n        url\n      }\n      price_range {\n        minimum_price {\n          regular_price {\n            value\n            currency\n          }\n        }\n      }\n    }\n  }\n}',
      }),
      headers: headers,
    );

    if (response.statusCode == 200) {
      products =
          ProductResponse.fromJson(jsonDecode(await response.body)['data']);
    } else {
      error ??= 'something went wrong';
    }
  }

  Future<void> setProductsData() async {
    if (productRecommendations == null) {
      await getProductsRecommended();
    }

    if (products == null) {
      await getProducts();
    }

    products.products
        .insert(1, products.products[2]);
    for (var i = 0; i < 4; i++) {
      if (i == 3) {
        final product = products.products[0];
        subscriptionCardProductDetails[i][0] = product.name;
        subscriptionCardProductDetails[i][1] = false;
        subscriptionCardProductDetails[i][2] = '\u00D7\u200A' '1';
        if (product.coverageArea == 5000) {
          subscriptionCardProductDetails[i][3] = '5K sqft';
        } else if (product.coverageArea == 4000) {
          subscriptionCardProductDetails[i][3] = '4K sqft';
        }
        subscriptionCardProductDetails[i][4] = '\$' + product.price.toString();
        subscriptionCardProductDetails[i][5] = <String>[]
          ..add(product.miniClaim1)
          ..add(product.miniClaim2)
          ..add(product.miniClaim3);
        subscriptionCardProductDetails[i][6] = null;
        subscriptionCardProductDetails[i][7] = null;

      } else {
        final product = products.products[i];
        subscriptionCardProductDetails[i][0] = product.name;
        if (i == 0) {
          subscriptionCardProductDetails[i][1] = true;
        } else {
          subscriptionCardProductDetails[i][1] = false;
        }
        subscriptionCardProductDetails[i][2] = '\u00D7\u200A' '1';
        if (product.coverageArea == 5000) {
          subscriptionCardProductDetails[i][3] = '5K sqft';
        } else if (product.coverageArea == 4000) {
          subscriptionCardProductDetails[i][3] = '4K sqft';
        }
        subscriptionCardProductDetails[i][4] = '\$' + product.price.toString();
        subscriptionCardProductDetails[i][5] = <String>[]
          ..add(product.miniClaim1)
          ..add(product.miniClaim2)
          ..add(product.miniClaim3);
        subscriptionCardProductDetails[i][6] = null;
        subscriptionCardProductDetails[i][7] = null;
      }
    }

    for (var i = 0; i < productRecommendations.addOnProducts.length; i++) {
      addonsList[i][0] =
          productRecommendations.addOnProducts[i].name;
      addonsList[i][1] = '\$' +
          productRecommendations.addOnProducts[i].childProducts[0].price
              .toString();
    }
  }
}
