import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qarzsiz/store/app/app_store.dart';

class TotalDeptWidget extends StatelessWidget {
  final double totalDept;
  final Map<String, double> deptDistribution; // Map of colors and their respective proportions

  const TotalDeptWidget({Key? key, required this.totalDept, required this.deptDistribution}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> colorBars = [];
    deptDistribution.forEach((color, proportion) {
      colorBars.add(
        Expanded(
          flex: (proportion * 100).toInt(),
          child: Container(color: Color(int.parse(color))),
        ),
      );
    });

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Total Dept'),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: colorBars,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text('${totalDept.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
