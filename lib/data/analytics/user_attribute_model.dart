
class UserAttributeModel{
  final String attrName;
  final String attrValue;

  UserAttributeModel(this.attrName, this.attrValue);

  Map<String,String> toMap(){
    return {
      attrName: attrValue
    };
  }
}