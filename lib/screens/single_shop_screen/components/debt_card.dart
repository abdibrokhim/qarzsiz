import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalDeptWidget extends StatelessWidget {
  final double totalDept;
  final String shopName;
  final String imageUrl;

  const TotalDeptWidget({
    Key? key,
    required this.totalDept,
    required this.shopName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assuming the total debt is within the range of 0 to 200,000 for the proportion calculation
    var deptProportion = totalDept / 200000;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(children: [
        Expanded(child: 
        Image.network(
                imageUrl,
                fit: BoxFit.fitHeight,
              ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Dept from $shopName',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * deptProportion,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${NumberFormat('#,##0').format(totalDept)} UZS',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      ),
      ],
      )

    );
  }
}
