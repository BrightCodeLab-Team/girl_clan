// import 'package:flutter/foundation.dart';
// import 'package:girl_clan/core/enums/view_state_model.dart';

// ///
// /// [BaseViewModel] is the base class with all
// /// state related logic.
// ///
// /// [BaseViewModel] class will be extended by all viewModels.
// ///
// /// [setState] will be used to update the state of the screen
// ///
// class BaseViewModel extends ChangeNotifier {
//   ViewState _state = ViewState.idle;

//   ViewState get state => _state;

//   void setState(ViewState state) {
//     _state = state;
//     notifyListeners();
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  bool _disposed = false;

  ViewState get state => _state;

  void setState(ViewState state) {
    if (_disposed) return;
    _state = state;
    _safeNotify();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Helper method for child view models
  Future<void> runAsyncOperation(Future Function() operation) async {
    setState(ViewState.busy);
    try {
      await operation();
    } finally {
      if (!_disposed) {
        setState(ViewState.idle);
      }
    }
  }
}
