import 'dart:convert';

class Person {
    Person({
        required this.name,
        required this.country,
        required this.email,
        this.city,
        this.id,
        this.photo,
        
    });

    String name;
    String country;
    String? city;
    String? id;
    String? photo;
    String email;

    factory Person.fromJson(String str) => Person.fromMap(json.decode(str));

    String toJson(String personId) => json.encode( {personId: toMap()});

    String normalToJson() => json.encode(toMap());


    factory Person.fromMap(Map<String, dynamic> json) => Person(
        name: json["name"],
        country: json["country"],
        city: json["city"],
        id: json["id"],
        photo:json["photo"],
        email:json["email"],

    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "country": country,
        "city": city,
        "id": id,
        "email":email,
        "photo":photo,
    };

    Person copy() => Person(
      name: this.name,
      country: this.country,
      city: this.city,
      id: this.id,
      email: this.email,
      photo : this.photo,
    );

}
