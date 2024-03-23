class ResponseObject {
  final bool isSuccess;
  final int statusCode;
  final dynamic responsBody;
  final String? errorMessage;

  ResponseObject({
    required this.isSuccess,
    required this.statusCode,
    required this.responsBody,
    this.errorMessage = "",
  });
}
