import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injector.dart' show sl;
import 'page_state/home/home_bloc.dart';
import 'resources/theme.dart';
import 'routes/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              HomeBloc(sl(), sl(), sl(), sl(), sl())
                ..add(const ReadSavedData()),
        ),
      ],
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (p, c) => p.themeMode != c.themeMode,
          builder: (context, state) => MaterialApp.router(
            title: 'Timedoor Test',
            routerConfig: router,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
          ),
        ),
      ),
    );
  }
}
