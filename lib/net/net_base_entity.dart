class NetBaseEntity<T> {
  int code;
  String message;
  T data;

  NetBaseEntity(this.code, this.message, this.data);
}