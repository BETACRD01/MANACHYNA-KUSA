enum CustomTaskStatus {
  open,
  accepted,
  completed,
}

class CustomTaskOffer {
  final String id;
  final String providerId;
  final String providerName;
  final double providerRating;
  final double priceOffer;
  final String message;
  final DateTime createdAt;

  CustomTaskOffer({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerRating,
    required this.priceOffer,
    required this.message,
    required this.createdAt,
  });
}

class CustomTaskModel {
  final String id;
  final String clientId;
  final String clientName;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final double budget;
  final String address;
  final CustomTaskStatus status;
  final String? providerId;
  final String? providerName;
  final List<CustomTaskOffer> offers;
  final DateTime createdAt;

  CustomTaskModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.budget,
    required this.address,
    required this.status,
    this.providerId,
    this.providerName,
    required this.offers,
    required this.createdAt,
  });

  CustomTaskModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    double? budget,
    String? address,
    CustomTaskStatus? status,
    String? providerId,
    String? providerName,
    List<CustomTaskOffer>? offers,
    DateTime? createdAt,
  }) {
    return CustomTaskModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      budget: budget ?? this.budget,
      address: address ?? this.address,
      status: status ?? this.status,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      offers: offers ?? this.offers,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
