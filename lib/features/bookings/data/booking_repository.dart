import '../../../core/services/supabase_service.dart';
import '../../../models/booking_model.dart';

class BookingRepository {
  Future<List<BookingModel>> loadUserBookings(
    String userId, {
    required bool isProvider,
  }) async {
    final field = isProvider ? 'provider_uid' : 'client_uid';
    final rows = await SupabaseService.client
        .from('bookings')
        .select()
        .eq(field, userId)
        .order('created_at', ascending: false);

    return rows
        .map((row) => BookingModel.fromSupabase(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    final rows = await SupabaseService.client
        .from('bookings')
        .select()
        .eq('id', bookingId)
        .limit(1);

    if (rows.isEmpty) {
      return null;
    }

    return BookingModel.fromSupabase(Map<String, dynamic>.from(rows.first));
  }

  Future<BookingModel?> createBooking(BookingModel booking) async {
    final rows = await SupabaseService.client
        .from('bookings')
        .insert(booking.toInsertRow())
        .select()
        .limit(1);

    if (rows.isEmpty) {
      return null;
    }

    return BookingModel.fromSupabase(Map<String, dynamic>.from(rows.first));
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) {
    final updateData = <String, dynamic>{
      'status': bookingStatusToSupabase(status),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (status == BookingStatus.completed) {
      updateData['completed_at'] = DateTime.now().toIso8601String();
    }

    return SupabaseService.client
        .from('bookings')
        .update(updateData)
        .eq('id', bookingId);
  }

  Future<void> cancelBooking(String bookingId, String reason) {
    return SupabaseService.client
        .from('bookings')
        .update({
          'status': 'cancelled',
          'cancellation_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', bookingId);
  }

  Future<void> rateBooking(BookingModel booking, double rating, String? review) {
    return SupabaseService.client.from('reviews').upsert({
      'booking_id': booking.id,
      'client_uid': booking.clientId,
      'provider_uid': booking.providerId,
      'rating': rating.round(),
      'comment': review,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'booking_id');
  }
}
