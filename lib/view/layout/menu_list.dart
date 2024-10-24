enum MenuList { login, expense, cycle, charts, plan }

extension MenuListExtension on MenuList {
  String get menuTitle {
    switch (this) {
      case MenuList.login:
        return 'Sesion';

      case MenuList.expense:
        return 'Lista de gastos';

      case MenuList.charts:
        return 'Estadisticas';

      case MenuList.cycle:
        return 'Ciclos';

      case MenuList.plan:
        return 'Plan';
    }
  }
}
