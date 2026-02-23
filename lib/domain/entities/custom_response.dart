enum CustomResponseStatus {
  ok(200),
  badRequest(400),
  notFound(404),
  tooManyRequests(429),
  serverError(500),
  unknown(-1);

  const CustomResponseStatus(this.code);

  final int code;

  bool get isSuccess => this == CustomResponseStatus.ok;

  static CustomResponseStatus fromCode(int? code) {
    switch (code) {
      case 200:
        return CustomResponseStatus.ok;
      case 400:
        return CustomResponseStatus.badRequest;
      case 404:
        return CustomResponseStatus.notFound;
      case 429:
        return CustomResponseStatus.tooManyRequests;
      case 500:
        return CustomResponseStatus.serverError;
      default:
        return CustomResponseStatus.unknown;
    }
  }
}

class CustomResponse<T> {
  const CustomResponse({required this.status, this.data});

  const CustomResponse.success(this.data) : status = CustomResponseStatus.ok;

  final CustomResponseStatus status;
  final T? data;

  bool get isSuccess => status.isSuccess;
}
