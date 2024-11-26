    class Users {
      String? uid;
      String? name;
      String? email;
      String? mobile;
      String? companyName; // Optional field for the company name
      String? gstNumber; // Optional field for GST number
      String? username;
      String? password;
      String? address;
      String? city;
      String? role;
      String? image = null;
      int? pinCode;
      String? state;
      String? createdAt; // Use DateTime instead of String for better date handling

      // Constructor
      Users({
         this.uid,
         this.username,
         this.password,
         this.role,
         this.name,
         this.image,
         this.email,
         this.mobile,
        this.companyName,
        this.gstNumber,
         this.address,
         this.pinCode,
         this.state,
         this.city,
         this.createdAt,
      });

      // Named constructor for creating from JSON
      factory Users.fromJson(Map<String, dynamic> json) {
        return Users(
          uid: json['uid'] ?? '', // Default to an empty string if null
          username: json['username'] ?? '',
          password: json['password'] ?? '',
          role: json['role'] ?? '',
          name: json['name'] ?? '',
          image: json['image'], // Nullable field
          email: json['email'] ?? '',
          mobile: json['mobile'] ?? '',
          companyName: json['companyName'], // Nullable field
          gstNumber: json['gstNumber'], // Nullable field
          address: json['address'] ?? '',
          city: json['city'] ?? '',
          pinCode: json['pinCode'] ?? 0, // Default to 0 if null
          state: json['state'] ?? '',
          createdAt: json['createdAt'] ?? ''
        );
      }

      // Convert to JSON for API or storage
      Map<String, dynamic> toJson() {
        return {
          'username': username,
          'name': name,
          'photoUrl': image,
          'email': email,
          'mobile': mobile,
          'companyName': companyName,
          'gstNumber': gstNumber,
          'address': address,
          'pincode': pinCode,
          'state': state,
          'city': city,
          'createdAt': createdAt, // Converting DateTime back to string
          'uid': uid,
          'password': password,
          'role': role,
        };
      }

      // Named constructor for creating from a Map (optional)
      factory Users.fromMap(Map<String, dynamic> map) => Users.fromJson(map);

      Map<String, dynamic> toMap() => toJson();
    }