import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/cubit/global_state.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    if (!sl.isRegistered<CacheHelper>()) {
      initServiceLocator();
    }
    await sl<CacheHelper>().init();
  });

  testWidgets('provides global cubit data to descendants',
      (WidgetTester tester) async {
    final globalCubit = sl<GlobalCubit>()..init();

    await tester.pumpWidget(
      BlocProvider.value(
        value: globalCubit,
        child: BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, state) {
            final currencyIcon = context.read<GlobalCubit>().currencyIconAsset;
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text(currencyIcon)),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text('assets/images/svg/currancy.svg'), findsOneWidget);
  });
}
