import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log("observer$change");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log("observer$transition");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('${bloc.runtimeType} $error $stackTrace');
  }
}
