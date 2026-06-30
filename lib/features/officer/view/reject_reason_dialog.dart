import '../../../app_exporter.dart';

/// Dialog for entering a rejection reason
class RejectReasonDialog extends ConsumerStatefulWidget {
  /// Creates the reject reason dialog
  const RejectReasonDialog({super.key});

  @override
  ConsumerState<RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends ConsumerState<RejectReasonDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reject Application'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Reason for rejection',
          hintText: 'Provide a clear reason...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final reason = _controller.text.trim();
            if (reason.isEmpty) return;
            Navigator.pop(context, reason);
          },
          style: FilledButton.styleFrom(backgroundColor: errorRed),
          child: const Text('Reject'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
