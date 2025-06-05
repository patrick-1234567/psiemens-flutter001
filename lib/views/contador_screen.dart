import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/contador/contador_bloc.dart';
import 'package:psiemens/bloc/contador/contador_state.dart';
import 'package:psiemens/bloc/contador/contador_event.dart';
import 'package:psiemens/theme/theme.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Contador'),
      ),
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Has presionado el botón estas veces:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<ContadorBloc, ContadorEstado>(
              builder: (context, state) {
                if (state is ContadorValor) {
                  return Column(
                    children: [
                      Text(
                        '${state.valor}',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.valor > 0
                            ? "Contador en positivo"
                            : state.valor < 0
                                ? "Contador en negativo"
                                : "Contador en cero",
                        style: TextStyle(
                          fontSize: 16,
                          color: state.valor > 0
                              ? AppColors.secondary
                              : state.valor < 0
                                  ? Colors.red
                                  : AppColors.gray07,
                        ),
                      ),
                    ],
                  );
                }
                return const Text(
                  'Estado desconocido',
                  style: TextStyle(color: AppColors.gray07),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btnIncrement',
            onPressed: () => context.read<ContadorBloc>().add(IncrementEvent()),
            tooltip: 'Incrementar',
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'btnDecrement',
            onPressed: () => context.read<ContadorBloc>().add(DecrementEvent()),
            tooltip: 'Decrementar',
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'btnReset',
            onPressed: () => context.read<ContadorBloc>().add(ResetEvent()),
            tooltip: 'Reiniciar',
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}