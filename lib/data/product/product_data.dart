import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/extensions/string_extensions.dart';

class Product extends Equatable {
  final String name;
  final String description;
  final String shortDescription;
  final String sku;
  final String parentSku;
  final Color color;
  final bool applied;
  final DateTime completedDate;
  final String activityId;

  //TODO: should this be stored in shared prefs and sent to an api??
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
    this.color,
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
    this.completedDate,
  });

  Product.fromJson(Map<String, dynamic> map)
      : applied = false,
        skipped = false,
        isArchived = false,
        isSubscribed = false,
        isAddedByMe = false,
        isRecommended = false,
        isAddOn = map['isAddOn'] ?? false,
        completedDate = null,
        howToApply = map['how_to_use'],
        howOftenToApply = map['how_often_to_aply'],
        whenToApply = map['when_to_apply'],
        restrictions = map['mylawn_restrictions'],
        spreaderSetting = map['spreader_setting'],
        youtubeUrl = (map['how_to_use_youtube'] as String).youtubeLink,
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
        price = map['price'] is String
            ? double.tryParse(map['price'])
            : map['price'] as double,
        coverageArea = map['coverage'] != null
            ? map['coverage'] is int
                ? map['coverage'] as int
                : (map['coverage'] as String).smallestCoverageArea
            : null,
        thumbnailLabel = map['thumbnailLabel'] as String,
        color = map['mylawn_product_color'] != null
            ? Color(
                int.parse(map['mylawn_product_color'], radix: 16) + 0xFF000000)
            : null,
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
      color: product.color ?? color,
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
      completedDate: product.completedDate ?? completedDate,
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
        color: color ?? product.color,
        quantity: quantity ?? product.quantity,
        applicationWindow: applicationWindow ?? product.applicationWindow,
        completedDate: completedDate ?? product.completedDate,
        killsWeedList: killsWeedList ?? product.killsWeedList,
        childProducts: childProducts,
        bundlePrice: bundlePrice ?? product.bundlePrice);
  }

  //TODO: Remove
  @override
  String toString() {
    return 'Product {id: $sku,name: $name, price: $price , child :$childProducts}';
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
    Color color,
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
    DateTime completedDate,
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
      color: color ?? this.color,
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
      completedDate: completedDate ?? this.completedDate,
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

  @override
  List<Object> get props => [
        applied,
        skipped,
        isArchived,
        isSubscribed,
        isAddedByMe,
        isRecommended,
        isAddOn,
        coverageArea,
        categoryList,
        color,
        name,
        description,
        shortDescription,
        sku,
        parentSku,
        miniClaim1,
        miniClaim2,
        miniClaim3,
        miniClaimImage1,
        miniClaimImage2,
        miniClaimImage3,
        afterSeed,
        lawnCondition,
        maxTemp,
        minTemp,
        quantity,
        price,
        imageUrl,
        youtubeUrl,
        thumbnailLabel,
        applicationWindow,
        completedDate,
        kidsAndPets,
        killsWeedList,
        analysis,
        cautions,
        disposalMethods,
        howToApply,
        howOftenToApply,
        whenToApply,
        overviewBenefits,
        restrictions,
        spreaderSetting,
        childProducts,
        bundlePrice,
      ];

  factory Product.fromActivity(ActivityData activity) {
    final product = activity.childProducts.first;

    return product.copyWith(
      parentSku: activity.productId,
      applicationWindow: activity.applicationWindow,
      childProducts: activity.childProducts,
      applied: activity.applied,
      skipped: activity.skipped,
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

class ProductResponse {
  final List<Product> products;

  ProductResponse({
    this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final map = json['products'] ?? json['customAttributeFilter'];
    final products = List<Product>.from(
      map['items']?.map(
            (x) => Product.fromJson(x),
          ) ??
          [],
    );
    return ProductResponse(products: products);
  }
}

class ProductFromCategoryResponse {
  final List<Product> products;

  ProductFromCategoryResponse({
    this.products,
  });

  factory ProductFromCategoryResponse.fromJson(Map<String, dynamic> json) {
    final productsResponse = List<Product>.from(
      json['customAttributeFilter']['items']?.map(
            (x) => Product.fromJson(x),
          ) ??
          [],
    );

    final products = <Product>[];
    for (var product in productsResponse) {
      if (product.parentSku != null &&
          products.map((e) => e.parentSku).contains(product.parentSku)) {
        products[products.indexWhere(
                (element) => element.parentSku == product.parentSku)]
            .childProducts
            .add(product);
      } else {
        product = product.copyWith(childProducts: [product]);
        products.add(product);
      }
    }

    return ProductFromCategoryResponse(products: products);
  }
}
