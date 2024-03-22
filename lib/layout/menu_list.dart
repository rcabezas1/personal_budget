enum MenuList { expense, cycle, charts, plan }

extension MenuListExtension on MenuList {
  String get menuTitle {
    switch (this) {
      case MenuList.expense:
        return 'Lista de gastos';

      case MenuList.charts:
        return 'Estadisticas';

      case MenuList.cycle:
        return 'Ciclos';

      case MenuList.plan:
        return 'Plan';

      default:
        return '';
    }
  }
}
