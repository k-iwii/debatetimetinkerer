import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

enum ConnectionStatus { notConnected, searching, connected }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ConnectionStatus _connectionStatus = ConnectionStatus.notConnected;
  bool _debateFormatExpanded = false;
  bool _timerOptionsExpanded = false;
  bool _ledOptionsExpanded = false;
  String _selectedDebateFormat = 'British Parliamentary';
  String _selectedDebateFormatB = 'World Schools';
  String _selectedTimerFormat = 'Stopwatch';
  bool _dropdownAOpen = false;
  bool _dropdownBOpen = false;
  Color _speechColor = const Color.fromARGB(255, 0, 255, 8);

  String get connectionStatusText {
    switch (_connectionStatus) {
      case ConnectionStatus.notConnected:
        return 'Not connected';
      case ConnectionStatus.searching:
        return 'Searching';
      case ConnectionStatus.connected:
        return 'Connected';
    }
  }

  Widget _buildCollapsibleMenu(
      String title, bool isExpanded, VoidCallback onTap,
      {Widget? content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            //margin: const EdgeInsets.only(top: 8, left: 16),
            child: content ??
                Text(
                  'Options will go here...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customize your electronic debate timer to your liking!',
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
                        'Connection status: ',
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
                              : _connectionStatus == ConnectionStatus.searching
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Settings',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCollapsibleMenu(
                    'Debate format options',
                    _debateFormatExpanded,
                    () => setState(
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
                                  _dropdownAOpen = false;
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
                                  _dropdownBOpen = false;
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
                                // Handle save settings
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
                  const SizedBox(height: 16),
                  _buildCollapsibleMenu(
                    'Timer options',
                    _timerOptionsExpanded,
                    () => setState(
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
                  const SizedBox(height: 16),
                  _buildCollapsibleMenu(
                    'LED options',
                    _ledOptionsExpanded,
                    () => setState(
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
                                // Show color picker dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Select Speech Color'),
                                      content: SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: _speechColor,
                                          onColorChanged: (Color color) {
                                            setState(() {
                                              _speechColor = color;
                                            });
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Done'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _speechColor,
                                  border: Border.all(
                                      color: const Color(0xFF696969), width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RGB(${(_speechColor.r * 255.0).round() & 0xff}, ${(_speechColor.g * 255.0).round() & 0xff}, ${(_speechColor.b * 255.0).round() & 0xff})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white70,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
