import 'package:flutter_test/flutter_test.dart';
import 'package:psiemens/domain/comentario.dart';

void main() {
  group('Comentario', () {
    test('Crear comentario con userId', () {
      // Arrange
      const String userId = 'user_123';
      
      // Act
      final comentario = Comentario(
        id: '1',
        noticiaId: 'noticia_1',
        texto: 'Este es un comentario de prueba',
        fecha: '2023-05-19T12:00:00Z',
        autor: 'Usuario de prueba',
        likes: 0,
        dislikes: 0,
        userId: userId,
      );
      
      // Assert
      expect(comentario.userId, equals(userId));
    });
    
    test('Crear subcomentario con userId', () {
      // Arrange
      const String userId = 'user_456';
      
      // Act
      final subcomentario = Comentario(
        id: 'sub_1',
        noticiaId: 'noticia_1',
        texto: 'Este es un subcomentario de prueba',
        fecha: '2023-05-19T12:30:00Z',
        autor: 'Usuario de prueba 2',
        likes: 0,
        dislikes: 0,
        userId: userId,
        isSubComentario: true,
        idSubComentario: 'sub_1',
      );
      
      // Assert
      expect(subcomentario.userId, equals(userId));
      expect(subcomentario.isSubComentario, isTrue);
    });
    
    test('Serializar y deserializar comentario con userId', () {
      // Arrange
      const String userId = 'user_789';
      final comentario = Comentario(
        id: '2',
        noticiaId: 'noticia_2',
        texto: 'Comentario para serializar',
        fecha: '2023-05-20T10:00:00Z',
        autor: 'Usuario de prueba 3',
        likes: 5,
        dislikes: 2,
        userId: userId,
      );
      
      // Act
      final map = comentario.toMap();
      final deserializado = Comentario.fromMapSafe(map);
      
      // Assert
      expect(deserializado.userId, equals(userId));
      expect(deserializado.texto, equals(comentario.texto));
      expect(deserializado.autor, equals(comentario.autor));
    });
  });
}
