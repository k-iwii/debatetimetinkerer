import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'my_formats.dart';
import 'widgets/collapsible_menu.dart';

void main() {
  runApp(const MyApp());
}

enum ConnectionStatus { notConnected, connecting, connected }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const DebateTimerScreen(),
    );
  }
}

class DebateTimerScreen extends StatefulWidget {
  const DebateTimerScreen({super.key});

  @override
  State<DebateTimerScreen> createState() => _DebateTimerScreenState();
}

class _DebateTimerScreenState extends State<DebateTimerScreen> {
  ConnectionStatus _connectionStatus = ConnectionStatus.notConnected;
  bool _debateFormatExpanded = false;
  bool _timerOptionsExpanded = false;
  bool _ledOptionsExpanded = false;
  String _selectedDebateFormat = 'British Parliamentary';
  String _selectedDebateFormatB = 'World Schools';
  String _selectedTimerFormat = 'Stopwatch';
  Color _speechColour = const Color.fromARGB(255, 0, 255, 0);
  Color _protectedColour = const Color.fromARGB(255, 200, 255, 0);
  Color _graceColour = const Color.fromARGB(255, 255, 255, 90);
  Color _speechOverColour = const Color.fromARGB(255, 255, 0, 0);

  String get connectionStatusText {
    switch (_connectionStatus) {
      case ConnectionStatus.notConnected:
        return 'Not connected';
      case ConnectionStatus.connecting:
        return 'Connecting';
      case ConnectionStatus.connected:
        return 'Connected';
    }
  }

  void pickColour(BuildContext context, Color pickerColor,
          Function(Color) onColorChanged) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: const Color.fromARGB(255, 227, 227, 227),
          title: Text(
            "Select a colour",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildColourPicker(pickerColor, onColorChanged),
              TextButton(
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );

  Widget buildColourPicker(Color pickerColor, Function(Color) onColorChanged) =>
      ColorPicker(
        pickerColor: pickerColor,
        enableAlpha: false,
        onColorChanged: onColorChanged,
        colorPickerWidth: 300,
        pickerAreaHeightPercent: 0.7,
        displayThumbColor: true,
        paletteType: PaletteType.hueWheel,
        hexInputBar: false,
      );

  void _showDeviceSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeviceSearchDialog(
        onConnectionStatusChanged: (status) {
          setState(() {
            _connectionStatus = status;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF4F4F4F),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 48.0, top: 16.0, right: 48.0, bottom: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to your\nDebateTime Tinkerer!',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Customize your debate timer here!',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        connectionStatusText,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _connectionStatus == ConnectionStatus.connected
                              ? Colors.green
                              : _connectionStatus == ConnectionStatus.connecting
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Transform.translate(
                      offset: const Offset(-2, 0), // Move 2 pixels left
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF696969)),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4)),
                          minimumSize:
                              WidgetStateProperty.all<Size>(const Size(0, 28)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: () {
                          _showDeviceSearchDialog(context);
                        },
                        child: Text(
                          'Search for devices',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Settings',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CollapsibleMenu(
                    title: 'Debate format options',
                    isExpanded: _debateFormatExpanded,
                    onTap: () => setState(
                        () => _debateFormatExpanded = !_debateFormatExpanded),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Format A:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownMenu<String>(
                              initialSelection: _selectedDebateFormat,
                              menuHeight: 120,
                              width: 220,
                              textStyle: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                                constraints: BoxConstraints.tight(
                                    const Size.fromHeight(32)),
                                fillColor: const Color(0xFF696969),
                                filled: true,
                              ),
                              menuStyle: const MenuStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              dropdownMenuEntries: [
                                'British Parliamentary',
                                'World Schools'
                              ].map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.fromLTRB(16, 12, 0,
                                          12), // left, top, right, bottom
                                    ),
                                  ),
                                );
                              }).toList(),
                              onSelected: (String? newValue) {
                                setState(() {
                                  _selectedDebateFormat = newValue!;
                                });
                              },
                              trailingIcon: Transform.translate(
                                offset:
                                    const Offset(15, -5), // right 15px, up 5px
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              selectedTrailingIcon: Transform.translate(
                                offset: const Offset(15, 5),
                                child: Transform.rotate(
                                  angle: 3.14159, // 180 degrees in radians
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Format B:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownMenu<String>(
                              initialSelection: _selectedDebateFormatB,
                              menuHeight: 120,
                              width: 220,
                              textStyle: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                                constraints: BoxConstraints.tight(
                                    const Size.fromHeight(32)),
                                fillColor: const Color(0xFF696969),
                                filled: true,
                              ),
                              menuStyle: const MenuStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              dropdownMenuEntries: [
                                'British Parliamentary',
                                'World Schools'
                              ].map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.fromLTRB(16, 12, 0,
                                          12), // left, top, right, bottom
                                    ),
                                  ),
                                );
                              }).toList(),
                              onSelected: (String? newValue) {
                                setState(() {
                                  _selectedDebateFormatB = newValue!;
                                });
                              },
                              trailingIcon: Transform.translate(
                                offset:
                                    const Offset(15, -5), // right 15px, up 5px
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              selectedTrailingIcon: Transform.translate(
                                offset: const Offset(15, 5),
                                child: Transform.rotate(
                                  angle: 3.14159, // 180 degrees in radians
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Transform.translate(
                            offset: const Offset(-2, 0), // Move 2 pixels left
                            child: FilledButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color(0xFF696969)),
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4)),
                                minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(0, 28)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyFormatsPage()),
                                );
                              },
                              child: Text(
                                'Edit formats',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  CollapsibleMenu(
                    title: 'Timer options',
                    isExpanded: _timerOptionsExpanded,
                    onTap: () => setState(
                        () => _timerOptionsExpanded = !_timerOptionsExpanded),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Timer format:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownMenu<String>(
                              initialSelection: _selectedTimerFormat,
                              menuHeight: 120,
                              width: 190,
                              textStyle: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                                constraints: BoxConstraints.tight(
                                    const Size.fromHeight(32)),
                                fillColor: const Color(0xFF696969),
                                filled: true,
                              ),
                              menuStyle: const MenuStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              dropdownMenuEntries: [
                                'Stopwatch',
                                'Timer'
                              ].map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.fromLTRB(16, 12, 0,
                                          12), // left, top, right, bottom
                                    ),
                                  ),
                                );
                              }).toList(),
                              onSelected: (String? newValue) {
                                setState(() {
                                  _selectedTimerFormat = newValue!;
                                });
                              },
                              trailingIcon: Transform.translate(
                                offset:
                                    const Offset(15, -5), // right 15px, up 5px
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              selectedTrailingIcon: Transform.translate(
                                offset: const Offset(15, 5),
                                child: Transform.rotate(
                                  angle: 3.14159, // 180 degrees in radians
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  CollapsibleMenu(
                    title: 'LED options',
                    isExpanded: _ledOptionsExpanded,
                    onTap: () => setState(
                        () => _ledOptionsExpanded = !_ledOptionsExpanded),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Speech colour:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                pickColour(
                                    context,
                                    _speechColour,
                                    (colour) =>
                                        setState(() => _speechColour = colour));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF696969), width: 4),
                                  color: _speechColour,
                                ),
                                width: 22,
                                height: 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RGB(${(_speechColour.r * 255.0).round()}, ${(_speechColour.g * 255.0).round()}, ${(_speechColour.b * 255.0).round()})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Protected colour:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                pickColour(
                                    context,
                                    _protectedColour,
                                    (colour) => setState(
                                        () => _protectedColour = colour));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF696969), width: 4),
                                  color: _protectedColour,
                                ),
                                width: 22,
                                height: 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RGB(${(_protectedColour.r * 255.0).round()}, ${(_protectedColour.g * 255.0).round()}, ${(_protectedColour.b * 255.0).round()})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Grace colour:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                pickColour(
                                    context,
                                    _graceColour,
                                    (colour) =>
                                        setState(() => _graceColour = colour));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF696969), width: 4),
                                  color: _graceColour,
                                ),
                                width: 22,
                                height: 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RGB(${(_graceColour.r * 255.0).round()}, ${(_graceColour.g * 255.0).round()}, ${(_graceColour.b * 255.0).round()})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Speech over colour:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                pickColour(
                                    context,
                                    _speechOverColour,
                                    (colour) => setState(
                                        () => _speechOverColour = colour));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF696969), width: 4),
                                  color: _speechOverColour,
                                ),
                                width: 22,
                                height: 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RGB(${(_speechOverColour.r * 255.0).round()}, ${(_speechOverColour.g * 255.0).round()}, ${(_speechOverColour.b * 255.0).round()})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF696969)),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4)),
                      minimumSize:
                          WidgetStateProperty.all<Size>(const Size(0, 28)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Handle save settings
                    },
                    child: Text(
                      'Save changes',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class DeviceSearchDialog extends StatefulWidget {
  final Function(ConnectionStatus) onConnectionStatusChanged;

  const DeviceSearchDialog({
    super.key,
    required this.onConnectionStatusChanged,
  });

  @override
  State<DeviceSearchDialog> createState() => _DeviceSearchDialogState();
}

class _DeviceSearchDialogState extends State<DeviceSearchDialog> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startBleScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _startBleScan() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _scanResults.clear();
    });

    try {
      // Check if Bluetooth is available
      if (await FlutterBluePlus.isSupported == false) {
        setState(() {
          _errorMessage = "Bluetooth not available on this device";
          _isScanning = false;
        });
        return;
      }

      // Check if Bluetooth is on
      if (await FlutterBluePlus.adapterState.first !=
          BluetoothAdapterState.on) {
        setState(() {
          _errorMessage = "Please turn on Bluetooth";
          _isScanning = false;
        });
        return;
      }

      final Guid myServiceUuid = Guid("d4b24792-2610-4be4-97fa-945af5cf144e");

      // Start scanning with the filter
      FlutterBluePlus.scanResults.listen((results) {
        // Filter results to only include devices advertising your UUID
        final filtered = results
            .where(
                (r) => r.advertisementData.serviceUuids.contains(myServiceUuid))
            .toList();

        setState(() {
          _scanResults = filtered;
        });
      });

      await FlutterBluePlus.startScan(
        withServices: [myServiceUuid], // only scan for devices with this UUID
        timeout: const Duration(seconds: 10),
      );

      setState(() {
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error scanning: $e";
        _isScanning = false;
      });
    }
  }

  Future<void> _connectToDevice(ScanResult scanResult) async {
    // Update main screen connection status to connecting
    widget.onConnectionStatusChanged(ConnectionStatus.connecting);

    try {
      // Connect to the device
      await scanResult.device.connect();

      // Update to connected status
      widget.onConnectionStatusChanged(ConnectionStatus.connected);
    } catch (e) {
      // Connection failed, revert to not connected
      widget.onConnectionStatusChanged(ConnectionStatus.notConnected);

      setState(() {
        _errorMessage = "Failed to connect: $e";
      });
    }

    // Close dialog after connection attempt
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFF4F4F4F),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search for Devices',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            if (_isScanning) ...[
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Scanning for devices...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ] else if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ] else ...[
              Text(
                'Found ${_scanResults.length} device(s):',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 85, 85, 85),
                  border: Border.all(color: const Color(0xFF3A3A3A), width: 2),
                ),
                child: _scanResults.isEmpty
                    ? Center(
                        child: Text(
                          'No devices found',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _scanResults.length,
                        itemBuilder: (context, index) {
                          final scanResult = _scanResults[index];
                          final deviceName = scanResult
                                  .device.platformName.isNotEmpty
                              ? scanResult.device.platformName
                              : scanResult.advertisementData.advName.isNotEmpty
                                  ? scanResult.advertisementData.advName
                                  : 'Unknown Device';

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF696969),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 98, 98, 98)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deviceName,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'RSSI: ${scanResult.rssi} dBm',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            const Color(0xFF4F4F4F)),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4)),
                                    minimumSize: WidgetStateProperty.all<Size>(
                                        const Size(0, 28)),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => _connectToDevice(scanResult),
                                  child: Text(
                                    'Connect',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (!_isScanning)
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF696969)),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4)),
                      minimumSize:
                          WidgetStateProperty.all<Size>(const Size(0, 28)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: _startBleScan,
                    child: Text(
                      'Scan Again',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Spacer(),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFF696969)),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4)),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(0, 28)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
