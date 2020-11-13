class MedicalInfo {
  final int id;
  final String title;
  final String description;
  String indications;
  String cautions;
  String drugInteractions;
  String contradictions;
  String sideEffects;
  String doseAdminstrations;
  String storage;

  MedicalInfo.medsInfo({
    this.id,
    this.title,
    this.description,
  });

  MedicalInfo(
      {this.id,
      this.title,
      this.description,
      this.indications,
      this.cautions,
      this.drugInteractions,
      this.contradictions,
      this.sideEffects,
      this.doseAdminstrations,
      this.storage});

  static List<MedicalInfo> generateMedsList(List<dynamic> productslist) {
    List<MedicalInfo> productsfetched = List<MedicalInfo>();

    for (var products in productslist) {
      productsfetched.add(MedicalInfo.medsInfo(
        id: products['id'],
        title: products['generic_name'],
        description: products['description'],
      ));
    }
    return productsfetched;
  }

  factory MedicalInfo.fromJson(Map<String, dynamic> json) {
    return MedicalInfo(
        id: int.parse(json['id'].toString()),
        title: json['generic_name'],
        description: json['discription'],
        indications: json['indications'],
        cautions: json['cautions'],
        drugInteractions: json['drug_interactions'],
        contradictions: json['contraindications'],
        sideEffects: json['side_effects'],
        doseAdminstrations: json['dose_administrations'],
        storage: json['storage']);
  }
}
