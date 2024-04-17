class EmployeeController {
  List<Map<String, dynamic>> employees = [  
  ];

  List<Map<String, dynamic>> getEmployees() {
    return employees;
  }

  void addEmployee(List<Map<String, dynamic>> employee) {
    employees.addAll(employee);
  }
}
