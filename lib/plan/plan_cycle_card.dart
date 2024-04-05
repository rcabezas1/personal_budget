import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:personal_budget/plan/plan.dart';
import 'package:personal_budget/plan/plan_cycle.dart';

import 'package:personal_budget/loaders/avatar_loader.dart';

import '../formats.dart';

class PlanCycleCard extends StatefulWidget {
  const PlanCycleCard({Key? key, required this.cycle, required this.plan})
      : super(key: key);

  final PlanCycle cycle;
  final List<Plan> plan;

  @override
  PlanCycleCardState createState() => PlanCycleCardState();
}

class PlanCycleCardState extends State<PlanCycleCard> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return GFCard(
      title: GFListTile(
          avatar:
              AvatarLoader(saving: saving, avatar: widget.cycle.clasification!),
          titleText: '${widget.cycle.category}',
          subTitleText: widget.cycle.clasification),
      content: SizedBox.square(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            _progress(),
            _valueMoney("Presupuesto:", widget.cycle.initialValue!),
          ])),
    );
  }

  _progress() {
    return GFProgressBar(
        percentage: _getPercentage(
            widget.cycle.initialValue!, widget.cycle.actualValue!),
        lineHeight: 45,
        backgroundColor: _getPercentageColor(widget.cycle.actualValue!),
        progressBarColor: GFColors.SECONDARY,
        child: Column(
          children: [
            const SizedBox.square(
              dimension: 4,
            ),
            Text(
              '\$${currencyFormat.format(widget.cycle.actualValue!)}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: GFColors.LIGHT,
                  fontSize: GFSize.SMALL),
            ),
          ],
        ));
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
      return GFColors.DANGER;
    }
    return GFColors.DARK;
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
            style:
                TextStyle(color: (value > 0 ? GFColors.DARK : GFColors.DANGER)),
          )
        ]);
  }
}
