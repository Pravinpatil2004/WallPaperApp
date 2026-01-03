/// =====================================================
/// USER MODEL FILE (ALL IN ONE – NULL SAFE & ERROR FREE)
/// =====================================================

class UserModel {
  // ❌ Pehle: int? id
  // ✅ Fix: API hamesha id deta hai
  final int id;

  // ❌ Pehle: String? name → Text() error
  // ✅ Fix: non-null + default value
  final String name;

  final String username;
  final String email;

  // Nested objects null ho sakte hai
  final Address? address;

  final String phone;
  final String website;

  final Company? company;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.address,
    required this.phone,
    required this.website,
    this.company,
  });

  /// JSON → MODEL (NULL SAFE)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0, // ❌ null crash fix
      name: json['name'] ?? '', // ❌ String? error fix
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
    );
  }
}

/// ===============================
/// ADDRESS MODEL
/// ===============================
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo? geo;

  Address({
    required this.street,
    required this.suite,
    required this.city ,
    required this.zipcode,
    this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      suite: json['suite'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      geo: json['geo'] != null ? Geo.fromJson(json['geo']) : null,
    );
  }
}

/// ===============================
/// GEO MODEL
/// ===============================
class Geo {
  final String lat;
  final String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(lat: json['lat'] ?? '', lng: json['lng'] ?? '');
  }
}

/// ===============================
/// COMPANY MODEL
/// ===============================
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({required this.name, required this.catchPhrase, required this.bs});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catchPhrase: json['catchPhrase'] ?? '',
      bs: json['bs'] ?? '',
    );
  }
}
