import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'controller/form_controller.dart';
import 'feedback_list.dart';
import 'model/form.dart';
import 'monumental_model.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  late List <SalesData> _chartData;
  late TooltipBehavior _tooltipBehavior;


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed.
      FeedbackForm feedbackForm = FeedbackForm(
          nameController.text,
          emailController.text,
          mobileNoController.text,
          feedbackController.text);

      FormController formController = FormController();

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(feedbackForm, (String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          // Feedback is saved succesfully in Google Sheets.
          _showSnackbar("Feedback Submitted");
        } else {
          // Error Occurred while saving data in Google Sheets.
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,

          body: Column(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: SfCartesianChart(
                    title: ChartTitle(text:"ZGraph"),
                    //legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      LineSeries<SalesData,double>(
                        name: "Stock Variations",
                          dataSource: _chartData,
                          xValueMapper: (SalesData sales,_) => sales.year,
                          yValueMapper: (SalesData sales,_) => sales.sales,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                      ),
                    ],
                    primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.simpleCurrency(decimalDigits:0)),
                    ),
                  ),
                ),




              Container(
                child: Column(
                  children: <Widget>[
                    /*TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Valid Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Name'
                      ),
                    ),*/
                    /*TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (!value!.contains("@")) {
                          return 'Enter Valid Email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email'
                      ),
                    ),*/
                    /*TextFormField(
                      controller: mobileNoController,
                      validator: (value) {
                        if (value?.trim().length != 10) {
                          return 'Enter 10 Digit Mobile Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                    ),*/
                    /*TextFormField(
                      controller: feedbackController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Valid Feedback';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: 'Feedback'
                      ),
                    ),*/
                    /*RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed:_submitForm,
                      child: Text('Submit Feedback'),
                    ),*/


                /*RaisedButton(
                      color: Colors.lightBlueAccent,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackListScreen(),
                            ));
                      },
                      child: Text('View Feedback'),
                    ),*/

                    MyHomePage(monuments: fetchMonument()),

                  ],
                ),




              )
            ],
          ),
        ));
  }

  List<SalesData> getChartData(){
    final List<SalesData> chartData = [
      SalesData(2015, 25),
      SalesData(2016, 17),
      SalesData(2017, 12),
      SalesData(2018, 16),
      SalesData(2019, 19),
      SalesData(2020, 17),
    ];
    return chartData;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}

/*
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Half yearly sales analysis'), //Chart title.
                    legend: Legend(isVisible: true), // Enables the legend.
                    tooltipBehavior: TooltipBehavior(enable: true), // Enables the tooltip.
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                          dataSource: [
                            SalesData('Jan', 35),
                            SalesData('Feb', 28),
                            SalesData('Mar', 34),
                            SalesData('Apr', 32),
                            SalesData('May', 40)
                          ],
                          xValueMapper: (SalesData sales, _) => sales.year,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                          dataLabelSettings: DataLabelSettings(isVisible: true) // Enables the data label.
                      )
                    ]
                )
            )
        )
    );
  }
}

*/