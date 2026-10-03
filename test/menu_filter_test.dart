import 'package:combobox_desktop/combobox_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Party {
  const _Party(this.name, this.alias);

  final String name;
  final String alias;
}

void main() {
  const List<_Party> parties = [
    _Party('Shree Ganesh Traders', 'SGT'),
    _Party('Kotak Mahindra Bank', 'KMB'),
  ];

  /// Types [query] into a combobox over [parties] and returns the names the
  /// menu goes on to offer. [searchTerms] is passed through untouched, so
  /// omitting it exercises the widget's default.
  Future<List<String>> namesOfferedFor(
    WidgetTester tester,
    String query, {
    ComboboxItemSearchTerms<_Party>? searchTerms,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 260,
              child: ComboboxDesktop<_Party>(
                items: parties.map((p) => ComboboxItem<_Party>(value: p)).toList(),
                value: null,
                onChanged: (_) {},
                stringifier: (party) => party.name,
                searchTerms: searchTerms,
                fieldDecoration: const ComboboxFieldDecoration(height: 35),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    await tester.enterText(find.byType(EditableText), query);
    // The menu is an overlay the filter measures and rebuilds over several
    // frames; pumpAndSettle never returns because the cursor keeps blinking.
    for (int frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    return tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data ?? '')
        .where((label) => parties.any((party) => party.name == label))
        .toList();
  }

  group('filtering the menu', () {
    testWidgets('matches the displayed text when no search terms are given',
        (tester) async {
      expect(await namesOfferedFor(tester, 'kotak'), ['Kotak Mahindra Bank']);
    });

    testWidgets('matches a search term the menu does not display', (tester) async {
      expect(
        await namesOfferedFor(
          tester,
          'SGT',
          searchTerms: (party) => [party.name, party.alias],
        ),
        ['Shree Ganesh Traders'],
      );
    });

    testWidgets('offers an item once when the query matches two of its terms',
        (tester) async {
      expect(
        await namesOfferedFor(
          tester,
          'kotak',
          searchTerms: (party) => [party.name, party.name.split(' ').first],
        ),
        ['Kotak Mahindra Bank'],
      );
    });

    testWidgets('does not match a query spanning two search terms', (tester) async {
      expect(
        await namesOfferedFor(
          tester,
          'Traders SGT',
          searchTerms: (party) => [party.name, party.alias],
        ),
        isEmpty,
      );
    });
  });
}
