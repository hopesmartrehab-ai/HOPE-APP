part of 'theme_cubit.dart';

@immutable
sealed class ThemeState extends Equatable {

  final ThemeMode themeMode; 
  
  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial(super.themeMode);
}

final class ThemeChanged extends ThemeState {
  const ThemeChanged(super.themeMode);
}