const String getProductsQueryForSearch = r'''
  query GetSearchProducts($searchString: String!){
    products(search: $searchString) {
    items {
        drupal_product_name
        defaultName: name
        sku
        drupalproductid
        product_id
        image {
          url
        }
    }
  }
}''';
