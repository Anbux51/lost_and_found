import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_found/core/enums/claim_status.dart';

class Claim {
  const Claim({
    required this.id,
    required this.itemId,
    required this.claimantId,
    required this.details,
    required this.proofPhotoUrls,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String itemId;
  final String claimantId;
  final String details;
  final List<String> proofPhotoUrls;
  final ClaimStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Claim.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Claim document ${doc.id} has no data.');
    }

    final status = ClaimStatus.tryFrom(data['status'] as String?);
    if (status == null) {
      throw StateError('Claim ${doc.id} has an invalid status.');
    }

    return Claim(
      id: doc.id,
      itemId: data['itemId'] as String,
      claimantId: data['claimantId'] as String,
      details: data['details'] as String,
      proofPhotoUrls:
          (data['proofPhotoUrls'] as List<dynamic>? ?? []).cast<String>(),
      status: status,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemId': itemId,
      'claimantId': claimantId,
      'details': details,
      'proofPhotoUrls': proofPhotoUrls,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}