// ignore_for_file: slash_for_doc_comments

import 'package:postgres/postgres.dart';

// Initialize the connection

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Connection> initializeDatabase() async {
    final conn = await Connection.open(
      Endpoint(
        host: 'localhost', // Host
        port: 5433, // Port
        database: 'automatic_birthday_congratulator', // Database name
        username: 'postgres', // Username
        password: 'C4ss1opeia!12', // Password
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    try {
      return conn;
    } catch (e) {
      print('Database connection error: $e');
      rethrow; // Rethrow the exception to handle it in the calling function.
    }
  }

  Future<List<Map<String, dynamic>>> fetchData(
    String query,
    int messageid,
  ) async {
    final Connection conn = await initializeDatabase();
    try {
      final results = await conn.execute(
        Sql.named(query),
        parameters: {'messageid': messageid},
      );
      final List<Map<String, dynamic>> data = [];
      for (final row in results) {
        data.add(row.toColumnMap());
      }
      return data;
    } catch (e) {
      print('Query execution error: $e');
      rethrow;
    } finally {
      await conn.close(); // Close the connection after use.
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllData(String query) async {
    final Connection conn = await initializeDatabase();
    try {
      final results = await conn.execute(Sql.named(query));
      final List<Map<String, dynamic>> data = [];
      for (final row in results) {
        data.add(row.toColumnMap());
      }
      return data;
    } catch (e) {
      print('Query execution error: $e');
      rethrow;
    } finally {
      await conn.close(); // Close the connection after use.
    }
  }
}

/** 
  Future<int> executeQuery(String query, [List<dynamic>? params]) async {
    final conn = await initializeDatabase();
    try {
      final results = await conn.execute(query, params);
      return results.affectedRows ?? 0; // Return affected rows or 0 if null.
    } catch (e) {
      print('Query execution error: $e');
      rethrow;
    } finally {
      await conn.close(); // Close the connection after use.
    }
  }

*/

/**  Example usage in your Flutter code:
void main() async {
  final dbHelper = DatabaseHelper();

  try {
    // Example: Fetch data
    final data = await dbHelper.fetchData('SELECT * FROM your_table');
    print('Fetched data: $data');

    // Example: Insert data
    final affectedRows = await dbHelper.executeQuery(
      'INSERT INTO your_table (column1, column2) VALUES (?, ?)',
      ['value1', 'value2'],
    );
    print('Rows affected: $affectedRows');

    // Example: Update data
    final updateAffectedRows = await dbHelper.executeQuery(
      'UPDATE your_table SET column1 = ? WHERE id = ?',
      ['new_value', 1],
    );
    print('Rows affected: $updateAffectedRows');

    // Example: Delete data
    final deleteAffectedRows = await dbHelper.executeQuery(
      'DELETE FROM your_table WHERE id = ?',
      [1],
    );
    print('Rows affected: $deleteAffectedRows');
  } catch (e) {
    print('An error occurred: $e');
  }
}
*/
