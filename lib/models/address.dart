class Address {
  final int vendorId;
  final String address1;

  final String phone;
  final String city;

  Address({
    this.vendorId,
    this.address1,
    this.phone,
    this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      vendorId: int.parse(json['vendor_id'].toString()),
      address1: json['address_1'],
      phone: json['phone'].toString(),
      city: json['city'] ?? '-',
    );
  }
}
