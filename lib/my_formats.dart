import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/collapsible_menu.dart';
import 'debate_format.dart';
import 'format_storage.dart';

class MyFormatsPage extends StatefulWidget {
  const MyFormatsPage({super.key});

  @override
  State<MyFormatsPage> createState() => _MyFormatsPageState();
}

class _MyFormatsPageState extends State<MyFormatsPage> {
  List<bool> formatExpandedStates = [];
  List<DebateFormat> formats = [];
  bool addFormatExpanded = false;

  // controllers for the new format form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortNameController = TextEditingController();
  final List<List<TextEditingController>> timingsControllers = [
    [
      TextEditingController(),
      TextEditingController()
    ], // [0] protected start [mins, secs]
    [
      TextEditingController(),
      TextEditingController()
    ], // [1] protected end [mins, secs]
    [
      TextEditingController(),
      TextEditingController()
    ], // [2] speech length [mins, secs]
    [
      TextEditingController(),
      TextEditingController()
    ], // [3] grace time [mins, secs]
  ];

  @override
  void initState() {
    super.initState();
    _loadFormats();
  }

  Future<void> _loadFormats() async {
    final loadedFormats = await FormatStorage.loadFormats();
    setState(() {
      formats = loadedFormats;
      formatExpandedStates = List.filled(formats.length, false);
    });
  }

  String formatSecs(int secs) {
    return (secs < 10) ? ("0$secs") : secs.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F4F4F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 48.0, top: 16.0, right: 48.0, bottom: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Debate Formats',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ...formats.asMap().entries.map((entry) {
                  int index = entry.key;
                  DebateFormat format = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CollapsibleMenu(
                      title: format.fullName,
                      isExpanded: formatExpandedStates[index],
                      onTap: () => setState(() {
                        formatExpandedStates[index] =
                            !formatExpandedStates[index];
                      }),
                      content: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FormatText('Abbreviation: '),
                                const SizedBox(width: 4),
                                FormatTextInput(
                                  initialValue: format.shortName,
                                  maxLength: 4,
                                  width: 60,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FormatText('Speech length: '),
                                const SizedBox(width: 4),
                                FormatTextInput(
                                  initialValue: format.timings[2][0],
                                  inputType: InputType.mins,
                                ),
                                FormatText(' : '),
                                FormatTextInput(
                                  initialValue:
                                      formatSecs(format.timings[2][1]),
                                  inputType: InputType.secs,
                                  maxLength: 2,
                                  width: 26,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                FormatText('Grace time length: '),
                                const SizedBox(width: 4),
                                FormatTextInput(
                                  initialValue: 0,
                                  inputType: InputType.mins,
                                ),
                                FormatText(' : '),
                                FormatTextInput(
                                  initialValue:
                                      formatSecs(format.timings[3][1]),
                                  inputType: InputType.secs,
                                  maxLength: 2,
                                  width: 26,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FormatText('Protected times', isBold: true),
                            Row(
                              children: [
                                FormatText('From start of speech to '),
                                const SizedBox(width: 4),
                                FormatTextInput(
                                  initialValue: format.timings[0][0],
                                  inputType: InputType.mins,
                                ),
                                FormatText(' : '),
                                FormatTextInput(
                                  initialValue:
                                      formatSecs(format.timings[0][1]),
                                  inputType: InputType.secs,
                                  maxLength: 2,
                                  width: 26,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                FormatText('From '),
                                const SizedBox(width: 4),
                                FormatTextInput(
                                  initialValue: format.timings[1][0],
                                  inputType: InputType.mins,
                                ),
                                FormatText(' : '),
                                FormatTextInput(
                                  initialValue:
                                      formatSecs(format.timings[1][1]),
                                  inputType: InputType.secs,
                                  maxLength: 2,
                                  width: 26,
                                ),
                                const SizedBox(width: 4),
                                FormatText(' to end of speech'),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                AddFormatMenu(
                  isExpanded: addFormatExpanded,
                  nameController: nameController,
                  onTap: () => setState(() {
                    addFormatExpanded = !addFormatExpanded;
                  }),
                  content: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FormatText('Abbreviation: '),
                            const SizedBox(width: 4),
                            FormatTextInput(
                              controller: shortNameController,
                              maxLength: 4,
                              width: 60,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FormatText('Speech length: '),
                            const SizedBox(width: 4),
                            FormatTextInput(
                              controller: timingsControllers[2][0],
                              inputType: InputType.mins,
                            ),
                            FormatText(' : '),
                            FormatTextInput(
                              controller: timingsControllers[2][1],
                              inputType: InputType.secs,
                              maxLength: 2,
                              width: 26,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FormatText('Grace time length: '),
                            const SizedBox(width: 4),
                            FormatTextInput(
                              controller: timingsControllers[3][0],
                              inputType: InputType.mins,
                            ),
                            FormatText(' : '),
                            FormatTextInput(
                              controller: timingsControllers[3][1],
                              inputType: InputType.secs,
                              maxLength: 2,
                              width: 26,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FormatText('Protected times', isBold: true),
                        Row(
                          children: [
                            FormatText('From start of speech to '),
                            const SizedBox(width: 4),
                            FormatTextInput(
                              controller: timingsControllers[0][0],
                              inputType: InputType.mins,
                            ),
                            FormatText(' : '),
                            FormatTextInput(
                              controller: timingsControllers[0][1],
                              inputType: InputType.secs,
                              maxLength: 2,
                              width: 26,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FormatText('From '),
                            const SizedBox(width: 4),
                            FormatTextInput(
                              controller: timingsControllers[1][0],
                              inputType: InputType.mins,
                            ),
                            FormatText(' : '),
                            FormatTextInput(
                              controller: timingsControllers[1][1],
                              inputType: InputType.secs,
                              maxLength: 2,
                              width: 26,
                            ),
                            const SizedBox(width: 4),
                            FormatText(' to end of speech'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xFF696969)),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4)),
                            minimumSize: WidgetStateProperty.all<Size>(
                                const Size(0, 28)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // Validate required fields
                            if (nameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Format name is required')),
                              );
                              return;
                            }

                            if (shortNameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Abbreviation is required')),
                              );
                              return;
                            }

                            try {
                              // Parse timing values with error handling
                              final timings = <List<int>>[];
                              for (var controllerPair in timingsControllers) {
                                final minsText = controllerPair[0].text.trim();
                                final secsText = controllerPair[1].text.trim();

                                if (minsText.isEmpty || secsText.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'All timing fields are required')),
                                  );
                                  return;
                                }

                                final mins = int.parse(minsText);
                                final secs = int.parse(secsText);

                                // Validate seconds are 0-59
                                if (secs < 0 || secs > 59) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Seconds must be between 0-59')),
                                  );
                                  return;
                                }

                                timings.add([mins, secs]);
                              }

                              // Create new format from input values
                              final newFormat = DebateFormat(
                                fullName: nameController.text.trim(),
                                shortName: shortNameController.text.trim(),
                                timings: timings,
                              );

                              // Save to storage
                              await FormatStorage.addFormat(newFormat);

                              // Refresh the formats list
                              _loadFormats();

                              // Clear the form and collapse
                              nameController.clear();
                              shortNameController.clear();
                              for (var controllerPair in timingsControllers) {
                                controllerPair[0].clear(); // minutes
                                controllerPair[1].clear(); // seconds
                              }

                              setState(() {
                                addFormatExpanded = false;
                              });

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Format created successfully!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error creating format: Invalid input')),
                              );
                            }
                          },
                          child: Text(
                            'Create format',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save and exit',
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
      ),
    );
  }
}

class FormatText extends StatelessWidget {
  final String text;
  final bool isBold;

  const FormatText(
    this.text, {
    super.key,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: Colors.white70,
      ),
    );
  }
}

enum InputType { text, mins, secs }

class FormatTextInput extends StatelessWidget {
  final dynamic initialValue; // Can be String, int, or null
  final TextEditingController? controller;
  final int maxLength;
  final InputType inputType;
  final double width;
  final String? Function(String?)? validator;

  const FormatTextInput({
    super.key,
    this.initialValue,
    this.controller,
    this.inputType = InputType.text,
    this.maxLength = 1,
    this.width = 18,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 32,
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue?.toString() : null,
          maxLength: maxLength,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            counterText: '',
            fillColor: Color(0xFF696969),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            border: InputBorder.none,
          ),
          validator: validator ?? _getDefaultValidator(),
        ),
      ),
    );
  }

  String? Function(String?)? _getDefaultValidator() {
    if (inputType == InputType.text) {
      return (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value.length < 2 || value.length > maxLength) {
          return '$maxLength letters max.';
        }
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) return 'Letters only';
        return null;
      };
    } else if (inputType == InputType.mins) {
      return (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value.length > maxLength) return '$maxLength digits max.';
        if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Numbers only';
        return null;
      };
    } else if (inputType == InputType.secs) {
      return (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value.length > maxLength) return '$maxLength digits max.';
        if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Numbers only';
        return null;
      };
    }
    return null; // Default case
  }
}

class AddFormatMenu extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget? content;
  final TextEditingController? nameController;

  const AddFormatMenu({
    super.key,
    required this.isExpanded,
    required this.onTap,
    this.content,
    this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  maxLength: 32,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    counterText: '',
                    hintText: 'Add format...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF3A3A3A),
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF3A3A3A),
                        width: 2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF3A3A3A),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            child: content,
          ),
      ],
    );
  }
}
