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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/sodep_logo.png',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Valores Sodepianos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: valoresSodepianos.map(
                (valor) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12),
                      Text(
                        valor,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              'Información',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Espacio reservado para dirección y contacto
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: const Column(
                children: const [
                  Text(
                    'Contacto: (+595)981-131-694',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Correo electrónico: info@sodep.com.py',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Dirección: Bélgica 839 c/ Eusebio Lillo. Asunción. Paraguay',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '© 2025 SODEP',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.gray07,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}