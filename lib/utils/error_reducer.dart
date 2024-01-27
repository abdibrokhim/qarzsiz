import 'package:redux/redux.dart';

class GenericErrorState {
  final bool isLoading;
  final List<String> errors;

  GenericErrorState({
    this.isLoading = false,
    this.errors = const [],
  });

  GenericErrorState copyWith({
    bool? isLoading,
    List<String>? errors,
  }) {
    return GenericErrorState(
      isLoading: isLoading ?? this.isLoading,
      errors: errors ?? this.errors,
    );
  }
}



// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {
  final String errorMessage;
  
  HandleGenericErrorAction(this.errorMessage);
}

GenericErrorState handleGenericErrorReducer(
    GenericErrorState state, HandleGenericErrorAction action) {
  return state.copyWith(
    isLoading: false,
    errors: [...state.errors, action.errorMessage],
  );
}


// ========== Clear Generic Error ========== //

class ClearGenericErrorAction {
  ClearGenericErrorAction();
}

GenericErrorState clearGenericErrorReducer(
    GenericErrorState state, ClearGenericErrorAction action) {
  return state.copyWith(
    errors: [],
  );
}


// ========== Combine all reducers ========== //

Reducer<GenericErrorState> profileScreenReducer = combineReducers<GenericErrorState>([
  TypedReducer<GenericErrorState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<GenericErrorState, ClearGenericErrorAction>(clearGenericErrorReducer),
]);