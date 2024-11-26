enum ResultState { SUCCESS, ERROR, LOADING,INITIAL }

class Result<T> {
  final ResultState state;
  final T? data;
  final String? message;


  Result({required this.state,this.data, this.message,});

  // Factory method for loading state
  factory Result.loading() {
    return Result( state: ResultState.LOADING);
  }

  factory Result.initial(){
    return Result(state: ResultState.INITIAL);
  }
  // Factory method for success state
  factory Result.success(T data) {
    return Result(state: ResultState.SUCCESS, data: data);
  }

  // Factory method for error state
  factory Result.error(String message) {
    return Result(state: ResultState.ERROR, message: message);
  }
}