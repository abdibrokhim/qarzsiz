import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalDebtCard extends StatelessWidget {
  final double totalDebt;
  final double unpaidDebt; // Total amount of debt that is unpaid

  const TotalDebtCard({
    Key? key,
    required this.totalDebt,
    required this.unpaidDebt, // Pass the unpaid debt amount here
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the proportion of unpaid debt
    final double unpaidProportion = (totalDebt == 0) ? 0 : unpaidDebt / totalDebt;

    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Column(
        children: [
          const Text('Total Debt'),
          const SizedBox(height: 5),
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
                width: MediaQuery.of(context).size.width * unpaidProportion, // Width is proportional to unpaid debt
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${NumberFormat('#,##0').format(totalDebt)} UZS',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
