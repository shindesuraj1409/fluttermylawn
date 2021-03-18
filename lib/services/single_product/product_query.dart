const String productQuery = r'''
 query GetProductsByCategory($category: String!,$code: String!)
  {
  customAttributeFilter(
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
      sku
    }
  }
}
''';
