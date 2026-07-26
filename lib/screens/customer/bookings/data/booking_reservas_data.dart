import '../../../../core/utils/helpers.dart';
import '../../../../models/booking/booking_model.dart';

enum BookingReservasFilter {
  all,
  pending,
  confirmed,
  completed,
}

class BookingReservaItem {
  const BookingReservaItem({
    required this.title,
    required this.providerName,
    required this.status,
    required this.dateLabel,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.artwork,
    this.booking,
    this.providerAssignedLabel,
  });

  final String title;
  final String providerName;
  final BookingStatus status;
  final String dateLabel;
  final String location;
  final double rating;
  final int reviews;
  final BookingReservaArtwork artwork;
  final BookingModel? booking;
  final String? providerAssignedLabel;

  bool get isMock => booking == null;

  factory BookingReservaItem.fromBooking(BookingModel booking) {
    return BookingReservaItem(
      title: booking.serviceName.isEmpty
          ? 'Servicio reservado'
          : booking.serviceName,
      providerName: booking.providerName.isEmpty
          ? 'Proveedor asignado'
          : booking.providerName,
      status: booking.status,
      dateLabel:
          '${Helpers.formatDate(booking.scheduledDate)}, ${booking.scheduledTime}',
      location:
          booking.address?.isNotEmpty == true ? booking.address! : 'Tena, Napo',
      rating: booking.rating ?? _ratingForStatus(booking.status),
      reviews: _reviewsForStatus(booking.status),
      artwork: BookingReservaArtwork.fromServiceName(booking.serviceName),
      booking: booking,
      providerAssignedLabel: booking.status == BookingStatus.confirmed
          ? 'Proveedor asignado: ${booking.providerName}'
          : null,
    );
  }

  static double _ratingForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 4.8;
      case BookingStatus.confirmed:
      case BookingStatus.inProgress:
        return 4.9;
      case BookingStatus.completed:
        return 5.0;
      case BookingStatus.cancelled:
        return 4.7;
    }
  }

  static int _reviewsForStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 94;
      case BookingStatus.confirmed:
        return 128;
      case BookingStatus.inProgress:
        return 76;
      case BookingStatus.completed:
        return 66;
      case BookingStatus.cancelled:
        return 18;
    }
  }
}

class BookingReservaArtwork {
  const BookingReservaArtwork({
    required this.emoji,
    required this.background,
  });

  final String emoji;
  final int background;

  factory BookingReservaArtwork.fromServiceName(String serviceName) {
    final normalized = serviceName.toLowerCase();
    if (normalized.contains('limp')) {
      return const BookingReservaArtwork(
        emoji: '🧽',
        background: 0xFFEAF4E8,
      );
    }
    if (normalized.contains('fuga') || normalized.contains('plom')) {
      return const BookingReservaArtwork(
        emoji: '🚰',
        background: 0xFFE9F0F5,
      );
    }
    if (normalized.contains('pint')) {
      return const BookingReservaArtwork(
        emoji: '🎨',
        background: 0xFFF2EAF8,
      );
    }
    if (normalized.contains('elect')) {
      return const BookingReservaArtwork(
        emoji: '🔌',
        background: 0xFFF3F2EA,
      );
    }
    return const BookingReservaArtwork(
      emoji: '🛠️',
      background: 0xFFEAF4E8,
    );
  }
}

List<BookingReservaItem> bookingReservasMockItems(
  BookingReservasFilter filter,
) {
  const all = [
    BookingReservaItem(
      title: 'Limpieza profunda de casa',
      providerName: 'Ana Torres',
      status: BookingStatus.confirmed,
      dateLabel: 'Hoy, 3:30 PM',
      location: 'Tena, Napo',
      rating: 4.9,
      reviews: 128,
      artwork: BookingReservaArtwork(emoji: '🧽', background: 0xFFEAF4E8),
    ),
    BookingReservaItem(
      title: 'Reparación de fuga de agua',
      providerName: 'Carlos Mena',
      status: BookingStatus.pending,
      dateLabel: 'Mañana, 9:00 AM',
      location: 'Tena, Napo',
      rating: 4.8,
      reviews: 94,
      artwork: BookingReservaArtwork(emoji: '🚰', background: 0xFFE9F0F5),
    ),
    BookingReservaItem(
      title: 'Instalación eléctrica',
      providerName: 'Luis Paredes',
      status: BookingStatus.completed,
      dateLabel: '22 mayo, 2:00 PM',
      location: 'Tena, Napo',
      rating: 4.9,
      reviews: 76,
      artwork: BookingReservaArtwork(emoji: '🔌', background: 0xFFF3F2EA),
    ),
  ];

  const pending = [
    BookingReservaItem(
      title: 'Reparación de fuga de agua',
      providerName: 'Carlos Mena',
      status: BookingStatus.pending,
      dateLabel: 'Mañana, 9:00 AM',
      location: 'Tena, Napo',
      rating: 4.8,
      reviews: 94,
      artwork: BookingReservaArtwork(emoji: '🚰', background: 0xFFE9F0F5),
    ),
    BookingReservaItem(
      title: 'Pintura de habitación',
      providerName: 'María López',
      status: BookingStatus.pending,
      dateLabel: '28 mayo, 11:00 AM',
      location: 'Tena, Napo',
      rating: 4.7,
      reviews: 56,
      artwork: BookingReservaArtwork(emoji: '🎨', background: 0xFFF2EAF8),
    ),
  ];

  const confirmed = [
    BookingReservaItem(
      title: 'Instalación eléctrica',
      providerName: 'Luis Paredes',
      status: BookingStatus.confirmed,
      dateLabel: '20 mayo, 2:30 PM',
      location: 'Tena, Napo',
      rating: 4.9,
      reviews: 76,
      artwork: BookingReservaArtwork(emoji: '🔌', background: 0xFFF3F2EA),
      providerAssignedLabel: 'Proveedor asignado: Luis Paredes',
    ),
    BookingReservaItem(
      title: 'Limpieza profunda de casa',
      providerName: 'Ana Torres',
      status: BookingStatus.confirmed,
      dateLabel: '23 mayo, 9:00 AM',
      location: 'Tena, Napo',
      rating: 4.9,
      reviews: 128,
      artwork: BookingReservaArtwork(emoji: '🧽', background: 0xFFEAF4E8),
      providerAssignedLabel: 'Proveedor asignado: Ana Torres',
    ),
  ];

  const completed = [
    BookingReservaItem(
      title: 'Pintura de habitación',
      providerName: 'María López',
      status: BookingStatus.completed,
      dateLabel: '10 mayo, 11:00 AM',
      location: 'Tena, Napo',
      rating: 4.7,
      reviews: 66,
      artwork: BookingReservaArtwork(emoji: '🎨', background: 0xFFF2EAF8),
    ),
    BookingReservaItem(
      title: 'Reparación de fuga de agua',
      providerName: 'Carlos Mena',
      status: BookingStatus.completed,
      dateLabel: '5 mayo, 9:00 AM',
      location: 'Tena, Napo',
      rating: 4.8,
      reviews: 94,
      artwork: BookingReservaArtwork(emoji: '🚰', background: 0xFFE9F0F5),
    ),
  ];

  switch (filter) {
    case BookingReservasFilter.all:
      return all;
    case BookingReservasFilter.pending:
      return pending;
    case BookingReservasFilter.confirmed:
      return confirmed;
    case BookingReservasFilter.completed:
      return completed;
  }
}
