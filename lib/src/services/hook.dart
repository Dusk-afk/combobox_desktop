/// A hook is a collection of callbacks that are called when an event occurs.
///
/// This provides an easy way to add/remove listeners to a class.
///
/// [T] is the type of the callback.
class Hook<T extends Function> {
  final List<T> _callbacks = [];

  /// Adds a callback to the hook.
  void add(T callback) {
    _callbacks.add(callback);
  }

  /// Removes a callback from the hook.
  void remove(T callback) {
    _callbacks.remove(callback);
  }

  /// Calls all the callbacks in the hook.
  void call([void Function(T callback)? caller]) {
    for (final callback in _callbacks) {
      if (caller == null) {
        callback();
      } else {
        caller(callback);
      }
    }
  }
}
