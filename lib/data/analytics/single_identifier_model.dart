import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

class SingleIdentifierModel{
  final String identifierType;
  final String identifier;
  final ACPMobileVisitorAuthenticationState acpMobileVisitorAuthenticationState;

  SingleIdentifierModel({
    this.identifierType,
    this.identifier,
    this.acpMobileVisitorAuthenticationState,
  });
}

