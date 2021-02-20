import 'package:flutter/material.dart';

class Wishlist {
  int id;
  String name;
  String slug;
  int postId;
  int vendorId;
  int quantity;
  String vendorname;
  String picture;
  static int count = 0;

  Wishlist(
      {@required this.id,
      @required this.name,
      @required this.slug,
      @required this.postId,
      @required this.vendorId,
      @required this.quantity,
      @required this.picture,
      @required this.vendorname});

  static List<Wishlist> generateWishlistList(List<dynamic> wishlistlist) {
    List<Wishlist> wishlistfetched = List<Wishlist>();
    Wishlist.count = wishlistlist.length;

    for (var wishlist in wishlistlist) {
      wishlistfetched.add(Wishlist(
          id: int.parse(wishlist['id'].toString()),
          name: wishlist['name'],
          slug: wishlist['slug'],
          postId: int.parse(wishlist['post_id'].toString()),
          vendorId: int.parse(wishlist['vendor_id'].toString()),
          vendorname: wishlist['vendorname'].toString(),
          picture: wishlist['thumbnail'],
          quantity: int.parse(wishlist['quantity'].toString())));
    }
    return wishlistfetched;
  }

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        slug: json['slug'],
        postId: int.parse(json['post_id'].toString()),
        vendorId: int.parse(json['vendor_id'].toString()),
        vendorname: json['vendorname'],
        picture: json['thumbnail'],
        quantity: int.parse(json['quantity'].toString()));
  }

  @override
  String toString() =>
      'Wishlist {id: $id, name: $name, slug: $slug, postId: $postId}';
}
