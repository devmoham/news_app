sealed class ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.error(String message) = Error<T>;
}

class Success<T> implements ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Error<T> implements ApiResult<T> {
  final String message;
  const Error(this.message);
}
