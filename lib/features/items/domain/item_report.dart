import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_found/core/enums/item_status.dart';
import 'package:campus_lost_found/core/enums/item_type.dart';

class ItemReport {
  const ItemReport({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.itemDate,
    required this.status,
    required this.photoUrls,
    required this.reporterId,
    required this.reporterName,
    required this.isFlagged,
    required this.flagCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final ItemType type;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime itemDate;
  final ItemStatus status;
  final List<String> photoUrls;
  final String reporterId;
  final String reporterName;
  final bool isFlagged;
  final int flagCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ItemReport.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Item document ${doc.id} has no data.');
    }

    final type = ItemType.tryFrom(data['type'] as String?);
    final status = ItemStatus.tryFrom(data['status'] as String?);
    if (type == null || status == null) {
      throw StateError('Item ${doc.id} has an invalid type or status.');
    }

    return ItemReport(
      id: doc.id,
      type: type,
      title: data['title'] as String,
      description: data['description'] as String,
      category: data['category'] as String,
      location: data['location'] as String,
      itemDate: (data['itemDate'] as Timestamp).toDate(),
      status: status,
      photoUrls: (data['photoUrls'] as List<dynamic>? ?? []).cast<String>(),
      reporterId: data['reporterId'] as String,
      reporterName: data['reporterName'] as String,
      isFlagged: data['isFlagged'] as bool? ?? false,
      flagCount: data['flagCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.value,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'itemDate': Timestamp.fromDate(itemDate),
      'status': status.value,
      'photoUrls': photoUrls,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'isFlagged': isFlagged,
      'flagCount': flagCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}