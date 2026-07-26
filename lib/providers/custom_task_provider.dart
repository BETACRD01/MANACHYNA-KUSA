import 'package:flutter/material.dart';
import '../models/custom_task/custom_task_model.dart';

class CustomTaskProvider with ChangeNotifier {
  final List<CustomTaskModel> _tasks = [];

  CustomTaskProvider() {
    _initializeMockTasks();
  }

  List<CustomTaskModel> get tasks => _tasks;

  List<CustomTaskModel> getOpenTasks() {
    return _tasks.where((t) => t.status == CustomTaskStatus.open).toList();
  }

  List<CustomTaskModel> getTasksForClient(String clientId) {
    return _tasks.where((t) => t.clientId == clientId).toList();
  }

  List<CustomTaskModel> getTasksForProvider(String providerId) {
    return _tasks.where((t) => 
      t.providerId == providerId || 
      t.offers.any((o) => o.providerId == providerId)
    ).toList();
  }

  void _initializeMockTasks() {
    final now = DateTime.now();

    _tasks.addAll([
      CustomTaskModel(
        id: 'task-1',
        clientId: 'client-mock-1',
        clientName: 'Juan Andrade',
        title: 'Limpieza profunda de jardín en Archidona',
        description: 'Se requiere cortar el césped de un patio amplio y podar dos árboles frutales medianos. Se dispone de herramientas básicas, pero preferible traer su propia podadora.',
        category: 'Jardinería',
        date: now.add(const Duration(days: 3)),
        budget: 45.0,
        address: 'Calle Principal, cerca al Parque Central, Archidona',
        status: CustomTaskStatus.open,
        offers: [
          CustomTaskOffer(
            id: 'off-1',
            providerId: 'prov-123',
            providerName: 'Carlos Shiguango',
            providerRating: 4.9,
            priceOffer: 40.0,
            message: 'Hola Juan, tengo podadora profesional a gasolina y herramientas de poda. Puedo realizar el trabajo este sábado por la mañana. Quedo a las órdenes.',
            createdAt: now.subtract(const Duration(hours: 2)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      CustomTaskModel(
        id: 'task-2',
        clientId: 'client-mock-2',
        clientName: 'Elena Vaca',
        title: 'Instalación de tomacorrientes y focos led en Tena',
        description: 'Instalar 4 tomacorrientes nuevos empotrados en la sala y cambiar 6 focos incandescentes a bombillos led de bajo consumo. Yo ya compré todos los materiales.',
        category: 'Electricidad',
        date: now.add(const Duration(days: 2)),
        budget: 35.0,
        address: 'Barrio Vista Hermosa, Av. del Chofer, Tena',
        status: CustomTaskStatus.open,
        offers: [],
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      CustomTaskModel(
        id: 'task-3',
        clientId: 'client-mock-3',
        clientName: 'Ramiro Chimbo',
        title: 'Reparación de filtración de lavabo en Misahuallí',
        description: 'El lavabo de la cocina tiene una fuga constante en el desagüe. Creo que el sifón de plástico se rompió y necesita cambio. Dispongo de un sifón nuevo comprado.',
        category: 'Fontanería',
        date: now.add(const Duration(days: 1)),
        budget: 25.0,
        address: 'Av. Del Río, sector cabañas turísticas, Puerto Misahuallí',
        status: CustomTaskStatus.open,
        offers: [
          CustomTaskOffer(
            id: 'off-2',
            providerId: 'prov-789',
            providerName: 'Luis Tapuy',
            providerRating: 4.7,
            priceOffer: 25.0,
            message: 'Estimado Ramiro, soy fontanero calificado y vivo a 10 minutos. Puedo pasar hoy mismo por la tarde a instalar el sifón y sellar las juntas. Saludos.',
            createdAt: now.subtract(const Duration(hours: 1)),
          ),
        ],
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      CustomTaskModel(
        id: 'task-4',
        clientId: 'client-mock-4',
        clientName: 'Sofía Alvarado',
        title: 'Pintado de sala de estar en Tena',
        description: 'Pintar una sala de estar pequeña de 5x4 metros. Las paredes están limpias y resanadas. Yo tengo la pintura lavable verde oliva y los rodillos listos.',
        category: 'Pintura',
        date: now.add(const Duration(days: 5)),
        budget: 60.0,
        address: 'Av. 15 de Noviembre, frente al Hospital, Tena',
        status: CustomTaskStatus.open,
        offers: [],
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
    ]);
  }

  void createCustomTask({
    required String clientId,
    required String clientName,
    required String title,
    required String description,
    required String category,
    required double budget,
    required String address,
    required DateTime date,
  }) {
    final newTask = CustomTaskModel(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      clientId: clientId,
      clientName: clientName,
      title: title,
      description: description,
      category: category,
      date: date,
      budget: budget,
      address: address,
      status: CustomTaskStatus.open,
      offers: [],
      createdAt: DateTime.now(),
    );

    _tasks.insert(0, newTask);
    notifyListeners();
  }

  void submitOffer({
    required String taskId,
    required String providerId,
    required String providerName,
    required double providerRating,
    required double priceOffer,
    required String message,
  }) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final newOffer = CustomTaskOffer(
      id: 'off-${DateTime.now().millisecondsSinceEpoch}',
      providerId: providerId,
      providerName: providerName,
      providerRating: providerRating,
      priceOffer: priceOffer,
      message: message,
      createdAt: DateTime.now(),
    );

    final updatedOffers = List<CustomTaskOffer>.from(_tasks[taskIndex].offers)..add(newOffer);
    _tasks[taskIndex] = _tasks[taskIndex].copyWith(offers: updatedOffers);
    notifyListeners();
  }

  void acceptOffer(String taskId, String offerId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    final offerIndex = task.offers.indexWhere((o) => o.id == offerId);
    if (offerIndex == -1) return;

    final acceptedOffer = task.offers[offerIndex];

    _tasks[taskIndex] = task.copyWith(
      status: CustomTaskStatus.accepted,
      providerId: acceptedOffer.providerId,
      providerName: acceptedOffer.providerName,
    );
    notifyListeners();
  }

  void completeTask(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    _tasks[taskIndex] = _tasks[taskIndex].copyWith(
      status: CustomTaskStatus.completed,
    );
    notifyListeners();
  }
}
