import 'package:bloc_test/bloc_test.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_state.dart';
import 'package:my_lawn/data/tips/filter_data.dart';
import 'package:test/test.dart';

void main() {
  group('', () {
    TipsFilterBloc tipsFilterBloc;

    setUp(() {
      tipsFilterBloc = TipsFilterBloc();
    });

    test('Initial state is TipsFilterInitial', () {
      expect(tipsFilterBloc.state, isA<TipsFilterInitial>());
      tipsFilterBloc.close();
    });

    group('Expect when triggreing states:', () {
      final filter = Filter();
      blocTest<TipsFilterBloc, TipsFilterState>(
          'When TipsFilterInitialLoad expect TipsFilterOpened',
          build: () => tipsFilterBloc,
          act: (bloc) => bloc.add(TipsFilterInitialLoad(filter: filter)),
          expect: [
            isA<TipsFilterOpened>(),
          ]);
    });

    group('On apply filters get TipsBeingFiltered', () {
      final filter = Filter();
      blocTest<TipsFilterBloc, TipsFilterState>(
          'When ApplyTipsFilter expect TipsBeingFiltered',
          build: () => tipsFilterBloc,
          act: (bloc) {
            bloc.add(TipsFilterInitialLoad(filter: filter));
            bloc.add(ApplyTipsFilter(filterIdList: [''], filter: filter));
          },
          expect: [
            isA<TipsFilterOpened>(),
            isA<TipsBeingFiltered>(),
          ]);
      blocTest<TipsFilterBloc, TipsFilterState>(
          'When RemoveTipsFilter expect TipsFilterOpened',
          build: () => tipsFilterBloc,
          act: (bloc) {
            bloc.add(TipsFilterInitialLoad(filter: filter));
            bloc.add(RemoveTipsFilter(filterIdList: [''], filter: filter));
          },
          expect: [
            isA<TipsFilterOpened>(),
            isA<TipsBeingFiltered>(),
          ]);
      blocTest<TipsFilterBloc, TipsFilterState>(
          'When TipsFilterCleared expect TipsFiltered',
          build: () => tipsFilterBloc,
          act: (bloc) {
            bloc.add(TipsFilterInitialLoad(filter: filter));
            bloc.add(TipsFilterCleared(filter: filter));
          },
          expect: [
            isA<TipsFilterOpened>(),
            isA<TipsFiltered>(),
            isA<TipsBeingFiltered>(),
          ]);
      blocTest<TipsFilterBloc, TipsFilterState>(
          'When TipsFilterCanceled expect TipsFiltered',
          build: () => tipsFilterBloc,
          act: (bloc) {
            bloc.add(TipsFilterInitialLoad(filter: filter));
            bloc.add(TipsFilterCanceled(filter: filter));
          },
          expect: [
            isA<TipsFilterOpened>(),
            isA<TipsFiltered>(),
          ]);
    });
  });
}
