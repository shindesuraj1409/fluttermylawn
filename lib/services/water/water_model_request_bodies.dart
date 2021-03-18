class CreatePlotRequest {
  final String name;
  final int zipCode;
  final String city;
  final String address1;
  final String address2;
  final String state;
  final int slope;
  final String soilType;
  final String plantType;
  final String nozzleType;
  final int goal;

  CreatePlotRequest({
    this.name,
    this.zipCode,
    this.slope,
    this.soilType,
    this.plantType,
    this.nozzleType,
    this.goal,
    this.city,
    this.address1,
    this.address2,
    this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'zipCode': zipCode,
      'state': state,
      'city': city,
      'address1': address1,
      'address2': address2,
      'slope': slope,
      'soilType': soilType,
      'plantType': plantType,
      'nozzleType': nozzleType,
      'goal': goal,
    };
  }
}
