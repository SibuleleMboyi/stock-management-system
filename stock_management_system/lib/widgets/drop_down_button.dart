import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/screens/signup/cubit/signup_cubit.dart';

class DropDownButton extends StatelessWidget {
  final String selectedItem;
  final List items;
  final String hintMessage;

  const DropDownButton({
    Key key,
    this.selectedItem,
    @required this.items,
    this.hintMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButton(
            isExpanded: true,
            hint: Text(hintMessage),
            value: state.userType,
            onChanged: (newItem) =>
                context.read<SignupCubit>().onSelectedItemChanged(newItem),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
          ),
        );
      },
    );
  }
}
