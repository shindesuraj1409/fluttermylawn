import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/edit_lawn_profile/edit_lawn_profile_bloc.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/water/i_water_model_service.dart';
import 'package:navigation/navigation.dart';

import '../../resources/address_data.dart';

class MockNavigation extends Mock implements Navigation {}

class MockSessionManager extends Mock implements SessionManager {}

class MockWaterModelService extends Mock implements WaterModelService {}

void main() {
  group(
    'EditLawnProfileBloc',
    () {
      Navigation _navigation;
      SessionManager _sessionManager;
      WaterModelService _waterModelService;
      final _screenPath = '/quiz/lawnsizezipcode';
      final _lawnData = LawnData(
        color: LawnGrassColor.greenAndBrown,
        grassType: 'DIC',
        grassTypeImageUrl:
            'https://smg-product-images.storage.googleapis.com/Dichondra%403x.png',
        grassTypeName: 'Dichondra',
        inputType: 'manual',
        lawnAddress: inValidAddress,
        lawnSqFt: 25000,
        spreader: Spreader.none,
        thickness: LawnGrassThickness.patchy,
        weeds: LawnWeeds.some,
      );

      final _user = User(
        email: 'test@gmail.com',
        firstName: 'Test',
        lastName: 'Test',
        customerId: 'customerId',
        isNewsletterSubscribed: true,
      );

      final _validId = 'validId';

      setUp(() {
        _navigation = MockNavigation();
        _sessionManager = MockSessionManager();
        _waterModelService = MockWaterModelService();
      });

      test('throws AssertionError when any one constructor parameter is null',
          () {
        expect(
            () => EditLawnProfileBloc(null, null, null), throwsAssertionError);
      });

      test('initial state is EditLawnProfileStateInitial()', () {
        final bloc = EditLawnProfileBloc(
            _navigation, _sessionManager, _waterModelService);
        expect(bloc.state, EditLawnProfileStateInitial());
        bloc.close();
      });

      group('Edit Lawn Profile', () {
        blocTest<EditLawnProfileBloc, EditLawnProfileState>(
          'invokes push on Navigation and set LawnData in Session',
          build: () => EditLawnProfileBloc(
              _navigation, _sessionManager, _waterModelService),
          act: (bloc) => bloc.add(
            EditLawnProfileEventLoad(
              screenPath: _screenPath,
              lawnData: _lawnData,
            ),
          ),
          verify: (_) {
            verify(_navigation.push(_screenPath, arguments: _lawnData))
                .called(1);
          },
        );

        blocTest<EditLawnProfileBloc, EditLawnProfileState>(
          'emits [loading, success] when navigation returns valid LawnData',
          build: () {
            when(_navigation.push(_screenPath, arguments: _lawnData))
                .thenAnswer((_) async => _lawnData);
            when(_sessionManager.getUser()).thenAnswer((_) async => _user);
            when(_waterModelService.createPlot(
                    _user.customerId, int.tryParse(_lawnData.lawnAddress.zip)))
                .thenAnswer((_) async => _validId);
            return EditLawnProfileBloc(
                _navigation, _sessionManager, _waterModelService);
          },
          act: (bloc) => bloc.add(
            EditLawnProfileEventLoad(
              screenPath: _screenPath,
              lawnData: _lawnData,
            ),
          ),
          expect: <EditLawnProfileState>[
            EditLawnProfileStateLoading(),
            EditLawnProfileStateSuccess(lawnData: _lawnData),
          ],
        );

        blocTest<EditLawnProfileBloc, EditLawnProfileState>(
          'emits [loading, error] when navigation throws Error',
          build: () {
            when(_navigation.push(_screenPath, arguments: _lawnData))
                .thenAnswer((_) async => _lawnData);
            when(_sessionManager.getUser()).thenAnswer((_) async => _user);
            when(_waterModelService.createPlot(
                    _user.customerId, int.tryParse(_lawnData.lawnAddress.zip)))
                .thenThrow(Exception());
            return EditLawnProfileBloc(
                _navigation, _sessionManager, _waterModelService);
          },
          act: (bloc) => bloc.add(
            EditLawnProfileEventLoad(
              screenPath: _screenPath,
              lawnData: _lawnData,
            ),
          ),
          expect: <EditLawnProfileState>[
            EditLawnProfileStateLoading(),
            EditLawnProfileStateError(errorMessage: genericErrorMessage),
          ],
        );
      });
    },
  );
}
