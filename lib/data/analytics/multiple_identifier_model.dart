import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

class MultipleIdentifierModel{
  final Map<String,String> identifierMap;
  final ACPMobileVisitorAuthenticationState acpMobileVisitorAuthenticationState;

  MultipleIdentifierModel({
    this.identifierMap,
    this.acpMobileVisitorAuthenticationState,
  });
}