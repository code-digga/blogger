import 'dart:developer';
import 'dart:io';

import 'package:blogger/utils/mixins/graphql_config.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../models/network_response_model.dart';

class DataProvider {
  final _graphQlHandler = GraphqlHandler();
  Future<NetworkResponseModel?> query(
      {String queryString = '',
      Map<String, dynamic> queryVariables = const {}}) async {
    NetworkResponseModel? response;

    try {
      var initialResult = await _graphQlHandler.makeQuery(
          queryString: queryString, queryVariables: queryVariables);
      if (initialResult.hasException) {
        throw initialResult.exception as OperationException;
      } else {
        response = NetworkResponseModel(
            errorOccured: false,
            requestedData: initialResult.data,
            responseMsg: '');
      }
    } catch (e, s) {
      response = await errorHandler(e);
      log("============> query error: ${e.toString()}");
      debugPrintStack(stackTrace: s);
    }

    return response;
  }

  Future<NetworkResponseModel?> mutate(
      {String mutString = '',
      Map<String, dynamic> mutVariables = const {}}) async {
    NetworkResponseModel? response;

    try {
      var initialResult = await _graphQlHandler.makeMutation(
          mutString: mutString, mutVariables: mutVariables);
      if (initialResult.hasException) {
        throw initialResult.exception as OperationException;
      } else {
        response = NetworkResponseModel(
            errorOccured: false,
            requestedData: initialResult.data,
            responseMsg: '');
      }
    } catch (e, s) {
      response = await errorHandler(e);
      log("============> mutate error: ${e.toString()}");
      debugPrintStack(stackTrace: s);
    }

    return response;
  }

  ///we are using this function to centralize error handling
  ///
  ///rather than handle error in try-catch blocks to avoid duplications.
  Future<NetworkResponseModel> errorHandler(Object err) async {
    var errorResponse = NetworkResponseModel(
        errorOccured: true, requestedData: null, responseMsg: '');

    if (err is SocketException) {
      errorResponse.responseMsg = 'Check your internet connection';
    } else if (err is OperationException) {
      /// if the error is an operation exception, we are trying to prioritize
      ///
      /// handling link exceptions before the graphql exceptions if any.
      if (err.linkException != null) {
        errorResponse.responseMsg =
            err.linkException?.originalException.toString() ?? '';
      } else {
        errorResponse.responseMsg = err.graphqlErrors.first.message;
      }
    } else {
      errorResponse.responseMsg = err.toString();
    }
    return errorResponse;
  }
}
