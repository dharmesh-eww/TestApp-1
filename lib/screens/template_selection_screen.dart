import 'package:flutter/material.dart';
import '../models/biodata_form_model.dart';
import '../models/biodata_template_model.dart';
import '../theme/app_colors.dart';
import 'biodata_preview_screen.dart';
import 'template_preview_screen.dart';

class TemplateSelectionScreen extends StatefulWidget {
  final String? selectedTemplateId;
  final String? candidateName;
  final bool isSelectionMode;
  final List<BiodataSectionModel>? sections;
  final String? profileImagePath;
  final List<String>? attachmentImages;

  const TemplateSelectionScreen({
    super.key,
    this.selectedTemplateId,
    this.candidateName,
    this.isSelectionMode = false,
    this.sections,
    this.profileImagePath,
    this.attachmentImages,
  });

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  late List<BiodataTemplateModel> _templates;
  String? _selectedTemplateId;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _templates = BiodataTemplateModel.getTemplates();
    _selectedTemplateId = widget.selectedTemplateId;
  }

  List<BiodataTemplateModel> get _filteredTemplates {
    if (_selectedCategory == 'All') return _templates;
    return _templates.where((t) => t.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
  }

  BiodataTemplateModel? get _currentTemplate {
    if (_selectedTemplateId == null) return null;
    return _templates.firstWhere((t) => t.id == _selectedTemplateId, orElse: () => _templates.first);
  }

  void _openTemplatePreview(BiodataTemplateModel template) async {
    final selected = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TemplatePreviewScreen(
          template: template,
          candidateName: widget.candidateName,
          isSelectionMode: widget.isSelectionMode,
        ),
      ),
    );
    if (selected == true && mounted && widget.isSelectionMode) {
      setState(() {
        _selectedTemplateId = template.id;
      });
    }
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isSelectionMode ? 'Choose Template' : 'Templates',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            Text(
              widget.isSelectionMode
                  ? 'Select beautiful design for your biodata'
                  : 'Explore elegant biodata designs',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
            child: Text(
              '${_templates.length} Designs',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
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
              padding: EdgeInsets.fromLTRB(16, 8, 16, (widget.isSelectionMode && current != null) ? 120 : 24),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final template = list[index];
                final isSelected = widget.isSelectionMode && template.id == _selectedTemplateId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTemplateCard(template, isSelected),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: (widget.isSelectionMode && current != null) ? _buildBottomBar(current) : null,
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
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
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
    return GestureDetector(
      onTap: widget.isSelectionMode
          ? () {
              setState(() {
                if (_selectedTemplateId == template.id) {
                  _selectedTemplateId = null;
                } else {
                  _selectedTemplateId = template.id;
                }
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? template.primaryColor : AppColors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? template.primaryColor.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.03),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Radio / Checkbox Indicator (only in selection mode)
                  if (widget.isSelectionMode)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedTemplateId == template.id) {
                            _selectedTemplateId = null;
                          } else {
                            _selectedTemplateId = template.id;
                          }
                        });
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? template.primaryColor : Colors.transparent,
                          border: Border.all(color: isSelected ? template.primaryColor : AppColors.textMuted, width: 1.8),
                        ),
                        child: isSelected ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                      ),
                    ),
                ],
              ),
            ),

            // Miniature Visual Preview of the template layout
            GestureDetector(
              onTap: widget.isSelectionMode
                  ? () {
                      setState(() {
                        if (_selectedTemplateId == template.id) {
                          _selectedTemplateId = null;
                        } else {
                          _selectedTemplateId = template.id;
                        }
                      });
                    }
                  : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(12),
                decoration: _buildTemplateCardDecoration(template),
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
                      CircleAvatar(radius: 7, backgroundColor: template.primaryColor),
                      const SizedBox(width: 4),
                      CircleAvatar(radius: 7, backgroundColor: template.secondaryColor),
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
                    onPressed: () => _openTemplatePreview(template),
                    icon: const Icon(Icons.zoom_in_rounded, size: 15),
                    label: const Text('Preview', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Distinct Frame & Background Decoration for Each Template Card ---
  BoxDecoration _buildTemplateCardDecoration(BiodataTemplateModel template) {
    switch (template.frameStyle) {
      case TemplateFrameStyle.ornateDouble:
        // Royal Traditional: Double gold-lined border with warm ivory background
        return BoxDecoration(
          color: template.backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: template.secondaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        );

      case TemplateFrameStyle.floralScallop:
        // Classic Floral: Soft scalloped corners with delicate rose tint
        return BoxDecoration(
          color: template.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: template.secondaryColor.withValues(alpha: 0.6), width: 1.6),
          boxShadow: [
            BoxShadow(color: template.primaryColor.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        );

      case TemplateFrameStyle.modernMinimal:
        // Modern Minimalist: Crisp modern clean hairline frame with sleek drop shadow
        return BoxDecoration(
          color: template.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        );

      case TemplateFrameStyle.vedicTemple:
        // Vedic Heritage: Saffron double-layer frame with sandalwood parchment background
        return BoxDecoration(
          color: template.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: template.primaryColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.executiveBox:
        // Executive Elite: Metallic dual-tone border with pearl grey background
        return BoxDecoration(
          color: template.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: template.secondaryColor, width: 1.8),
          boxShadow: [
            BoxShadow(color: template.primaryColor.withValues(alpha: 0.10), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        );

      case TemplateFrameStyle.blushDashed:
        // Blush Elegance: Soft coral ornamental border with champagne peach background
        return BoxDecoration(
          color: template.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: template.primaryColor.withValues(alpha: 0.45), width: 1.5),
          boxShadow: [
            BoxShadow(color: template.primaryColor.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        );
    }
  }

  // --- Miniature Visual Preview with Distinct UI Styles & STRICT Photo Position (Top or Right, NEVER Left) ---
  Widget _buildMiniTemplatePreview(BiodataTemplateModel template) {
    final previewName = widget.candidateName ?? 'Candidate Profile';

    // Dispatches to top-photo layout vs right-photo layout
    if (template.photoPosition == PhotoPosition.top) {
      return _buildMiniTopPhotoLayout(template, previewName);
    } else {
      return _buildMiniRightPhotoLayout(template, previewName);
    }
  }

  // Mini Layout for Templates with Photo on TOP (Royal Traditional, Classic Floral, Vedic Heritage)
  Widget _buildMiniTopPhotoLayout(BiodataTemplateModel template, String previewName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. CENTERED TOP PHOTO (Never Left)
        Center(child: _buildMiniPhotoFrame(template, isTop: true)),
        const SizedBox(height: 5),

        // 2. Candidate Name & Highlight (Centered Below Photo)
        Text(
          previewName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: template.primaryColor),
        ),
        Text(
          'B.Tech • Senior Software Engineer',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 7),

        // 3. Section & Key Fields
        _buildMiniSectionHeader(
          template,
          template.id == 'vedic_heritage' ? '|| वैयक्तिक विवरण ||' : 'Personal Details',
        ),
        const SizedBox(height: 4),
        _buildMiniFieldRow('DOB:', '15 Oct 1996 (28 Yrs)', template),
        _buildMiniFieldRow('Height:', "5' 10\" • Caste: Brahmin", template),
        _buildMiniFieldRow('Profession:', 'Sr. Software Engineer', template),
      ],
    );
  }

  // Mini Layout for Templates with Photo on RIGHT (Modern Minimalist, Executive Elite, Blush Elegance)
  Widget _buildMiniRightPhotoLayout(BiodataTemplateModel template, String previewName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Info on LEFT, Photo on RIGHT (Strictly Right side, Never Left)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Content: Name & Intro details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    previewName,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: template.primaryColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Senior Software Engineer',
                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  _buildMiniFieldRow('Age / Ht:', "28 Yrs • 5' 10\"", template),
                  _buildMiniFieldRow('Education:', 'B.Tech / MBA', template),
                  _buildMiniFieldRow('City:', 'Bengaluru', template),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right Photo Frame (Never Left!)
            _buildMiniPhotoFrame(template, isTop: false),
          ],
        ),

        const SizedBox(height: 7),

        // 2. Mini Section Header & Family Info
        _buildMiniSectionHeader(template, 'Family Background'),
        const SizedBox(height: 4),
        _buildMiniFieldRow('Father:', 'Business Owner', template),
        _buildMiniFieldRow('Mother:', 'Home Maker', template),
      ],
    );
  }

  // Miniature Photo Frame styled uniquely per template
  Widget _buildMiniPhotoFrame(BiodataTemplateModel template, {required bool isTop}) {
    final double width = isTop ? 42 : 46;
    final double height = isTop ? 42 : 54;

    switch (template.frameStyle) {
      case TemplateFrameStyle.ornateDouble:
        // Royal Traditional: Gold halo circle with beaded border
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.cardColor,
            border: Border.all(color: template.secondaryColor, width: 2),
            boxShadow: [BoxShadow(color: template.secondaryColor.withValues(alpha: 0.3), blurRadius: 4)],
          ),
          child: Icon(Icons.person_rounded, size: 24, color: template.primaryColor.withValues(alpha: 0.7)),
        );

      case TemplateFrameStyle.floralScallop:
        // Classic Floral: Soft rose floral circular frame
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.cardColor,
            border: Border.all(color: template.secondaryColor, width: 1.5),
          ),
          child: Icon(Icons.local_florist_rounded, size: 20, color: template.primaryColor.withValues(alpha: 0.65)),
        );

      case TemplateFrameStyle.modernMinimal:
        // Modern Minimalist: Clean elevated rounded rectangle on the right
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(Icons.person_rounded, size: 26, color: template.primaryColor.withValues(alpha: 0.65)),
        );

      case TemplateFrameStyle.vedicTemple:
        // Vedic Heritage: Saffron arched frame
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.circular(4)),
            border: Border.all(color: template.primaryColor, width: 1.6),
          ),
          child: Icon(Icons.person_rounded, size: 22, color: template.primaryColor),
        );

      case TemplateFrameStyle.executiveBox:
        // Executive Elite: Metallic gold dual-line rectangular frame on the right
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: template.secondaryColor, width: 1.8),
            boxShadow: [BoxShadow(color: template.primaryColor.withValues(alpha: 0.15), blurRadius: 4)],
          ),
          child: Icon(Icons.person_rounded, size: 26, color: template.primaryColor.withValues(alpha: 0.7)),
        );

      case TemplateFrameStyle.blushDashed:
        // Blush Elegance: Soft squircle / oval frame with warm glow on the right
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: template.primaryColor.withValues(alpha: 0.5), width: 1.4),
          ),
          child: Icon(Icons.person_rounded, size: 24, color: template.primaryColor.withValues(alpha: 0.65)),
        );
    }
  }

  // Mini Section Header styled uniquely per template
  Widget _buildMiniSectionHeader(BiodataTemplateModel template, String title) {
    switch (template.frameStyle) {
      case TemplateFrameStyle.ornateDouble:
        // Traditional maroon banner with gold trim
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: template.primaryColor, borderRadius: BorderRadius.circular(3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('✦ ', style: TextStyle(fontSize: 7, color: template.secondaryColor)),
              Text(
                title,
                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Text(' ✦', style: TextStyle(fontSize: 7, color: template.secondaryColor)),
            ],
          ),
        );

      case TemplateFrameStyle.floralScallop:
        // Soft rounded rose-tinted pill
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: template.secondaryColor.withValues(alpha: 0.4), width: 0.8),
          ),
          child: Row(
            children: [
              Icon(Icons.local_florist_rounded, size: 8, color: template.primaryColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: template.primaryColor),
              ),
            ],
          ),
        );

      case TemplateFrameStyle.modernMinimal:
        // Modern left-accented vertical bar
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(2),
            border: Border(left: BorderSide(color: template.primaryColor, width: 3)),
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: template.primaryColor,
            ),
          ),
        );

      case TemplateFrameStyle.vedicTemple:
        // Saffron gradient ribbon
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: template.primaryColor.withValues(alpha: 0.6), width: 0.8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: template.primaryColor),
            ),
          ),
        );

      case TemplateFrameStyle.executiveBox:
        // Executive structured navy bar with gold accent
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: template.cardColor,
            border: Border(bottom: BorderSide(color: template.secondaryColor, width: 1.5)),
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: template.primaryColor),
          ),
        );

      case TemplateFrameStyle.blushDashed:
        // Soft floating card header
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: template.cardColor, borderRadius: BorderRadius.circular(6)),
          child: Row(
            children: [
              Icon(Icons.favorite_rounded, size: 8, color: template.primaryColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: template.primaryColor),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildMiniFieldRow(String label, String value, BiodataTemplateModel template) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: Text(
              label,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom action bar with Next button
  Widget _buildBottomBar(BiodataTemplateModel current) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -3)),
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
              child: Icon(current.emblemIcon, size: 18, color: current.primaryColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected Template', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  Text(
                    current.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: current.primaryColor),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BiodataPreviewScreen(
                      template: current,
                      sections: widget.sections,
                      candidateName: widget.candidateName,
                      profileImagePath: widget.profileImagePath,
                      attachmentImages: widget.attachmentImages,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Next', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: current.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
