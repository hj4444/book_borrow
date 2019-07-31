import 'package:book_shelf/event/http_error_event.dart';
import 'package:event_bus/event_bus.dart';

class ApiCode {
  static const NETWORK_ERROR = -1;
  static const NETWORK_TIMEOUT = -2;
  static const NETWORK_JSON_EXCEPTION = -3;
  static const SUCCESS = 0;
  static final EventBus eventBus = new EventBus();

  static errorHandleFunction(code, message) {
    eventBus.fire(new HttpErrorEvent(code, message));
    return message;
  }
}
