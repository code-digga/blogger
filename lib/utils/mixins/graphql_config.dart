import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';

class GraphqlHandler {
  /// For simplicity, we hard code the endpoint url
  ///
  /// to improve security, we can make this a dart environment variable instead
  final _baseUrl = HttpLink('https://uat-api.vmodel.app/graphql/');

  Future<HiveStore> _fetchStore() async {
    var dirPath = await getApplicationDocumentsDirectory();
    return HiveStore.open(path: dirPath.path);
  }

  Future<GraphQLClient> _fetchClient() async {
    var customStore = await _fetchStore();
    var client =
        GraphQLClient(link: _baseUrl, cache: GraphQLCache(store: customStore));

    return client;
  }

  Future<QueryResult> makeQuery(
      {String queryString = '',
      Map<String, dynamic> queryVariables = const {}}) async {
    var client = await _fetchClient();
    var options = QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(queryString),
        variables: {...queryVariables});

    return client.query(options);
  }

  Future<QueryResult> makeMutation(
      {String mutString = '',
      Map<String, dynamic> mutVariables = const {}}) async {
    var client = await _fetchClient();
    var options =
        MutationOptions(document: gql(mutString), variables: {...mutVariables});

    return client.mutate(options);
  }
}
