
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:imagine_retailer/models/warranty_model.dart';
final FirebaseStorage storage = FirebaseStorage.instance;

class WarrantyRepository{
  Future<bool> canClaimWarranty(String serialNumber) async {
    final doc = await FirebaseFirestore.instance.collection("warranty").doc(serialNumber).get();
    if (!doc.exists) return false;

    final data = doc.data()!;
    final warrantyEnded = data['warrantyEnded'].toDate();

    if (warrantyEnded.isBefore(DateTime.now())) {
      print("Warranty Expired. Cannot Claim.");
      return false;
    }

    final claims = List.from(data['claims'] ?? []);
    if (claims.isNotEmpty && claims.last['status'] == "pending") {
      print("Previous claim is still pending.");
      return false;
    }

    return true;
  }
  Future<void> claimWarranty(Warranty warranty, String serialNumber) async {
    final warrantyRef = FirebaseFirestore.instance.collection("warranty").doc(serialNumber);

    final doc = await warrantyRef.get();
    if (!doc.exists) {
      throw Exception("Warranty record not found.");
    }
    final data = doc.data()!;
    final claims = List.from(data['claims'] ?? []);

    await warrantyRef.update({
      "status": "claimed",
      "claims": FieldValue.arrayUnion([
        {
          "id": warranty.id,
          "claimedAt": Timestamp.now(),
          "status": "pending",
          "reason": warranty.reason,
          "reasonDescription": warranty.reasonDescription,
          "images": warranty.images
        }
      ])
    });
  }

}
