import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  Future<List<Map<String, dynamic>>> fetchEmployee() async {
    var url = Uri.parse("https://employee-9yq3.onrender.com/employees");
    var headers = {'Content-Type': 'application/json'};
    var client = http.Client();
    print("i am here");

    try {
      var response = await client.get(
        url,
        headers: headers,
      );
      print("iam here tooo $response  ${response.statusCode}");

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> employees = [];

        try {
          // Parse the JSON response
          var jsonData = json.decode(response.body);

          print(jsonData);

          for (var employee in jsonData) {
            employees.add(employee);
          }
          return employees;
        } catch (e) {
          throw Exception('Failed to parse JSON');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } finally {
      client.close(); // Close the HTTP client to avoid resource leaks
    }
  }
}
