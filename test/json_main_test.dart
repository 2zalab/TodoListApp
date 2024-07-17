import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/TodoApp/jsonMain.dart'; // Ajustez le chemin selon votre structure
import 'dart:convert';

void main() {
  group('JsonMain Tests', () {
    test('Parse JSON data', () {
      final jsonString = '{"name": "John", "age": 30}';
      final data = json.decode(jsonString);

      expect(data['name'], 'John');
      expect(data['age'], 30);
    });

    test('Handle JSON errors', () {
      final jsonString = '{"name": "John", "age": 30';
      try {
        json.decode(jsonString);
        fail('Expected a FormatException to be thrown');
      } catch (e) {
        expect(e, isFormatException);
      }
    });
  });
}
