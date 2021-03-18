import 'package:graphql_flutter/graphql_flutter.dart';

abstract class GraphQlRepository {
  Future<QueryResult> makeQuery(String query, {Map<String, dynamic> variables});
}
