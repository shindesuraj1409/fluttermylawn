import 'dart:async';

import 'package:graphql/src/core/query_result.dart';
import 'package:graphql/src/graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:my_lawn/services/graphql/graphql_http_logger.dart';
import 'package:my_lawn/services/graphql/i_graphql_repository.dart';

class GraphQLCli extends GraphQLClient {
  final String uri;
  GraphQLCli(String apiKey, String cookie, String uri)
      : uri = uri,
        super(
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
          link: HttpLink(
            httpClient: LoggerHttpClient(Client()),
            headers: {
              'x-apikey': apiKey,
              'Content-Type': 'application/json',
              'Cookie': cookie,
              'Store': 'scotts_view'
            },
            uri: uri,
          ),
        );
}

class GraphQlRepositoryImpl implements GraphQlRepository {
  final GraphQLCli _client;

  factory GraphQlRepositoryImpl(
    String apiKey,
    String host, {
    String cookie = 'private_content_version=2df0231d11b9f53b5edd6d54b8eda49e',
  }) {
    final client =
        GraphQLCli(apiKey, cookie, 'https://$host/products/v1/graphql');
    return GraphQlRepositoryImpl._(client);
  }

  GraphQlRepositoryImpl._(this._client);

  @override
  Future<QueryResult> makeQuery(String query,
      {Map<String, dynamic> variables}) async {
    return await _client
        .query(QueryOptions(documentNode: gql(query), variables: variables));
  }
}
