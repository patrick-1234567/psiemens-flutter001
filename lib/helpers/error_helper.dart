import 'package:flutter/material.dart';
import 'package:psiemens/constants.dart';
class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Map<String, dynamic> getErrorMessageAndColor(int? statusCode) {
    String message;
    Color color;

    switch (statusCode) {
      case 400:
        message = '${NoticiaConstantes.mensajeError}';
        color = Colors.orange;
        break;
      case 401:
        message = '${ErrorConstantes.errorUnauthorized}';
        color = Colors.red;
        break;
      case 403:
        message = '${ErrorConstantes.errorUnauthorized}';
        color = Colors.redAccent;
        break;
      case 404:
        message = '${ErrorConstantes.errorNotFound}';
        color = Colors.grey;
        break;
      case 500:
        message = '${ErrorConstantes.errorServer}';
        color = Colors.red;
        break;
      default:
        message = 'Ocurrió un error desconocido.';
        color = Colors.black;
        break;
    }

    return {'message': message, 'color': color};
  }
}
