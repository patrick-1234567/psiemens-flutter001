import 'package:flutter/material.dart';
import 'package:psiemens/theme/theme.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  static const List<String> valoresSodepianos = [
    'Honestidad',
    'Comunicación',
    'Autogestión',
    'Flexibilidad',
    'Calidad',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Acerca de SODEP'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [                Center(
                  child: Image.asset(
                    'assets/images/sodep_logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  context,
                  title: 'Valores Sodepianos',
                  child: Column(
                    children: valoresSodepianos.map((valor) => _buildValorItem(context, valor)).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  context,
                  title: 'Información de Contacto',
                  child: Column(
                    children: [
                      _buildInfoItem(context, Icons.phone, '(+595)981-131-694'),
                      const SizedBox(height: 12),
                      _buildInfoItem(context, Icons.email, 'info@sodep.com.py'),
                      const SizedBox(height: 12),
                      _buildInfoItem(
                        context, 
                        Icons.location_on,
                        'Bélgica 839 c/ Eusebio Lillo\nAsunción, Paraguay',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    '© 2025 SODEP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray07,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildValorItem(BuildContext context, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            valor,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                ),
          ),
        ),
      ],
    );
  }
}