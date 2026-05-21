import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/utils/transfer/transfer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/confirm_dialog.dart';

class ShareReceiveScreen extends StatefulWidget {
  final Box<int> sandBox;
  const ShareReceiveScreen({super.key, required this.sandBox});

  @override
  State<ShareReceiveScreen> createState() => _ShareReceiveScreenState();
}

class _ShareReceiveScreenState extends State<ShareReceiveScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //toolbarHeight: 40,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.upload), text: 'Share'),
              Tab(icon: Icon(Icons.download), text: 'Receive'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShareTab(sandBox: widget.sandBox),
            ReceiveTab(sandBox: widget.sandBox),
          ],
        ),
      ),
    );
  }
}

class ShareTab extends StatefulWidget {
  final Box<int> sandBox;
  const ShareTab({super.key, required this.sandBox});

  // initState by getting QR and text

  @override
  State<ShareTab> createState() => _ShareTabState();
}

class _ShareTabState extends State<ShareTab> {
  String? shareText;

  @override
  void initState() {
    super.initState();
    generateShareData();
  }

  void generateShareData() {
    if (widget.sandBox.isEmpty) {
      return;
    }

    shareText = serialise(widget.sandBox);
  }

  @override
  Widget build(BuildContext context) {
    // simple UI for empty
    if (widget.sandBox.isEmpty) {
      return const Center(child: Text('Nothing to share, Sandbox is empty!'));
    }

    // return QR and text
    if (shareText == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR widget
            QrImageView(
              data: shareText!,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SelectableText(shareText!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: shareText!));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Text copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Text'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiveTab extends StatefulWidget {
  final Box<int> sandBox;
  const ReceiveTab({super.key, required this.sandBox});

  @override
  State<ReceiveTab> createState() => _ReceiveTabState();
}

class _ReceiveTabState extends State<ReceiveTab> {
  bool handled = false;
  String? scannedText;
  bool hasCameraError = false;
  String? cameraErrorMessage;

  late final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    detectionTimeoutMs: 500,
    torchEnabled: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> handleQr(String value) async {
    if (handled) return;

    handled = true;

    try {
      scannedText = value;

      // final data = deserialise(value);

      if (!mounted) return;

      await controller.stop();

      /*
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code received successfully'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      */

      setState(() {});
    } catch (e) {
      handled = false;

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid QR code: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (handled && scannedText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final transferResult = deserialise(scannedText!);

        // invalid transfer data
        if (transferResult == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid data!"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );

          setState(() {
            handled = false;
            scannedText = null;
            Navigator.pop(context);
          });

          return;
        }

        // valid transfer data

        // overwrite dialog
        bool? result;
        if (widget.sandBox.length > 0) {
          result = await confirmOverwriteSandbox(
            context: context,
            length: widget.sandBox.length,
          );
        }

        if (widget.sandBox.length > 0 && result == null) {
          return; // nop
          // overwrite
        } else if (widget.sandBox.length > 0 && result == true) {
          await widget.sandBox.clear();
        }

        // add moves
        await widget.sandBox.addAll(transferResult);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transfer items added to Sandbox!'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        Navigator.pop(context);
      });
    }

    // initial QR scan window
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          errorBuilder: (context, error) {
            if (!hasCameraError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                setState(() {
                  hasCameraError = true;
                  cameraErrorMessage =
                      error.errorDetails?.message ?? error.toString();
                });
              });
            }

            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Scanning not available",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.errorDetails?.message ?? error.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;

            for (final barcode in barcodes) {
              final String? value = barcode.rawValue;

              if (value != null) {
                handleQr(value);
                break;
              }
            }
          },
        ),

        // Overlay
        if (!hasCameraError)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

        const Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Point camera at QR code',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),

        // button for text input
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Center(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final clipboardData = await Clipboard.getData('text/plain');
                setState(() {
                  scannedText = clipboardData?.text ?? "";
                  handled = true;
                });
              },
              child: Text('Paste Text From Clipboard'),
            ),
          ),
        ),
      ],
    );
  }
}
