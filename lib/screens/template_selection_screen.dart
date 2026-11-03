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
  late List<BiodataTemplateModel> _allTemplates;
  String? _selectedTemplateId;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _allTemplates = BiodataTemplateModel.getTemplates();
    _selectedTemplateId = widget.selectedTemplateId;
  }

  List<String> get _categories => ['All', ...BiodataTemplateModel.getCategories()];

  List<String> get _visibleCategories {
    if (_selectedCategory == 'All') {
      return BiodataTemplateModel.getCategories();
    }
    return [_selectedCategory];
  }

  List<BiodataTemplateModel> _getTemplatesForCategory(String category) {
    return _allTemplates
        .where((t) => t.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  BiodataTemplateModel? get _currentTemplate {
    if (_selectedTemplateId == null) return null;
    return _allTemplates.firstWhere(
      (t) => t.id == _selectedTemplateId,
      orElse: () => _allTemplates.first,
    );
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Simple':
        return Icons.crop_square_rounded;
      case 'Traditional':
        return Icons.temple_hindu_rounded;
      case 'Floral & Decorative':
        return Icons.local_florist_rounded;
      case 'Modern':
        return Icons.auto_awesome_rounded;
      case 'Executive & Royal':
        return Icons.diamond_rounded;
      default:
        return Icons.style_rounded;
    }
  }

  String _getCategorySubtitle(String category) {
    switch (category) {
      case 'Simple':
        return 'Clean, distraction-free marriage biodatas with subtle borders';
      case 'Traditional':
        return 'Auspicious Vedic motifs, royal double borders & sacred shlokas';
      case 'Floral & Decorative':
        return 'Graceful botanical wreaths, scalloped petals & soft pastels';
      case 'Modern':
        return 'Contemporary layouts with right portrait & clean dividing bars';
      case 'Executive & Royal':
        return 'Opulent gold pinstripes, marble textures & prestige themes';
      default:
        return 'Handcrafted marriage biodata designs';
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentTemplate;
    final screenWidth = MediaQuery.of(context).size.width;
    // Each template card in the horizontal list takes 50% of the screen width
    final cardWidth = screenWidth * 0.50;

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
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              widget.isSelectionMode
                  ? 'Select beautiful design for your biodata'
                  : 'Explore elegant marriage biodata designs',
              style: const TextStyle(
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
              '${_allTemplates.length} Designs',
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

          // Categories-wise vertical list of horizontal template rows
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                0,
                12,
                0,
                (widget.isSelectionMode && current != null) ? 120 : 32,
              ),
              itemCount: _visibleCategories.length,
              itemBuilder: (context, catIndex) {
                final categoryName = _visibleCategories[catIndex];
                final categoryTemplates = _getTemplatesForCategory(categoryName);
                if (categoryTemplates.isEmpty) return const SizedBox.shrink();

                return _buildCategorySection(
                  categoryName: categoryName,
                  templates: categoryTemplates,
                  cardWidth: cardWidth,
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: (widget.isSelectionMode && current != null)
          ? _buildBottomBar(current)
          : null,
    );
  }

  // Top Category Filter Chips Row
  Widget _buildCategoryFilterRow() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((cat) {
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

  // Category Section: Category Name Header + Horizontal Template List
  Widget _buildCategorySection({
    required String categoryName,
    required List<BiodataTemplateModel> templates,
    required double cardWidth,
  }) {
    final icon = _getCategoryIcon(categoryName);
    final subtitle = _getCategorySubtitle(categoryName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            '${templates.length} Templates',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal Template List (50% screen width per card, portrait vertical view)
        SizedBox(
          height: 355,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              final isSelected =
                  widget.isSelectionMode && template.id == _selectedTemplateId;

              return Padding(
                padding: EdgeInsets.only(
                  right: index == templates.length - 1 ? 0 : 12,
                ),
                child: SizedBox(
                  width: cardWidth,
                  child: _buildTemplateCard(template, isSelected),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  // Template Card: Portrait Vertical View taking 50% width
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? template.primaryColor : AppColors.border,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? template.primaryColor.withValues(alpha: 0.16)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Miniature Visual Preview Container
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: _buildTemplateCardDecoration(template),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildMiniTemplatePreview(template),
                      ),
                    ),
                  ),

                  // Selection Checkmark Badge at Top-Right
                  if (widget.isSelectionMode)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
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
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? template.primaryColor
                                : Colors.white.withValues(alpha: 0.9),
                            border: Border.all(
                              color: isSelected
                                  ? template.primaryColor
                                  : AppColors.textMuted,
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),

                  // Tag Pill on Top-Left
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: template.primaryColor.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        template.tag,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Footer: Title + Preview Button
            Container(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    template.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      // Swatches
                      CircleAvatar(radius: 5, backgroundColor: template.primaryColor),
                      const SizedBox(width: 3),
                      CircleAvatar(radius: 5, backgroundColor: template.secondaryColor),
                      const Spacer(),
                      // Preview Button
                      SizedBox(
                        height: 28,
                        child: OutlinedButton(
                          onPressed: () => _openTemplatePreview(template),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in_rounded, size: 13),
                              SizedBox(width: 3),
                              Text(
                                'Preview',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
      ),
    );
  }

  // Card Outer Decoration for mini preview
  BoxDecoration _buildTemplateCardDecoration(BiodataTemplateModel template) {
    DecorationImage? bgImage;
    if (template.backgroundImage != null) {
      bgImage = DecorationImage(
        image: AssetImage(template.backgroundImage!),
        fit: BoxFit.cover,
        opacity: 0.15,
      );
    }

    switch (template.frameStyle) {
      case TemplateFrameStyle.simpleLine:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: template.secondaryColor.withValues(alpha: 0.5),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        );

      case TemplateFrameStyle.simpleCard:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: template.secondaryColor.withValues(alpha: 0.6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.ornateDouble:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: template.secondaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.floralScallop:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: template.secondaryColor.withValues(alpha: 0.6),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        );

      case TemplateFrameStyle.modernMinimal:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.vedicTemple:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: template.primaryColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.18),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.executiveBox:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: template.secondaryColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.blushDashed:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: template.primaryColor.withValues(alpha: 0.45),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.geometricFretwork:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: template.secondaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.botanicalWreath:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: template.secondaryColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.artisticMosaic:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: template.secondaryColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.luxuryPinstripe:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: template.secondaryColor, width: 2.2),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case TemplateFrameStyle.twoColumnProfile:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: template.secondaryColor.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );
    }
  }

  // Mini Preview Content Router
  Widget _buildMiniTemplatePreview(BiodataTemplateModel template) {
    final previewName = widget.candidateName ?? 'Aarav Sharma';

    if (template.hasSidebar) {
      return _buildMiniTwoColumnProfile(template, previewName);
    } else if (template.photoPosition == PhotoPosition.top) {
      return _buildMiniTopPhotoLayout(template, previewName);
    } else {
      return _buildMiniRightPhotoLayout(template, previewName);
    }
  }

  // Mini Two-Column Matrimonial Profile Layout
  Widget _buildMiniTwoColumnProfile(
      BiodataTemplateModel template, String previewName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Profile Facts Panel (~38% width)
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: template.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              // Mini Photo
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: template.primaryColor.withValues(alpha: 0.2),
                  border: Border.all(color: template.primaryColor, width: 1.2),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: template.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: template.secondaryColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'BIODATA',
                  style: TextStyle(
                    fontSize: 6.5,
                    fontWeight: FontWeight.w800,
                    color: template.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Mini facts from form screen
              _buildMiniSidebarFact(Icons.cake_rounded, '28 Yrs', template),
              _buildMiniSidebarFact(Icons.height_rounded, "5' 10\"", template),
              _buildMiniSidebarFact(Icons.temple_hindu_rounded, 'Brahmin', template),
            ],
          ),
        ),

        const SizedBox(width: 6),

        // Right Content Column: Matrimonial Form Fields
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                previewName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: template.primaryColor,
                ),
              ),
              const Text(
                'Marriage Biodata',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 7.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 1.5,
                width: 30,
                color: template.secondaryColor,
              ),
              const SizedBox(height: 5),
              _buildMiniFieldRow('Education:', 'B.Tech', template),
              _buildMiniFieldRow('Occupation:', 'Engineer', template),
              _buildMiniFieldRow('Income:', '₹ 25 LPA', template),
              _buildMiniFieldRow('Father Name:', 'Rajesh Sharma', template),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniSidebarFact(
      IconData icon, String label, BiodataTemplateModel template) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 7.5, color: template.primaryColor),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 6.5,
              fontWeight: FontWeight.w600,
              color: template.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Mini Layout for Templates with Photo on TOP
  Widget _buildMiniTopPhotoLayout(
      BiodataTemplateModel template, String previewName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: _buildMiniPhotoFrame(template, isTop: true)),
        const SizedBox(height: 4),
        Text(
          previewName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: template.primaryColor,
          ),
        ),
        const Text(
          'Marriage Biodata Profile',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        _buildMiniSectionHeader(template, 'Personal Details'),
        const SizedBox(height: 3),
        _buildMiniFieldRow('DOB:', '15 Oct 1996 (28 Yrs)', template),
        _buildMiniFieldRow('Height:', "5' 10\" • Brahmin", template),
        _buildMiniFieldRow('Education:', 'B.Tech', template),
        _buildMiniFieldRow('Occupation:', 'Job / Business', template),
      ],
    );
  }

  // Mini Layout for Templates with Photo on RIGHT
  Widget _buildMiniRightPhotoLayout(
      BiodataTemplateModel template, String previewName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    previewName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: template.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Marriage Biodata Profile',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 7.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: 1.5,
                    width: 25,
                    color: template.secondaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            _buildMiniPhotoFrame(template, isTop: false),
          ],
        ),
        const SizedBox(height: 5),
        _buildMiniSectionHeader(template, 'Personal Details'),
        const SizedBox(height: 3),
        _buildMiniFieldRow('DOB:', '15 Oct 1996 (28 Yrs)', template),
        _buildMiniFieldRow('Height:', "5' 10\" • Brahmin", template),
        _buildMiniFieldRow('Education:', 'B.Tech', template),
        _buildMiniFieldRow('Occupation:', 'Job / Business', template),
      ],
    );
  }

  // Mini Photo Frame
  Widget _buildMiniPhotoFrame(BiodataTemplateModel template,
      {required bool isTop}) {
    final double size = isTop ? 42 : 36;

    switch (template.frameStyle) {
      case TemplateFrameStyle.ornateDouble:
      case TemplateFrameStyle.geometricFretwork:
        return Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.cardColor,
            border: Border.all(color: template.secondaryColor, width: 1.5),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: template.primaryColor.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.person_rounded,
              size: size * 0.6,
              color: template.primaryColor,
            ),
          ),
        );

      case TemplateFrameStyle.floralScallop:
      case TemplateFrameStyle.botanicalWreath:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.4),
            color: template.cardColor,
            border: Border.all(
              color: template.secondaryColor.withValues(alpha: 0.8),
              width: 1.4,
            ),
          ),
          child: Icon(
            Icons.face_retouching_natural_rounded,
            size: size * 0.58,
            color: template.primaryColor,
          ),
        );

      case TemplateFrameStyle.simpleLine:
      case TemplateFrameStyle.simpleCard:
      case TemplateFrameStyle.modernMinimal:
      case TemplateFrameStyle.twoColumnProfile:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: template.cardColor,
            border: Border.all(color: template.primaryColor, width: 1.0),
          ),
          child: Icon(
            Icons.account_circle_rounded,
            size: size * 0.6,
            color: template.primaryColor,
          ),
        );

      case TemplateFrameStyle.vedicTemple:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.cardColor,
            border: Border.all(color: template.primaryColor, width: 1.6),
          ),
          child: Icon(
            Icons.person_pin_rounded,
            size: size * 0.62,
            color: template.primaryColor,
          ),
        );

      case TemplateFrameStyle.executiveBox:
      case TemplateFrameStyle.luxuryPinstripe:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: template.cardColor,
            border: Border.all(color: template.secondaryColor, width: 1.6),
          ),
          child: Icon(
            Icons.person_rounded,
            size: size * 0.6,
            color: template.primaryColor,
          ),
        );

      case TemplateFrameStyle.blushDashed:
      case TemplateFrameStyle.artisticMosaic:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.35),
            color: template.cardColor,
            border: Border.all(
              color: template.primaryColor.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: Icon(
            Icons.person_rounded,
            size: size * 0.6,
            color: template.primaryColor,
          ),
        );
    }
  }

  // Mini Section Header
  Widget _buildMiniSectionHeader(
      BiodataTemplateModel template, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: template.secondaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
        border: Border(left: BorderSide(color: template.primaryColor, width: 2.2)),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 7.5,
          fontWeight: FontWeight.w700,
          color: template.primaryColor,
        ),
      ),
    );
  }

  // Mini Field Row
  Widget _buildMiniFieldRow(
      String label, String value, BiodataTemplateModel template) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 6.8,
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
              style: const TextStyle(
                fontSize: 6.8,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Floating Bar: Only shown in selection mode when a template is selected
  Widget _buildBottomBar(BiodataTemplateModel template) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Selected Template Details Badge
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: template.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: template.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.style_rounded,
                      color: template.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Selected Template',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          template.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Next Button navigating to BiodataPreviewScreen
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BiodataPreviewScreen(
                      candidateName: widget.candidateName,
                      template: template,
                      sections: widget.sections,
                      profileImagePath: widget.profileImagePath,
                      attachmentImages: widget.attachmentImages,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                'Next',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
