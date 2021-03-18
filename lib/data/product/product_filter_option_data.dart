import 'package:data/data.dart';

const filterOptionShade = 'shade';
const filterOptionFullSun = 'full_sun';
const filterOptionPartialSun = 'partial_sun';
const filterOptionInsects = 'Insects';
const filterOptionDiseases = 'Diseases';
const filterOptionCrabgrass = 'Crabgrass';
const filterOptionMoss = 'Moss';
const filterOptionDandelion = 'Dandelion';
const filterOptionClover = 'Clover';

class ProductFilterOption extends Data {
  final String id;
  final String name;

  ProductFilterOption({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [id, name];

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
