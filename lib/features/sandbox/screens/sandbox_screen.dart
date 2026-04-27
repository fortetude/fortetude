import 'package:flutter/material.dart';

class SandboxScreen extends StatelessWidget {

  const SandboxScreen({super.key});

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(title: Align(alignment: Alignment.center, child: Text('Sandbox Screen'))),
      body: Placeholder()
    );
  }
}