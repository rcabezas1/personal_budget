import 'package:flutter/material.dart';
import 'package:personal_budget/model/plan/plan.dart';
import 'package:personal_budget/model/plan/plan_cycle.dart';
import 'package:personal_budget/view/inputs/formats.dart';
import 'package:personal_budget/view/loaders/avatar_loader.dart';

class PlanCycleCard extends StatefulWidget {
  const PlanCycleCard({super.key, required this.cycle, required this.plan});

  final PlanCycle cycle;
  final List<Plan> plan;

  @override
  PlanCycleCardState createState() => PlanCycleCardState();
}

class PlanCycleCardState extends State<PlanCycleCard> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        color: Colors.grey.shade50,
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          titleAlignment: ListTileTitleAlignment.top,
          title: Row(
            spacing: 10,
            children: [
              AvatarLoader(saving: saving, avatar: widget.cycle.clasification!),
              Text('${widget.cycle.category}')
            ],
          ),
          subtitle: SizedBox.square(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Text('${widget.cycle.clasification}'),
                _progress(),
                _valueMoney("Presupuesto:", widget.cycle.initialValue!),
              ])),
        ));
  }

  _progress() {
    return Column(
      children: [
        Text(
          '\$${currencyFormat.format(widget.cycle.actualValue!)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        LinearProgressIndicator(
          value: _getPercentage(
              widget.cycle.initialValue!, widget.cycle.actualValue!),
          minHeight: 20,
          borderRadius: BorderRadius.circular(20),
          backgroundColor: _getPercentageColor(widget.cycle.actualValue!),
        )
      ],
    );
  }

  double _getPercentage(double initial, double actual) {
    var percentage = actual / initial;
    if (percentage >= 0) {
      return percentage;
    }
    return 0;
  }

  _getPercentageColor(double actual) {
    if (actual < 0) {
      return Colors.red;
    }
    return Colors.blueGrey;
  }

  _valueMoney(String title, double value) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox.square(dimension: 10),
          Text(
            '\$${currencyFormat.format(value)}',
            style: TextStyle(color: (value > 0 ? Colors.blueGrey : Colors.red)),
          )
        ]);
  }
}
