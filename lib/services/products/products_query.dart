String productsQuery(List<String> productList) {
  final buffer = StringBuffer();

  buffer.write(
      ''' {customAttributeFilter( filter_type: "matches-any", attributes: [{ attribute_code: "sku", options: [ ''');

  for (var product in productList) {
    buffer.write(' {attribute_option_code: "$product"},');
  }

  buffer.write(']}])');

  buffer.write('''{
      items {
        drupal_product_name
        defaultName: name
        sku
        drupalproductid
        product_id
        mylawn_mini_claim1_data
        mylawn_mini_claim2_data
        mylawn_mini_claim3_data
        mylawn_categories
        problems_filter
        goals_filter
        mylawn_sunlight
        mylawn_weed_type
        mylawn_grass_types
        mylawn_usage_per_year
        mylawn_min_temp
        mylawn_max_temp
        mylawn_lawn_condition
        mylawn_after_seed
        disposal_methods
        how_to_use
        how_often_to_aply
        when_to_apply
        mylawn_lawn_zone
        mylawn_product_color
        mylawn_restrictions
        drupal_scotts_short_description
        coverage_area
        coverage
        what_it_controls
        overview_benefits
        spreader_setting
        analysis
        kids_pets
        precautions
        how_to_use_youtube
        image{
            url
        }
      price_range {
        minimum_price {
          regular_price {
            value
            currency
          }
        }
      }
    }   
  }
}''');
  return buffer.toString();
}
