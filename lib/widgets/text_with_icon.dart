import 'package:flutter/material.dart';
import 'package:productos_app/ui/input_decorations.dart';

class TextWithIcon extends StatelessWidget {
  final IconData icono;
  final String name;
  final String? value;
  final double margin;
  const TextWithIcon(
      {Key? key,
      required this.name,
      required this.icono,
      this.value = "",
      this.margin = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icono),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "${name} : ${value}",
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}

class TextWithIconEdit extends StatelessWidget {
  final IconData icono;
  final String name;
  final String? value;
  final double margin;
  final bool editable;
  final void Function(String?) onChange;
  const TextWithIconEdit(
      {Key? key,
      required this.name,
      required this.icono,
      this.value = "",
      this.margin = 10,
      required this.editable,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: editable
          ? TextFormField(
            initialValue: value,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                color: Colors.black87,
                hintText: 'Ingrese ${name}',
                labelText: name,
                prefixIcon: icono,
              ),
              onChanged: onChange,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'El valor de ${name} es invalido';
              },
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icono),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "${name} : ${value}",
                  style: TextStyle(fontSize: 14.0),
                )
              ],
            ),
    );
  }
}
