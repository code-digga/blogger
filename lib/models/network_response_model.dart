class NetworkResponseModel {
  bool errorOccured;
  dynamic requestedData;
  String responseMsg;
  NetworkResponseModel({
    required this.errorOccured,
    required this.requestedData,
    required this.responseMsg,
  });

  @override
  String toString() =>
      'NetworkResponseModel(errorOccured: $errorOccured, requestedData: $requestedData, responseMsg: $responseMsg)';
}
