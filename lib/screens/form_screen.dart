import 'package:flutter/material.dart';
import '../models/biodata_form_model.dart';
import '../theme/app_colors.dart';
import 'template_selection_screen.dart';

class FormScreen extends StatefulWidget {
  final String? biodataId;
  final String? initialName;

  const FormScreen({
    super.key,
    this.biodataId,
    this.initialName,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late List<BiodataSectionModel> _sections;

  // Profile image selection state
  String? _profileImagePath; // Holds selected image tag/URL or indicator
  String _profileImageLabel = 'No Photo';

  // Attachment images state
  final List<String> _attachmentImages = [];

  // Controllers for text fields to maintain cursor and state properly
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _sections = BiodataSectionModel.getInitialSections();

    if (widget.initialName != null && widget.initialName!.isNotEmpty) {
      final nameField = _sections
          .firstWhere((s) => s.id == 'personal_details')
          .fields
          .firstWhere((f) => f.id == 'p_name');
      nameField.value = widget.initialName!;
    }

    _initializeControllers();
  }

  void _initializeControllers() {
    for (final section in _sections) {
      for (final field in section.fields) {
        if (!_controllers.containsKey(field.id)) {
          _controllers[field.id] = TextEditingController(text: field.value);
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- Profile Photo Picker Simulation ---
  void _openProfilePhotoPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profile Photograph',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Select a recent clear portrait for your biodata',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _profileImagePath = 'selected_gallery';
                      _profileImageLabel = 'Gallery Photo Selected';
                    });
                    _showToast('Photo selected from Gallery');
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.secondary,
                    ),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _profileImagePath = 'selected_camera';
                      _profileImageLabel = 'Camera Photo Captured';
                    });
                    _showToast('Photo captured from Camera');
                  },
                ),
                if (_profileImagePath != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _profileImagePath = null;
                        _profileImageLabel = 'No Photo';
                      });
                      _showToast('Profile photo removed');
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Attachment Image Handler ---
  void _addAttachmentImage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Attachment Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add Kundali, Horoscope chart, or full-length photo',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.stars_rounded, color: AppColors.primary),
                  title: const Text('Kundali / Horoscope Document'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachmentImages.add(
                        'Kundali Image #${_attachmentImages.length + 1}',
                      );
                    });
                    _showToast('Kundali attachment added');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined, color: AppColors.secondary),
                  title: const Text('Full-Length / Family Photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachmentImages.add(
                        'Photo Attachment #${_attachmentImages.length + 1}',
                      );
                    });
                    _showToast('Photo attachment added');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachmentImages.removeAt(index);
    });
    _showToast('Attachment removed');
  }

  // --- Dynamic Section Actions ---
  void _addNewSectionDialog() {
    final titleController = TextEditingController();
    final suggestions = [
      'Horoscope & Astrology',
      'Hobbies & Lifestyle',
      'Contact & Location',
      'Education Details',
      'Expectations & Preferences',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text(
              'Add New Section',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Section Title',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'e.g. Horoscope Details',
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Quick Suggestions:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: suggestions.map((item) {
                      return ActionChip(
                        label: Text(
                          item,
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: AppColors.surfaceVariant,
                        side: const BorderSide(color: AppColors.border),
                        onPressed: () {
                          titleController.text = item;
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = titleController.text.trim();
                  if (text.isEmpty) return;
                  Navigator.pop(ctx);
                  setState(() {
                    _sections.add(
                      BiodataSectionModel(
                        id: 'section_${DateTime.now().millisecondsSinceEpoch}',
                        title: text,
                        canDelete: true,
                        fields: [
                          BiodataFieldModel(
                            id: 'field_${DateTime.now().millisecondsSinceEpoch}',
                            label: 'Details',
                            value: '',
                          ),
                        ],
                      ),
                    );
                    _initializeControllers();
                  });
                  _showToast('Section "$text" added');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Section'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editSectionTitleDialog(BiodataSectionModel section) {
    final titleController = TextEditingController(text: section.title);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Edit Section Title',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter section title',
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                Navigator.pop(ctx);
                setState(() {
                  section.title = newTitle;
                });
                _showToast('Section renamed');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteSection(BiodataSectionModel section) {
    if (!section.canDelete) {
      _showToast('Personal Details section cannot be deleted.');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            const Icon(Icons.delete_outline, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Delete "${section.title}"?',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Text(
          'This will remove this entire section and all fields inside it.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _sections.removeWhere((s) => s.id == section.id);
              });
              _showToast('Section "${section.title}" removed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // --- Dynamic Field Actions ---
  void _addNewFieldDialog(BiodataSectionModel section) {
    final labelController = TextEditingController();
    final suggestions = [
      'Time of Birth',
      'Place of Birth',
      'Rashi / Moon Sign',
      'Nakshatra',
      'Gotra',
      'Manglik',
      'Complexion',
      'Native Place',
      'Hobbies',
      'Grandfather Name',
      'Mama / Maternal Uncle',
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          'Add Field to ${section.title}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Field Name / Label',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: labelController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Place of Birth',
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Suggestions:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: suggestions.map((item) {
                  return ActionChip(
                    label: Text(item, style: const TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceVariant,
                    side: const BorderSide(color: AppColors.border),
                    onPressed: () {
                      labelController.text = item;
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final label = labelController.text.trim();
              if (label.isEmpty) return;
              Navigator.pop(ctx);
              final newId = 'field_${DateTime.now().millisecondsSinceEpoch}';
              setState(() {
                section.fields.add(
                  BiodataFieldModel(
                    id: newId,
                    label: label,
                    value: '',
                    canDelete: true,
                  ),
                );
                _controllers[newId] = TextEditingController(text: '');
              });
              _showToast('Field "$label" added');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Field'),
          ),
        ],
      ),
    );
  }

  void _editFieldLabelDialog(
    BiodataSectionModel section,
    BiodataFieldModel field,
  ) {
    final labelController = TextEditingController(text: field.label);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Rename Field Label',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: labelController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new label',
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newLabel = labelController.text.trim();
              if (newLabel.isNotEmpty) {
                Navigator.pop(ctx);
                setState(() {
                  field.label = newLabel;
                });
                _showToast('Field renamed to "$newLabel"');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteField(BiodataSectionModel section, BiodataFieldModel field) {
    if (!field.canDelete) {
      _showToast('Full Name cannot be deleted as it is a required field.');
      return;
    }

    setState(() {
      section.fields.removeWhere((f) => f.id == field.id);
      _controllers[field.id]?.dispose();
      _controllers.remove(field.id);
    });
    _showToast('Field "${field.label}" removed');
  }

  void _onReorderFields(BiodataSectionModel section, int oldIndex, int newIndex) {
    setState(() {
      final item = section.fields.removeAt(oldIndex);
      section.fields.insert(newIndex, item);
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Biodata Form',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Customize sections & fields dynamically',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _showToast('Biodata saved successfully!');
            },
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text('Save'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Image Selection Section
            _buildProfileImagePickerCard(),

            const SizedBox(height: 16),

            // 2. Multiple Attachment Images Section
            _buildAttachmentImagesCard(),

            const SizedBox(height: 20),

            // 3. Dynamic Sections Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.layers_outlined, size: 18, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'Biodata Sections',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _addNewSectionDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Add Section',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 4. Render All Dynamic Sections
            ..._sections.map((section) => _buildSectionCard(section)),

            const SizedBox(height: 16),

            // 5. Add New Section Button Card
            InkWell(
              onTap: _addNewSectionDialog,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Add Another Section',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomActionBar(),
    );
  }

  // --- Profile Image Card ---
  Widget _buildProfileImagePickerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with Camera Badge
          GestureDetector(
            onTap: _openProfilePhotoPicker,
            child: Stack(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _profileImagePath != null
                        ? AppColors.primaryLight
                        : AppColors.surfaceVariant,
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _profileImagePath != null
                        ? const Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: AppColors.primary,
                          )
                        : const Icon(
                            Icons.person_add_alt_1_outlined,
                            size: 32,
                            color: AppColors.textMuted,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Info & Select button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _profileImagePath != null
                      ? _profileImageLabel
                      : 'Tap to select photo from gallery or camera',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _openProfilePhotoPicker,
                      icon: const Icon(Icons.add_photo_alternate_outlined, size: 14),
                      label: Text(
                        _profileImagePath != null ? 'Change Photo' : 'Select Photo',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Multiple Attachment Images Card ---
  Widget _buildAttachmentImagesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.attach_file_rounded,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Attachment Images',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '${_attachmentImages.length} Attached',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Attach Kundali, Horoscope, or extra photographs',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          // Thumbnails & Add button list
          SizedBox(
            height: 84,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // "+ Add Attachment" tile
                InkWell(
                  onTap: _addAttachmentImage,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 74,
                    height: 84,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.4),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_rounded,
                          color: AppColors.secondary,
                          size: 26,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add More',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Render attached images
                ..._attachmentImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 84,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_rounded,
                                size: 28,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => _removeAttachment(index),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Dynamic Section Card Widget ---
  Widget _buildSectionCard(BiodataSectionModel section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header: Title, Edit, Delete, Reorder note
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: section.canDelete ? AppColors.secondary : AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          section.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Edit Section title
                      InkWell(
                        onTap: () => _editSectionTitleDialog(section),
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Section Field count badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${section.fields.length} Fields',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Delete Section (Disabled if canDelete == false)
                if (section.canDelete)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 19,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Delete Section',
                    onPressed: () => _deleteSection(section),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Tooltip(
                      message: 'Personal Details section cannot be deleted',
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Reorderable List of Fields inside the section
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: section.fields.length,
            onReorderItem: (oldIdx, newIdx) =>
                _onReorderFields(section, oldIdx, newIdx),
            itemBuilder: (context, fieldIndex) {
              final field = section.fields[fieldIndex];
              return _buildFieldItemRow(
                key: ValueKey(field.id),
                section: section,
                field: field,
                index: fieldIndex,
              );
            },
          ),

          // Add Field Footer Button
          InkWell(
            onTap: () => _addNewFieldDialog(section),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Add Field',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Field Item Row Widget with Drag Handle & Actions ---
  Widget _buildFieldItemRow({
    required Key key,
    required BiodataSectionModel section,
    required BiodataFieldModel field,
    required int index,
  }) {
    final controller = _controllers[field.id];

    return Container(
      key: key,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle for reordering fields
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Icon(
                Icons.drag_indicator_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ),
          ),

          // Field Label with inline edit button
          SizedBox(
            width: 110,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    field.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _editFieldLabelDialog(section, field),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Field Value Text Input
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                onChanged: (val) {
                  field.value = val;
                },
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter ${field.label.toLowerCase()}',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Delete Field Button (or lock icon if canDelete is false e.g. Name)
          if (field.canDelete)
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Delete Field',
              onPressed: () => _deleteField(section, field),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Tooltip(
                message: 'Name cannot be deleted',
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 15,
                  color: AppColors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- Bottom Action Bar ---
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _showToast('Form reset to defaults');
                  setState(() {
                    _sections = BiodataSectionModel.getInitialSections();
                    _initializeControllers();
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Reset Form',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  final nameController = _controllers['p_name'];
                  final candidateName = (nameController != null &&
                          nameController.text.trim().isNotEmpty)
                      ? nameController.text.trim()
                      : 'Candidate Profile';

                  _showToast('Biodata saved! Choose your template.');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TemplateSelectionScreen(
                        candidateName: candidateName,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text(
                  'Save & Continue',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
