class Address {
  final int vendorId;
  final String address1;
  final String phone;
  final String city;
  String address2;
  String state;
  String facebook;
  String twitter;
  String linkedin;
  String youtube;
  String telegram;

  Address({
    this.vendorId,
    this.address1,
    this.phone,
    this.city,
  });

  Address.vendor(
      {this.vendorId,
      this.address1,
      this.phone,
      this.city,
      this.state,
      this.address2,
      this.facebook,
      this.twitter,
      this.youtube,
      this.linkedin,
      this.telegram});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      vendorId: int.parse(json['vendor_id'].toString()),
      address1: json['address_1'],
      phone: json['phone'].toString(),
      city: json['city'] ?? '-',
    );
  }

  factory Address.fromJsonforVendor(Map<String, dynamic> json) {
    return Address.vendor(
      vendorId: int.parse(json['vendor_id'].toString()),
      address1: json['address_1'],
      phone: json['phone'].toString(),
      city: json['city'] ?? '-',
      address2:
          json['address_2'] != json['address_1'] ? json['address_2'] : '-',
      state: json['state'] ?? '-',
      facebook: json['fb_profile'] != 'Facebook.profile\/url'
          ? json['fb_profile']
          : '-',
      twitter: json['twitter_profile'] != 'Twitter.profile\/url'
          ? json['twitter_profile']
          : '-',
      linkedin: json['linkedin_profile'] != 'LinkedIn.profile\/url'
          ? json['linkedin_profile']
          : '-',
      youtube: json['youtube_profile'] != 'Youtube.profile\/url'
          ? json['youtube_profile']
          : '-',
      telegram: json['telegram_profile'] != 'Telegram.profile\/url'
          ? json['telegram_profile']
          : '-',
    );
  }

  @override
  String toString() =>
      'News {vendor: $vendorId, address1: $address1, city: $city, phone: $phone}';
}
