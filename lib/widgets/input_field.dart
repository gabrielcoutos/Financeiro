import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final String label;
  final bool obscure;
  final TextInputType type;
  final TextEditingController controller;
  final int tamanho;
  final Stream<String> stream;
  final Function(String) onChanged;
  final List<TextInputFormatter> formatter;

  InputField({this.label,this.obscure,this.type,this.controller,this.tamanho,this.stream,this.onChanged,this.formatter});
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                  color: Colors.black
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[900])
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
              ),
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
            style: TextStyle(
                color: Colors.black
            ),
            obscureText: widget.obscure,
            keyboardType: widget.type,
            controller: widget.controller,
            maxLength: widget.tamanho,

          );
        }
    );
  }
}

