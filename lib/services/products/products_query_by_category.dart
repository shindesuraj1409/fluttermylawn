const String productsQueryByCategories = r'''
 query GetProductsByCategory($category: String!,$code: String!)
  {
  customAttributeFilter(
    filter_type: "matches-all",
    attributes: [{
        attribute_code: $code,
        options: [{
            attribute_option_code: $category
        }]
    }]
  ) 
   {
    items {
      drupal_product_name
      defaultName: name
      drupalproductid
      sku
      mylawn_categories
      mylawn_lawn_condition
      problems_filter
      goals_filter
      image {
        url
      }
    }
  }
}
''';
