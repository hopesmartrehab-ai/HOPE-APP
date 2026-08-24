import 'package:bloc/bloc.dart';
import 'package:tara_car/core/resources/debug_print.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    printDebug(message: 'Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    printDebug(
      message:
          'Bloc change in ${bloc.runtimeType}: ${change.currentState} -> ${change.nextState}',
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    printDebug(message: 'Bloc closed: ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    printDebug(
      message: 'Bloc error in ${bloc.runtimeType}: $error',
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
