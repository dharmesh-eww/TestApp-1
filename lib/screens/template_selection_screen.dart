import 'package:flutter/material.dart';
import '../models/biodata_template_model.dart';
import '../theme/app_colors.dart';
import 'biodata_preview_screen.dart';

class TemplateSelectionScreen extends StatefulWidget {
  final String? selectedTemplateId;
  final String? candidateName;

  const TemplateSelectionScreen({
    super.key,
    this.selectedTemplateId,
    this.candidateName,
  });

  @override
  State<TemplateSelectionScreen> createState() =>
      _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  late List<BiodataTemplateModel> _templates;
  late String _selectedTemplateId;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _templates = BiodataTemplateModel.getTemplates();
    _selectedTemplateId = widget.selectedTemplateId ?? _templates.first.id;
  }

  List<BiodataTemplateModel> get _filteredTemplates {
    if (_selectedCategory == 'All') return _templates;
    return _templates
        .where((t) => t.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  BiodataTemplateModel get _currentTemplate {
    return _templates.firstWhere(
      (t) => t.id == _selectedTemplateId,
      orElse: () => _templates.first,
    );
  }

  void _showFullTemplatePreview(BiodataTemplateModel template) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: template.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preview Modal Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  border: const Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          template.primaryColor.withValues(alpha: 0.15),
                      child: Icon(
                        template.emblemIcon,
                        size: 14,
                        color: template.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${template.name} Preview',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Printable A4 PDF & Image Ready',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),

              // Simulated Full A4 Biodata Canvas
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildRealisticBiodataSheet(template),
                ),
              ),

              // Preview Modal Bottom Action
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedTemplateId = template.id;
                          });
                          Navigator.pop(ctx);
                          _showExportSuccessModal(template);
                        },
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Choose This Template'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: template.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportSuccessModal(BiodataTemplateModel template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: template.primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: template.primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Template Selected!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Using "${template.name}" layout',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Customize & Export Options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: template.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: template.primaryColor,
                  ),
                ),
                title: const Text(
                  'Customize & Live A4 Preview',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Adjust photo size, shapes, fonts, spacing & pages',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: template.primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BiodataPreviewScreen(
                        template: template,
                        candidateName: widget.candidateName,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text(
                  'Download as PDF',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Clean vector A4 document formatted for printing',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.download_rounded, size: 20),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Generating PDF with "${template.name}"...'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.divider),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image_rounded,
                    color: AppColors.secondary,
                  ),
                ),
                title: const Text(
                  'Save as High-Res Image',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Perfect for instant WhatsApp & family sharing',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.download_rounded, size: 20),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Saving Image with "${template.name}"...'),
                      backgroundColor: AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredTemplates;
    final current = _currentTemplate;

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
              'Choose Template',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Select beautiful design for PDF & Image export',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_templates.length} Designs',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selector chips
          _buildCategoryFilterRow(),

          // Template Cards Grid
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final template = list[index];
                final isSelected = template.id == _selectedTemplateId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTemplateCard(template, isSelected),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(current),
    );
  }

  Widget _buildCategoryFilterRow() {
    final categories = ['All', 'Traditional', 'Modern', 'Floral', 'Executive'];
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  }
                },
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surfaceVariant,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Template Card with miniature realistic visual preview
  Widget _buildTemplateCard(BiodataTemplateModel template, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? template.primaryColor
              : AppColors.border,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? template.primaryColor.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of the card with Name & Tag
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            template.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: template.secondaryColor.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              template.tag,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: template.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        template.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Radio / Checkbox Indicator
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTemplateId = template.id;
                    });
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? template.primaryColor : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? template.primaryColor
                            : AppColors.textMuted,
                        width: 1.8,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),

          // Miniature Visual Preview of the template layout
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTemplateId = template.id;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: template.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: template.secondaryColor.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: _buildMiniTemplatePreview(template),
            ),
          ),

          const SizedBox(height: 12),

          // Card Footer Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              children: [
                // Color swatches indicator
                Row(
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: template.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: template.secondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      template.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Full Screen Preview button
                OutlinedButton.icon(
                  onPressed: () => _showFullTemplatePreview(template),
                  icon: const Icon(Icons.zoom_in_rounded, size: 15),
                  label: const Text('Preview', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Select button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTemplateId = template.id;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? template.primaryColor
                        : AppColors.surfaceVariant,
                    foregroundColor:
                        isSelected ? Colors.white : AppColors.textPrimary,
                    elevation: 0,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isSelected ? 'Selected' : 'Select',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Miniature representation of the biodata layout
  Widget _buildMiniTemplatePreview(BiodataTemplateModel template) {
    final previewName = widget.candidateName ?? 'Candidate Profile';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Emblem & Shloka
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              template.emblemIcon,
              size: 11,
              color: template.primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              template.emblemText,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: template.primaryColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              template.emblemIcon,
              size: 11,
              color: template.primaryColor,
            ),
          ],
        ),

        const SizedBox(height: 6),
        Container(
          height: 1,
          color: template.secondaryColor.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 8),

        // Photo & Info Mini Block
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mini Photo Frame
            Container(
              width: 44,
              height: 52,
              decoration: BoxDecoration(
                color: template.cardColor,
                borderRadius: BorderRadius.circular(
                  template.isPhotoCentered ? 22 : 6,
                ),
                border: Border.all(
                  color: template.secondaryColor,
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 24,
                color: template.primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 10),
            // Header Info & Mini details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    previewName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: template.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _buildMiniFieldRow('DOB:', '15 Oct 1996 • 28 Yrs', template),
                  _buildMiniFieldRow('Education:', 'B.Tech / MBA Graduate', template),
                  _buildMiniFieldRow('Profession:', 'Senior Software Engineer', template),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Section 1: Mini Section Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: template.secondaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Family Details',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: template.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildMiniFieldRow('Father:', 'Business Owner', template),
        _buildMiniFieldRow('Mother:', 'Home Maker', template),
      ],
    );
  }

  Widget _buildMiniFieldRow(
      String label, String value, BiodataTemplateModel template) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Realistic full A4 Preview
  Widget _buildRealisticBiodataSheet(BiodataTemplateModel template) {
    final previewName = widget.candidateName ?? 'Aarav Sharma';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: template.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: template.secondaryColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Double header ornament
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(template.emblemIcon, size: 18, color: template.primaryColor),
              const SizedBox(width: 8),
              Text(
                template.emblemText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: template.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(template.emblemIcon, size: 18, color: template.primaryColor),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: template.secondaryColor, thickness: 1.2),
          const SizedBox(height: 10),

          // Main Profile Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 110,
                decoration: BoxDecoration(
                  color: template.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: template.secondaryColor, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: template.primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      previewName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: template.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'B.Tech • Senior Engineer at Google',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFullFieldRow('Date of Birth:', '15 August 1996 (28 Yrs)'),
                    _buildFullFieldRow('Height / Weight:', "5' 10\" • 72 kg"),
                    _buildFullFieldRow('Caste / Gotra:', 'Hindu - Brahmin • Kashyap'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Section 1: Personal Details
          _buildFullSectionHeader('Personal Information', template),
          const SizedBox(height: 6),
          _buildFullFieldRow('Education:', 'B.Tech in Computer Science & Engineering'),
          _buildFullFieldRow('Profession:', 'Senior Software Engineer, Google India'),
          _buildFullFieldRow('Annual Income:', '₹ 32,00,000 / Year'),
          _buildFullFieldRow('Birth Place:', 'Bengaluru, Karnataka'),

          const SizedBox(height: 14),

          // Section 2: Family Details
          _buildFullSectionHeader('Family Background', template),
          const SizedBox(height: 6),
          _buildFullFieldRow('Father:', 'Rajesh Sharma (Businessman)'),
          _buildFullFieldRow('Mother:', 'Sunita Sharma (Teacher)'),
          _buildFullFieldRow('Brothers:', '1 Younger Brother (Studying MBA)'),
          _buildFullFieldRow('Sisters:', '1 Elder Sister (Married)'),

          const SizedBox(height: 14),

          // Section 3: Contact & Address
          _buildFullSectionHeader('Contact & Residence', template),
          const SizedBox(height: 6),
          _buildFullFieldRow('Address:', '104, Golden Palms, Indiranagar, Bengaluru'),
          _buildFullFieldRow('Contact:', '+91 98765 43210'),
          _buildFullFieldRow('Email:', 'sharma.aarav@example.com'),
        ],
      ),
    );
  }

  Widget _buildFullSectionHeader(
      String title, BiodataTemplateModel template) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: template.secondaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: template.primaryColor, width: 3.5)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: template.primaryColor,
        ),
      ),
    );
  }

  Widget _buildFullFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom action bar
  Widget _buildBottomBar(BiodataTemplateModel current) {
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
            // Selected template badge
            CircleAvatar(
              radius: 18,
              backgroundColor: current.primaryColor.withValues(alpha: 0.15),
              child: Icon(
                current.emblemIcon,
                size: 18,
                color: current.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Template',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    current.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: current.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showExportSuccessModal(current),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text(
                'Export Biodata',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: current.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
