class Appointment {
  final String id;
  final String service;
  final String customer;
  final String date;
  final String time;
  final String address;
  final int price;
  final String status;

  Appointment({
    required this.id,
    required this.service,
    required this.customer,
    required this.date,
    required this.time,
    required this.address,
    required this.price,
    required this.status,
  });
}
