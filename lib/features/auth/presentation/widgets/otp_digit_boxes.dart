import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Six-box OTP input with auto-advance focus. Isolated into its own
/// widget since the focus-management logic is fiddly enough to deserve
/// separation from the OTP screen's navigation/submit logic.
class OtpDigitBoxes extends StatefulWidget {
  const OtpDigitBoxes({super.key, required this.length, required this.onChanged});

  final int length;
  final ValueChanged<String> onChanged;

  @override
  State<OtpDigitBoxes> createState() => _OtpDigitBoxesState();
}

class _OtpDigitBoxesState extends State<OtpDigitBoxes> {
  late final List<TextEditingController> _controllers =
      List.generate(widget.length, (_) => TextEditingController());
  late final List<FocusNode> _focusNodes = List.generate(widget.length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _emit() => widget.onChanged(_controllers.map((c) => c.text).join());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 44,
          height: 52,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(counterText: ''),
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.length - 1) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              _emit();
            },
          ),
        );
      }),
    );
  }
}
