import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PreferenciasState extends Equatable {
  final List<String> categoriasSeleccionadas;
  final bool mostrarFavoritos;
  final String? palabraClave;
  final DateTime? fechaDesde;
  final DateTime? fechaHasta;
  final String ordenarPor;
  final bool ascendente;
  
  const PreferenciasState({
    this.categoriasSeleccionadas = const [],
    this.mostrarFavoritos = false,
    this.palabraClave,
    this.fechaDesde,
    this.fechaHasta,
    this.ordenarPor = 'fecha',
    this.ascendente = false,
  });

  PreferenciasState copyWith({
    List<String>? categoriasSeleccionadas,
    bool? mostrarFavoritos,
    String? palabraClave,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    String? ordenarPor,
    bool? ascendente,
  }) {
    return PreferenciasState(
      categoriasSeleccionadas: categoriasSeleccionadas ?? this.categoriasSeleccionadas,
      mostrarFavoritos: mostrarFavoritos ?? this.mostrarFavoritos,
      palabraClave: palabraClave ?? this.palabraClave,
      fechaDesde: fechaDesde ?? this.fechaDesde,
      fechaHasta: fechaHasta ?? this.fechaHasta,
      ordenarPor: ordenarPor ?? this.ordenarPor,
      ascendente: ascendente ?? this.ascendente,
    );
  }

  @override
  List<Object?> get props => [
    categoriasSeleccionadas,
    mostrarFavoritos,
    palabraClave,
    fechaDesde,
    fechaHasta,
    ordenarPor,
    ascendente,
  ];
}