import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zylo_business_assignment/employee/employee_controller.dart';
import 'package:intl/intl.dart';
import 'package:zylo_business_assignment/employee/employee_service.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  bool isLoading = true;
  EmployeeController employeeController = EmployeeController();
  TextEditingController searchController = TextEditingController();
  EmployeeService employeeService = EmployeeService();
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  void fetchEmployees() async {
    List<Map<String, dynamic>> employeesList =
        await employeeService.fetchEmployee();
    setState(() {
      employeeController.addEmployee(employeesList);
      employees = employeeController.getEmployees();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.75,
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 209, 203, 203),
                        width: 2),
                    borderRadius: BorderRadius.circular(screenWidth * 0.07)),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) => setState(() {
                    employees = employeeController
                        .getEmployees()
                        .where((element) => element['name']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  }),
                  decoration: const InputDecoration(
                    hintText: 'Search for employees ....',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              IconButton(
                onPressed: () => (),
                icon: const Icon(
                  Icons.filter_alt,
                  size: 40,
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Active & 5 YOE ",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                    color: const Color.fromARGB(255, 141, 228, 144),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Text(
                    "Inactive ",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                    color: Colors.blue.shade50,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : employeetable(context),
          SizedBox(height: screenHeight * 0.04),
        ],
      ),
    );
  }

  Widget employeetable(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    int j = 0;
    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      bool isEven = false;
      isEven = !isEven;
      DateTime currentDate = DateTime.now();
      print("emplo333yees $employees 12121");
      for (var employee in employees) {
        print("333 $employee 12121");
        DateFormat dateFormat = DateFormat('dd-MM-yyyy');
        String dateString = employee['dateOfJoining'] ?? "01-01-2022";
        List<DataCell> cells = [];
        employee.forEach((key, value) => cells.add(
              DataCell(
                Container(
                  height: screenHeight * (40 / screenWidth),
                  decoration: BoxDecoration(
                      color: (employee['active'] &&
                              dateFormat
                                  .parse(employee['dateOfJoining'])
                                  .isBefore(DateTime.now()
                                      .subtract(Duration(days: 1825))))
                          ? const Color.fromARGB(255, 181, 227, 183)
                          : Colors.blue.shade50),
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        employee[key] == true
                            ? "Yes"
                            : employee[key] == false
                                ? "No"
                                : employee[key].toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
        rows.add(DataRow(
          cells: cells,
        ));
      }
      return rows;
    }

    List<DataColumn> buildColumns() {
      List<DataColumn> columns = [];
      columns.add(
        DataColumn(
          label: Expanded(
            child: Container(
              height: 40,
              width: screenWidth * (40 / screenWidth),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 226, 230),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  'Id',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      columns.add(
        DataColumn(
          label: Expanded(
            child: Container(
              height: 40,
              width: screenWidth * (60 / screenWidth),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 226, 230),
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  "Name",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      columns.add(
        DataColumn(
          label: Expanded(
            child: Container(
              height: 40,
              width: screenWidth * (60 / screenWidth),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 226, 230),
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  "Role",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      columns.add(
        DataColumn(
          label: Expanded(
            child: Container(
              height: 40,
              width: screenWidth * (60 / screenWidth),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 226, 230),
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  "active",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      columns.add(
        DataColumn(
          label: Expanded(
            child: Container(
              height: 40,
              width: screenWidth * (60 / screenWidth),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 226, 230),
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  "Joining Date",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      columns.add(
        DataColumn(
          label: Expanded(
            child: Container(
              height: 40,
              width: screenWidth * (60 / screenWidth),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 242, 226, 230),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                  )),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: Text(
                  "Contact",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      return columns;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: DataTable(
          dividerThickness: 0,
          columnSpacing: 0,
          horizontalMargin: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          columns: buildColumns(),
          rows: buildRows(),
        ),
      ),
    );
  }
}
