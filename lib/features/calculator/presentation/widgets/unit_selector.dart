import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/unit_converter.dart';

class LengthUnitDropdown extends StatelessWidget {
  final LengthUnit selectedUnit;
  final ValueChanged<LengthUnit> onChanged;

  const LengthUnitDropdown({
    super.key,
    required this.selectedUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<LengthUnit>(
        value: selectedUnit,
        dropdownColor: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.of(context).secondaryText, size: 18),
        selectedItemBuilder: (BuildContext context) {
          return LengthUnit.values.map<Widget>((LengthUnit unit) {
            return Align(
              alignment: Alignment.centerRight,
              child: Text(
                unit.symbol,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.of(context).primaryText,
                ),
              ),
            );
          }).toList();
        },
        items: LengthUnit.values.map((unit) {
          return DropdownMenuItem<LengthUnit>(
            value: unit,
            child: Text('${unit.symbol} (${unit.label})'),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}

class WeightUnitDropdown extends StatelessWidget {
  final WeightUnit selectedUnit;
  final ValueChanged<WeightUnit> onChanged;

  const WeightUnitDropdown({
    super.key,
    required this.selectedUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<WeightUnit>(
        value: selectedUnit,
        dropdownColor: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(10),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.of(context).secondaryText, size: 18),
        selectedItemBuilder: (BuildContext context) {
          return WeightUnit.values.map<Widget>((WeightUnit unit) {
            return Align(
              alignment: Alignment.centerRight,
              child: Text(
                unit.symbol,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.of(context).primaryText,
                ),
              ),
            );
          }).toList();
        },
        items: WeightUnit.values.map((unit) {
          return DropdownMenuItem<WeightUnit>(
            value: unit,
            child: Text('${unit.symbol} (${unit.label})'),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}
