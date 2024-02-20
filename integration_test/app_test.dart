import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:task_management/main.dart' as main_app;
import 'package:task_management/passcode/passcode_page.dart';
import 'package:task_management/task_management/task_management_page.dart';
import 'package:task_management/task_management/views/doing_view.dart';
import 'package:task_management/task_management/views/done_view.dart';
import 'package:task_management/task_management/views/todo_view.dart';
import 'package:task_management/task_management/widgets/task_management_list_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end to end test', () {
    testWidgets(
      'passcode page with correct passcode',
      (tester) async {
        await tester.pumpApp();
        expect(find.byType(PasscodePage), findsOneWidget);
        await tester.enterCorrectPasscode();
        expect(find.byType(TaskManagementPage), findsOneWidget);
        await tester.swipeToDelete();
        await tester.scrollDownToLoadMore();
        await tester.selectDoingTab();
        await tester.selectDoneTab();
        await tester.selectTodoTab();
      },
    );

    testWidgets(
      'passcode page with wrong passcode',
      (tester) async {
        await tester.pumpApp();
        expect(find.byType(PasscodePage), findsOneWidget);
        await tester.enterWrongPasscode();
        expect(find.byType(TaskManagementPage), findsNothing);
        expect(find.byType(PasscodePage), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpApp() async {
    main_app.main();
    await pumpAndSettle();
  }

  Future<void> enterCorrectPasscode() async {
    await tap(find.byKey(const Key("1")));
    await tap(find.byKey(const Key("2")));
    await tap(find.byKey(const Key("3")));
    await tap(find.byKey(const Key("4")));
    await tap(find.byKey(const Key("5")));
    await tap(find.byKey(const Key("6")));

    await pumpAndSettle();
  }

  Future<void> enterWrongPasscode() async {
    await tap(find.byKey(const Key("1")));
    await tap(find.byKey(const Key("2")));
    await tap(find.byKey(const Key("3")));
    await tap(find.byKey(const Key("4")));
    await tap(find.byKey(const Key("5")));
    await tap(find.byKey(const Key("7")));

    await pump();
  }

  Future<void> swipeToDelete() async {
    final test = find.byType(Dismissible).first;
    await drag(test, const Offset(-500, 0));
    await pumpAndSettle();
  }

  Future<void> scrollDownToLoadMore() async {
    await drag(
        find.byType(TaskManagementListView).first, const Offset(0, -500));
    await pumpAndSettle();
  }

  Future<void> selectTodoTab() async {
    await tap(find.byKey(const Key('todo-tab')));
    await pumpAndSettle();
    expect(find.byType(TodoView), findsOneWidget);
  }

  Future<void> selectDoingTab() async {
    await tap(find.byKey(const Key('doing-tab')));
    await pumpAndSettle();
    expect(find.byType(DoingView), findsOneWidget);
  }

  Future<void> selectDoneTab() async {
    await tap(find.byKey(const Key('done-tab')));
    await pumpAndSettle();
    expect(find.byType(DoneView), findsOneWidget);
  }
}
