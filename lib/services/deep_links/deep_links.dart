import 'package:my_lawn/services/deep_links/i_deep_links.dart';
import 'package:uni_links/uni_links.dart' as uni_links;

class DeepLinksImpl implements DeepLinks {
  @override
  Stream<Uri> getUriLinksStream() => uni_links.getUriLinksStream();

  @override
  Future<Uri> getInitialUri() => uni_links.getInitialUri();
}
