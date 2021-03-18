import 'package:data/data.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';

const productFilterWhatItControlls = 'what_it_controls';
const productFilterWeedType = 'mylawn_weed_type';
const productFilterSunlight = 'mylawn_sunlight';
const productFilterGrassTypes = 'mylawn_grass_types';

class ProductFilterBlockData extends Data {
  final String id;
  final String title;
  final bool displayAll;
  final List<ProductFilterOption> filterOptionList;

  ProductFilterBlockData({
    this.id,
    this.title,
    this.displayAll = true,
    this.filterOptionList,
  });

  ProductFilterBlockData copyWith({
    String id,
    String title,
    bool displayAll,
    List<ProductFilterOption> filterOptionList,
  }) {
    return ProductFilterBlockData(
      id: id ?? this.id,
      title: title ?? this.title,
      displayAll: displayAll ?? this.displayAll,
      filterOptionList: filterOptionList ?? this.filterOptionList,
    );
  }

  @override
  List<Object> get props => [id, title, filterOptionList, displayAll];

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      filterOptionList.hashCode ^
      displayAll.hashCode;
}
