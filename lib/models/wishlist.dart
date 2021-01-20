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
          id: wishlist['id'],
          name: wishlist['name'],
          slug: wishlist['slug'],
          postId: wishlist['post_id'],
          vendorId: wishlist['vendor_id'],
          vendorname: wishlist['vendorname'],
          picture: wishlist['thumbnail'],
          quantity: wishlist['quantity']));
    }
    return wishlistfetched;
  }

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        postId: json['post_id'],
        vendorId: json['vendor_id'],
        vendorname: json['vendorname'],
        picture: json['thumbnail'],
        quantity: json['quantity']);
  }

  @override
  String toString() =>
      'Wishlist {id: $id, name: $name, slug: $slug, postId: $postId}';
}
