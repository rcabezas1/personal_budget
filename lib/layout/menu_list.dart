enum MenuList { budget, cycle, charts }

extension MenuListExtension on MenuList {
  String get menuTitle {
    switch (this) {
      case MenuList.budget:
        return 'Lista de gastos';

      case MenuList.charts:
        return 'Estadisticas';

      case MenuList.cycle:
        return 'Ciclos';
      default:
        return '';
    }
  }
}
