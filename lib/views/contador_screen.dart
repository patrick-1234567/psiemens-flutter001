import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/contador/contador_bloc.dart';
import 'package:psiemens/bloc/contador/contador_state.dart';
import 'package:psiemens/bloc/contador/contador_event.dart'; // Importa el BLoC del contador

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Contador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            BlocBuilder<ContadorBloc, ContadorEstado>(
              builder: (context, state) {
                if (state is ContadorValor) {
                  return Column(
                    children: [
                      Text(
                        '${state.valor}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        state.valor > 0
                            ? "Contador en positivo"
                            : state.valor < 0
                                ? "Contador en negativo"
                                : "Contador en cero",
                        style: TextStyle(
                          color: state.valor > 0
                              ? Colors.green
                              : state.valor < 0
                                  ? Colors.red
                                  : Colors.black,
                        ),
                      ),
                    ],
                  );
                }
                return const Text('Estado desconocido');
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
            tooltip: 'Increment',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'btnDecrement',
            onPressed: () => context.read<ContadorBloc>().add(DecrementEvent()),
            tooltip: 'Decrement',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'btnReset',
            onPressed: () => context.read<ContadorBloc>().add(ResetEvent()),
            tooltip: 'Reset',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}