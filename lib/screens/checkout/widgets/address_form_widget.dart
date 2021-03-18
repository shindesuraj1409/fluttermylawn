import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_lawn/blocs/checkout/address/search_address_form_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/screens/checkout/widgets/address_validation_failure_dialog_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AddressForm extends StatefulWidget {
  final AddressData initialAddress;
  final AddressData disabledFields;
  final EdgeInsets padding;
  final Function(AddressData) onChanged;

  /// Returns [AddressData] with the tapped address data field,
  /// iff said field is part of [disabledFields].
  final Function(AddressData) onDisabledTap;

  AddressForm({
    this.initialAddress,
    this.disabledFields,
    this.padding = EdgeInsets.zero,
    this.onChanged,
    this.onDisabledTap,
  });

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _stateFormatter =
      MaskTextInputFormatter(mask: '##', filter: {'#': RegExp(r'[A-Za-z]')});
  final _zipFormatter =
      MaskTextInputFormatter(mask: '#####', filter: {'#': RegExp(r'[0-9]')});
  final _phoneFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {'#': RegExp(r'[0-9]')});
  final _upperCaseFomatter = UpperCaseTextInputFormatter();

  AddressData _address;
  SearchAddressFormBloc _bloc;

  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  final FocusNode _streetAddressNode = FocusNode();

  final zipCodesMustMatchErrorMessage = '''
The products in your plan are based on the ZIP code provided previously in the lawn size step of the quiz. 

To ship to a different ZIP code, you will need to create a new plan to ensure the products are suitable for your area.

For questions, email us at''';

  @override
  void initState() {
    super.initState();
    _address = widget.initialAddress;
    _bloc = registry<SearchAddressFormBloc>();
    _updateControllers(widget.initialAddress);
    _streetAddressNode.addListener(_streetAddressFocusListener);
  }

  @override
  void dispose() {
    _address1Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _streetAddressNode.removeListener(_streetAddressFocusListener);
    _streetAddressNode.dispose();
    super.dispose();
  }

  void _streetAddressFocusListener() {
    if (!_streetAddressNode.hasFocus) {
      _bloc.cancelSearch();
    }
  }

  void _updateControllers(AddressData addressData) {
    _address1Controller.text = addressData?.address1;
    _cityController.text = addressData?.city;
    _stateController.text = addressData?.state;
    if (widget.disabledFields?.zip == null) {
      _zipController.text = addressData?.zip;
    }
  }

  void _updateAddress(AddressData addressData) {
    _address = addressData?.copyWith(addressData: widget.disabledFields);
    widget.onChanged?.call(_address);
  }

  String _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber != null &&
        phoneNumber.isNotEmpty &&
        phoneNumber.length != 14) {
      return 'Invalid phone number';
    }
    return null;
  }

  Widget _maybeWrapWithDisabledTheme({
    bool wrap = false,
    Widget child,
  }) {
    if (wrap) {
      final theme = Theme.of(context);

      return Theme(
          data: theme.copyWith(
            inputDecorationTheme: theme.inputDecorationTheme.copyWith(
              filled: true,
              fillColor: (theme.brightness == Brightness.dark
                      ? Styleguide.color_gray_0
                      : Styleguide.color_gray_9)
                  .withAlpha(0x15),
            ),
          ),
          child: child);
    } else {
      return child;
    }
  }

  Widget _buildTextField({
    TextEditingController controller,
    String label,
    String initialValue,
    String disabledField,
    Function(String) onChanged,
    Function(String) onDisabledTap,
    List<TextInputFormatter> textInputFormatters,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType textInputType = TextInputType.text,
    bool noFlex = false,
    String errorText,
  }) {
    final textField = _maybeWrapWithDisabledTheme(
      wrap: disabledField != null,
      child: TextInputField(
        labelText: label,
        initialValue: disabledField ?? initialValue,
        controller: controller,
        suffixIcon: disabledField == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset(
                  'assets/icons/form_field_disabled.png',
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Styleguide.color_gray_0
                          : Styleguide.color_gray_9)
                      .withAlpha(0x30),
                ),
              ),
        onChanged:
            disabledField != null ? null : (value) => onChanged?.call(value),
        onTap: widget.onDisabledTap == null || disabledField == null
            ? null
            : () => onDisabledTap?.call(disabledField),
        textInputFormatters: textInputFormatters,
        textInputAction: textInputAction,
        textInputType: textInputType,
        enabled: disabledField == null,
        errorText: errorText,
        labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Styleguide.color_gray_4,
              letterSpacing: 0.15,
            ),
        disabledColor: disabledField != null ? Styleguide.color_gray_4 : null,
      ),
    );

    return noFlex ? textField : Expanded(child: textField);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'First Name',
                initialValue: _address.firstName,
                disabledField: widget.disabledFields?.firstName,
                onChanged: (value) => _updateAddress(
                  _address.copyWith(firstName: value),
                ),
                onDisabledTap: (disabledField) => widget.onDisabledTap(
                  AddressData(firstName: disabledField),
                ),
              ),
              SizedBox(width: 8),
              _buildTextField(
                label: 'Last Name',
                initialValue: _address.lastName,
                disabledField: widget.disabledFields?.lastName,
                onChanged: (value) => _updateAddress(
                  _address.copyWith(lastName: value),
                ),
                onDisabledTap: (disabledField) => widget.onDisabledTap(
                  AddressData(lastName: disabledField),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              TextInputField(
                controller: _address1Controller,
                labelText: 'Street Address',
                padding: const EdgeInsets.all(0),
                onChanged: (value) {
                  _bloc.searchPlaces(value);
                  _updateAddress(_address.copyWith(address1: value));
                },
                focusNode: _streetAddressNode,
                labelStyle: theme.textTheme.subtitle1.copyWith(
                  color: Styleguide.color_gray_4,
                  letterSpacing: 0.15,
                ),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
              ),
              Positioned(
                right: 0,
                bottom: 16,
                child:
                    BlocBuilder<SearchAddressFormBloc, SearchAddressFormState>(
                  cubit: _bloc,
                  builder: (context, state) {
                    if (state.status == FormStatus.searchingAddress ||
                        state.status == FormStatus.gettingAddressDetails) {
                      return ProgressSpinner(
                        size: 16,
                        color: theme.colorScheme.secondaryVariant,
                        strokeWidth: 2.0,
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
          BlocConsumer<SearchAddressFormBloc, SearchAddressFormState>(
            cubit: _bloc,
            listener: (context, state) {
              if (state.status == FormStatus.addressDetailsSuccess) {
                // Update controller text
                _updateControllers(state.addressData);

                final addressData = state.addressData.copyWith(
                  firstName: _address.firstName,
                  lastName: _address.lastName,
                  phone: _address.phone,
                );
                _updateAddress(addressData);
              } else if (state.status ==
                  FormStatus.addressDetailsZipMismatchError) {
                showAddressValidationFailureDialog(
                  context: context,
                  title: 'Zip Codes Must Match',
                  content: zipCodesMustMatchErrorMessage,
                );
              } else if (state.status == FormStatus.addressDetailsError) {
                showSnackbar(
                  context: context,
                  text: state.errorMessage,
                  duration: Duration(seconds: 2),
                );
              }
            },
            builder: (context, state) {
              if (state.predictions.isNotEmpty) {
                return Container(
                  height: state.predictions.length * 60.0,
                  color: theme.backgroundColor,
                  child: ListView.separated(
                    itemCount: state.predictions.length,
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (_, __) => Divider(),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final prediction = state.predictions[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => _bloc.getAddressDetails(
                          prediction.placeId,
                          widget.disabledFields?.zip,
                        ),
                        title: Text(
                          '${prediction.description}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.subtitle2,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'Apartment/Suite/Other (optional)',
            initialValue: _address.address2,
            disabledField: widget.disabledFields?.address2,
            onChanged: (value) => _updateAddress(
              _address.copyWith(address2: value),
            ),
            onDisabledTap: (disabledField) => widget.onDisabledTap(
              AddressData(address2: disabledField),
            ),
            noFlex: true,
          ),
          _buildTextField(
            controller: _cityController,
            label: 'City',
            disabledField: widget.disabledFields?.city,
            onChanged: (value) => _updateAddress(
              _address.copyWith(city: value),
            ),
            onDisabledTap: (disabledField) => widget.onDisabledTap(
              AddressData(city: disabledField),
            ),
            noFlex: true,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _stateController,
                label: 'State',
                disabledField: widget.disabledFields?.state,
                onChanged: (value) => _updateAddress(
                  _address.copyWith(state: value),
                ),
                onDisabledTap: (disabledField) => widget.onDisabledTap(
                  AddressData(state: disabledField),
                ),
                textInputFormatters: [_stateFormatter, _upperCaseFomatter],
              ),
              Container(width: 8),
              _buildTextField(
                controller:
                    widget.disabledFields?.zip == null ? _zipController : null,
                label: 'ZIP Code',
                disabledField: widget.disabledFields?.zip,
                onChanged: (value) => _updateAddress(
                  _address.copyWith(zip: value),
                ),
                onDisabledTap: (disabledField) => widget.onDisabledTap(
                  AddressData(zip: disabledField),
                ),
                textInputFormatters: [_zipFormatter],
                textInputType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
          _buildTextField(
            label: 'Phone Number',
            initialValue: _address.phone,
            disabledField: widget.disabledFields?.phone,
            errorText: _validatePhoneNumber(_address.phone),
            onChanged: (value) => _updateAddress(
              _address.copyWith(phone: value),
            ),
            onDisabledTap: (disabledField) => widget.onDisabledTap(
              AddressData(phone: disabledField),
            ),
            textInputFormatters: [_phoneFormatter],
            textInputType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            textInputAction: TextInputAction.done,
            noFlex: true,
          ),
        ],
      ),
    );
  }
}
