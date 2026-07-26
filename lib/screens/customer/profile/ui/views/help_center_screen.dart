// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_theme_colors.dart';

class _FaqItem {
  final String category;
  final String question;
  final String answer;

  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  final List<String> _categories = const [
    'Todos',
    'Servicios',
    'Pagos',
    'Reservas',
    'Seguridad',
  ];

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      category: 'Servicios',
      question: '¿Cómo solicito un servicio en la aplicación?',
      answer: 'Para solicitar un servicio, ve a la pantalla de inicio, selecciona la categoría de tu interés (limpieza, plomería, etc.), elige a tu proveedor favorito según su calificación e información, y pulsa en "Reservar Servicio". Completa el formulario de fecha y dirección y listo.',
    ),
    _FaqItem(
      category: 'Servicios',
      question: '¿Qué es MANACHYNA KUSA?',
      answer: 'Es una plataforma multiservicios premium especialmente diseñada para conectar de forma segura a clientes y proveedores locales dentro de la provincia de Napo, Ecuador. Valoramos el desarrollo local y facilitamos la contratación de oficios y servicios técnicos.',
    ),
    _FaqItem(
      category: 'Pagos',
      question: '¿Cuáles son los métodos de pago disponibles?',
      answer: 'Actualmente los pagos se coordinan y realizan directamente entre el cliente y el proveedor (pago en efectivo o transferencia bancaria al finalizar el trabajo). Próximamente habilitaremos pasarela de pagos integrada para tarjetas de crédito y débito.',
    ),
    _FaqItem(
      category: 'Reservas',
      question: '¿Puedo cancelar una reserva de servicio?',
      answer: 'Sí, puedes cancelar tu reserva desde la pestaña "Reservas". Te recomendamos hacerlo con al menos 2 horas de anticipación como cortesía hacia el proveedor del servicio para que pueda reorganizar su agenda.',
    ),
    _FaqItem(
      category: 'Seguridad',
      question: '¿Cómo se verifica la identidad de los proveedores?',
      answer: 'Todos los proveedores pasan por un riguroso proceso de registro donde verificamos sus antecedentes, documentos de identidad nacional, certificaciones técnicas (si aplican) y referencias comerciales antes de ser aprobados en la plataforma.',
    ),
    _FaqItem(
      category: 'Reservas',
      question: '¿Qué hago si el proveedor no asiste a la reserva?',
      answer: 'Si un proveedor no llega a la hora acordada, puedes reportarlo desde la pantalla de detalle de la reserva o ir directamente a la sección de "Contáctanos" en tu perfil para que nuestro equipo técnico tome cartas en el asunto de inmediato.',
    ),
    _FaqItem(
      category: 'Seguridad',
      question: '¿Cómo puedo cambiar la contraseña de mi cuenta?',
      answer: 'Si deseas cambiar tus datos de acceso o necesitas reestablecer tu contraseña, puedes cerrar sesión e iniciar el proceso de recuperación mediante tu correo electrónico en la pantalla de inicio de sesión o escribir directamente a soporte técnico.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_FaqItem> get _filteredFaqs {
    return _faqs.where((faq) {
      final matchesCategory = _selectedCategory == 'Todos' || faq.category == _selectedCategory;
      final matchesSearch = faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredFaqs;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: context.appBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: context.appTextPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Centro de Ayuda',
          style: TextStyle(
            color: context.appTextPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de búsqueda premium
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.appBorder.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: TextStyle(color: context.appTextPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar dudas o preguntas...',
                    hintStyle: TextStyle(color: context.appTextSecondary.withOpacity(0.7)),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: context.appTextSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            // Fila de Categorías
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                            fontSize: 13,
                            color: isSelected ? Colors.white : context.appTextSecondary,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          }
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: context.appSurface,
                        disabledColor: Colors.transparent,
                        elevation: 0,
                        pressElevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : context.appBorder.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Listado de FAQs
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final faq = filteredList[index];
                        return _FaqCard(faq: faq);
                      },
                    ),
            ),

            // Banner inferior para Contacto Directo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.appSurface,
                border: Border(
                  top: BorderSide(
                    color: context.appBorder.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Aún tienes dudas?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: context.appTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Escríbenos directamente y te ayudaremos.',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.appTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.contactUs);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text(
                      'Contacto',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: AppColors.error,
                size: 56,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No encontramos resultados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'No hay preguntas que coincidan con tu búsqueda "$_searchQuery". Intenta con otra palabra o ponte en contacto con nuestro equipo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: context.appTextSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'Todos';
                });
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Limpiar búsqueda',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  final _FaqItem faq;

  const _FaqCard({
    Key? key,
    required this.faq,
  }) : super(key: key);

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primary.withOpacity(0.5)
              : context.appBorder.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (_isExpanded ? AppColors.primary : context.appBorder).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.help_outline_rounded,
              color: _isExpanded ? AppColors.primary : context.appTextSecondary,
              size: 20,
            ),
          ),
          title: Text(
            widget.faq.question,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: _isExpanded ? AppColors.primary : context.appTextPrimary,
            ),
          ),
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            turns: _isExpanded ? 0.5 : 0.0,
            child: Icon(
              Icons.expand_more_rounded,
              color: _isExpanded ? AppColors.primary : context.appTextSecondary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                widget.faq.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: context.appTextSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
