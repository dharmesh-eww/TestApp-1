import 'package:flutter/material.dart';
import '../models/biodata_form_model.dart';
import '../models/biodata_template_model.dart';
import '../theme/app_colors.dart';

enum ImageShapeType { square, rounded, circle }

class FontOption {
  final String name;
  final String fontFamily;
  final String styleLabel;

  const FontOption({
    required this.name,
    required this.fontFamily,
    required this.styleLabel,
  });
}

class BiodataPreviewScreen extends StatefulWidget {
  final List<BiodataSectionModel>? sections;
  final String? candidateName;
  final String? profileImagePath;
  final List<String>? attachmentImages;
  final BiodataTemplateModel? template;

  const BiodataPreviewScreen({
    super.key,
    this.sections,
    this.candidateName,
    this.profileImagePath,
    this.attachmentImages,
    this.template,
  });

  @override
  State<BiodataPreviewScreen> createState() => _BiodataPreviewScreenState();
}

class _BiodataPreviewScreenState extends State<BiodataPreviewScreen> {
  late List<BiodataSectionModel> _sections;
  late String _candidateName;
  late List<String> _attachmentImages;

  // --- Live Customization States (via setState) ---
  double _imageScale = 1.8; // 1x to 4x slider
  ImageShapeType _imageShape = ImageShapeType.rounded;

  // Font customization
  final List<FontOption> _fontOptions = const [
    FontOption(
      name: 'Playfair Display',
      fontFamily: 'Playfair Display',
      styleLabel: 'Royal Serif',
    ),
    FontOption(
      name: 'Merriweather',
      fontFamily: 'Merriweather',
      styleLabel: 'Classic Serif',
    ),
    FontOption(
      name: 'Poppins',
      fontFamily: 'Poppins',
      styleLabel: 'Clean Modern',
    ),
    FontOption(
      name: 'Cinzel',
      fontFamily: 'Cinzel',
      styleLabel: 'Vedic Heritage',
    ),
    FontOption(
      name: 'Lora',
      fontFamily: 'Lora',
      styleLabel: 'Graceful Floral',
    ),
    FontOption(
      name: 'Roboto',
      fontFamily: 'Roboto',
      styleLabel: 'Minimalist Sans',
    ),
  ];
  late FontOption _selectedFont;
  double _fontSizeScale = 13.0; // 10 to 18 slider

  // Color customization
  late Color _primaryColor;
  late Color _secondaryColor;
  final List<Map<String, Color>> _colorPalettes = [
    {
      'primary': const Color(0xFF900C3F), // Royal Maroon
      'secondary': const Color(0xFFD4AF37), // Royal Gold
    },
    {
      'primary': const Color(0xFFC02739), // Crimson Rose
      'secondary': const Color(0xFFE5A93B), // Warm Gold
    },
    {
      'primary': const Color(0xFF1B4F72), // Classic Navy
      'secondary': const Color(0xFF5DADE2), // Soft Blue
    },
    {
      'primary': const Color(0xFFD35400), // Vedic Saffron
      'secondary': const Color(0xFFF39C12), // Amber
    },
    {
      'primary': const Color(0xFF1E8449), // Forest Emerald
      'secondary': const Color(0xFF82E0AA), // Mint Gold
    },
    {
      'primary': const Color(0xFF7D3C98), // Regal Purple
      'secondary': const Color(0xFFBB8FCE), // Lilac
    },
  ];

  // Spacing customization
  double _sectionSpacing = 14.0; // 6 to 28 slider
  double _itemSpacing = 5.0; // 2 to 14 slider

  // Page tracking for A4 multi-page document
  late PageController _pageController;
  int _currentPage = 0;

  // Selected tool panel (0: Photo, 1: Typography, 2: Theme, 3: Spacing, 4: Attachments)
  int _activeSettingsTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize with supplied data or realistic defaults
    _sections = widget.sections ?? BiodataSectionModel.getInitialSections();
    _candidateName = widget.candidateName ?? 'Aarav Sharma';

    // Populate initial attachment images if empty to demonstrate multi-page A4
    if (widget.attachmentImages != null && widget.attachmentImages!.isNotEmpty) {
      _attachmentImages = List.from(widget.attachmentImages!);
    } else {
      _attachmentImages = [
        'Kundali & Horoscope Chart',
        'Traditional Portrait Photo',
      ];
    }

    _selectedFont = _fontOptions.first;
    _primaryColor =
        widget.template?.primaryColor ?? const Color(0xFF900C3F);
    _secondaryColor =
        widget.template?.secondaryColor ?? const Color(0xFFD4AF37);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalPages => 1 + _attachmentImages.length;

  void _reorderAttachment(int oldIndex, int newIndex) {
    setState(() {
      final item = _attachmentImages.removeAt(oldIndex);
      _attachmentImages.insert(newIndex, item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attachment page order updated!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showExportDialog(String format) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(
              format == 'PDF'
                  ? Icons.picture_as_pdf_rounded
                  : Icons.image_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Save as $format',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Your multi-page A4 $format ($_totalPages pages) with $_candidateName\'s biodata, custom font (${_selectedFont.name}), and ${_attachmentImages.length} centered attachments is ready.',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully exported $format!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Download $format'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6), // Warm canvas neutral
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
            const Text(
              'A4 Biodata Preview',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Page ${_currentPage + 1} of $_totalPages • Printable Size',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Download PDF',
            icon: const Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            onPressed: () => _showExportDialog('PDF'),
          ),
          IconButton(
            tooltip: 'Save Image',
            icon: const Icon(
              Icons.image_outlined,
              color: AppColors.secondary,
              size: 22,
            ),
            onPressed: () => _showExportDialog('Image'),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Top Page Navigation Indicator
          _buildPageNavigationHeader(),

          // Main Center Area: Multi-Page A4 Canvas with PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalPages,
              onPageChanged: (idx) {
                setState(() {
                  _currentPage = idx;
                });
              },
              itemBuilder: (context, pageIndex) {
                if (pageIndex == 0) {
                  // Page 1: Main Biodata Form Content
                  return _buildA4PageContainer(
                    child: _buildBiodataFirstPageContent(),
                  );
                } else {
                  // Page 2+: Centered Attachment Single-Page
                  final attachmentIndex = pageIndex - 1;
                  final attachmentTitle = _attachmentImages[attachmentIndex];
                  return _buildA4PageContainer(
                    child: _buildCenteredAttachmentPageContent(
                      attachmentTitle,
                      attachmentIndex,
                    ),
                  );
                }
              },
            ),
          ),

          // Bottom Customization Toolbar & Active Drawer Panel
          _buildCustomizationControlPanel(),
        ],
      ),
    );
  }

  // Header showing page count & quick previous/next buttons
  Widget _buildPageNavigationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentPage == 0
                      ? 'Page 1: Biodata Details'
                      : 'Page ${_currentPage + 1}: Attachment',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Total: $_totalPages Pages (A4)',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 24),
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              Text(
                '${_currentPage + 1} / $_totalPages',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 24),
                onPressed: _currentPage < _totalPages - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Standard A4 Canvas Container with 1 : 1.414 Aspect Ratio & Print Sheet Look
  Widget _buildA4PageContainer({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / 1.414, // Exact A4 aspect ratio standard
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _secondaryColor.withValues(alpha: 0.6),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Page 1: Complete Matrimonial Biodata Sheet
  Widget _buildBiodataFirstPageContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Auspicious Header & Shloka
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.template?.emblemIcon ?? Icons.favorite_rounded, size: 14, color: _primaryColor),
              const SizedBox(width: 6),
              Text(
                widget.template?.emblemText ?? '|| Shree Ganeshay Namah ||',
                style: TextStyle(
                  fontFamily: _selectedFont.fontFamily,
                  fontSize: _fontSizeScale * 0.85,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 6),
              Icon(widget.template?.emblemIcon ?? Icons.favorite_rounded, size: 14, color: _primaryColor),
            ],
          ),

          const SizedBox(height: 6),
          Divider(
            color: _secondaryColor.withValues(alpha: 0.6),
            thickness: 1.2,
          ),
          const SizedBox(height: 8),

          // Top Profile Section: Strictly Top Centered Photo OR Right Photo (Never Left)
          if (widget.template?.photoPosition == PhotoPosition.top)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: _buildConfigurablePhotoWidget()),
                const SizedBox(height: 10),
                Text(
                  _candidateName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: _selectedFont.fontFamily,
                    fontSize: _fontSizeScale * 1.35,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Marriage Biodata Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: _selectedFont.fontFamily,
                    fontSize: _fontSizeScale * 0.75,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Container(
                    height: 2,
                    width: 40,
                    color: _secondaryColor,
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content on the LEFT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _candidateName,
                        style: TextStyle(
                          fontFamily: _selectedFont.fontFamily,
                          fontSize: _fontSizeScale * 1.35,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Marriage Biodata Profile',
                        style: TextStyle(
                          fontFamily: _selectedFont.fontFamily,
                          fontSize: _fontSizeScale * 0.75,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 2,
                        width: 40,
                        color: _secondaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Photo on the RIGHT (Never on the left side)
                _buildConfigurablePhotoWidget(),
              ],
            ),

          SizedBox(height: _sectionSpacing),

          // Render All Form Sections & Fields with dynamic itemSpacing & sectionSpacing
          ..._sections.map((section) {
            return Padding(
              padding: EdgeInsets.only(bottom: _sectionSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _secondaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border(
                        left: BorderSide(color: _primaryColor, width: 3),
                      ),
                    ),
                    child: Text(
                      section.title,
                      style: TextStyle(
                        fontFamily: _selectedFont.fontFamily,
                        fontSize: _fontSizeScale * 0.95,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(height: _itemSpacing),

                  // Fields Inside Section
                  ...section.fields.map((field) {
                    final displayVal = field.value.isNotEmpty
                        ? field.value
                        : _getDefaultFieldValue(field.label);

                    return Padding(
                      padding: EdgeInsets.only(bottom: _itemSpacing),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              '${field.label}:',
                              style: TextStyle(
                                fontFamily: _selectedFont.fontFamily,
                                fontSize: _fontSizeScale * 0.78,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              displayVal,
                              style: TextStyle(
                                fontFamily: _selectedFont.fontFamily,
                                fontSize: _fontSizeScale * 0.8,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Page 2+: Centered Attachment Image on Single A4 Sheet
  Widget _buildCenteredAttachmentPageContent(
      String attachmentTitle, int attachmentIndex) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Shloka / Attachment Header
          Text(
            '|| Auspicious Documents & Photos ||',
            style: TextStyle(
              fontFamily: _selectedFont.fontFamily,
              fontSize: _fontSizeScale * 0.8,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Divider(color: _secondaryColor.withValues(alpha: 0.5)),
          const Spacer(),

          // Centered Attachment Image Graphic / Document Frame
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _secondaryColor.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  attachmentTitle.toLowerCase().contains('kundali')
                      ? Icons.stars_rounded
                      : Icons.portrait_rounded,
                  size: 72,
                  color: _primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  attachmentTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: _selectedFont.fontFamily,
                    fontSize: _fontSizeScale,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Attachment Page #${attachmentIndex + 1} • Centered for PDF Export',
                  style: TextStyle(
                    fontFamily: _selectedFont.fontFamily,
                    fontSize: _fontSizeScale * 0.7,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom note & position switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (attachmentIndex > 0)
                TextButton.icon(
                  onPressed: () {
                    _reorderAttachment(attachmentIndex, attachmentIndex - 1);
                  },
                  icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                  label: const Text(
                    'Move Up',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              if (attachmentIndex < _attachmentImages.length - 1)
                TextButton.icon(
                  onPressed: () {
                    _reorderAttachment(attachmentIndex, attachmentIndex + 1);
                  },
                  icon: const Icon(Icons.arrow_downward_rounded, size: 14),
                  label: const Text(
                    'Move Down',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Profile Photo Widget with Dynamic Size (1x to 4x slider) & Shapes
  Widget _buildConfigurablePhotoWidget() {
    // 1x = 42px, 4x = 110px
    final dimension = 35.0 + (_imageScale * 20.0);

    BorderRadius borderRadius;
    switch (_imageShape) {
      case ImageShapeType.square:
        borderRadius = BorderRadius.zero;
        break;
      case ImageShapeType.rounded:
        borderRadius = BorderRadius.circular(14);
        break;
      case ImageShapeType.circle:
        borderRadius = BorderRadius.circular(dimension / 2);
        break;
    }

    return Container(
      width: dimension,
      height: dimension * 1.15,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: borderRadius,
        border: Border.all(
          color: _secondaryColor,
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Center(
          child: Icon(
            Icons.person_rounded,
            size: dimension * 0.6,
            color: _primaryColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  // Bottom Customization Control Panel
  Widget _buildCustomizationControlPanel() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active Customization Drawer Content
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: _buildActiveSettingControl(),
            ),

            const Divider(height: 1, color: AppColors.divider),

            // Tabs Selector: Photo | Typography | Color | Spacing | Attachments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton(0, Icons.photo_size_select_actual_outlined, 'Photo'),
                  _buildTabButton(1, Icons.text_fields_rounded, 'Fonts'),
                  _buildTabButton(2, Icons.palette_outlined, 'Color'),
                  _buildTabButton(3, Icons.format_line_spacing_rounded, 'Spacing'),
                  _buildTabButton(4, Icons.collections_bookmark_outlined, 'Pages'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = _activeSettingsTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeSettingsTab = index;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? _primaryColor : AppColors.textMuted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? _primaryColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Active Setting Control based on selected tab
  Widget _buildActiveSettingControl() {
    switch (_activeSettingsTab) {
      case 0:
        // Tab 0: Photo Shape & Size (1x to 4x slider)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Photo Size (1x - 4x):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${_imageScale.toStringAsFixed(1)}x',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: _imageScale,
              min: 1.0,
              max: 4.0,
              divisions: 15,
              activeColor: _primaryColor,
              onChanged: (val) {
                setState(() {
                  _imageScale = val;
                });
              },
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Shape: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                _buildShapeChip('Square', ImageShapeType.square),
                const SizedBox(width: 6),
                _buildShapeChip('Rounded', ImageShapeType.rounded),
                const SizedBox(width: 6),
                _buildShapeChip('Circle', ImageShapeType.circle),
              ],
            ),
          ],
        );

      case 1:
        // Tab 1: Typography (Font Family & Size)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Font Size:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${_fontSizeScale.toInt()} pt',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: _fontSizeScale,
              min: 10.0,
              max: 18.0,
              divisions: 8,
              activeColor: _primaryColor,
              onChanged: (val) {
                setState(() {
                  _fontSizeScale = val;
                });
              },
            ),
            const Text(
              'Google Font Family:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _fontOptions.map((font) {
                  final isSel = _selectedFont.name == font.name;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(font.name),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedFont = font;
                          });
                        }
                      },
                      labelStyle: TextStyle(
                        fontFamily: font.fontFamily,
                        fontSize: 11,
                        color: isSel ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      ),
                      selectedColor: _primaryColor,
                      backgroundColor: AppColors.surfaceVariant,
                      side: BorderSide(
                        color: isSel ? _primaryColor : AppColors.border,
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );

      case 2:
        // Tab 2: Theme Colors
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Theme Color Palette:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _colorPalettes.map((palette) {
                final isSelected = _primaryColor == palette['primary'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _primaryColor = palette['primary']!;
                      _secondaryColor = palette['secondary']!;
                    });
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: palette['primary'],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.white,
                        width: isSelected ? 3 : 1.5,
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
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        );

      case 3:
        // Tab 3: Spacing (Section spacing & Item spacing)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Space Between Sections:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${_sectionSpacing.toInt()} px',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: _sectionSpacing,
              min: 6.0,
              max: 26.0,
              divisions: 10,
              activeColor: _primaryColor,
              onChanged: (val) {
                setState(() {
                  _sectionSpacing = val;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Space Between Section Items:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${_itemSpacing.toInt()} px',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: _itemSpacing,
              min: 2.0,
              max: 12.0,
              divisions: 5,
              activeColor: _primaryColor,
              onChanged: (val) {
                setState(() {
                  _itemSpacing = val;
                });
              },
            ),
          ],
        );

      case 4:
        // Tab 4: Attachment Pages & Order
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attachment Pages (Starts Page 2):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${_attachmentImages.length} Attachments',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ..._attachmentImages.asMap().entries.map((entry) {
              final idx = entry.key;
              final name = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Text(
                      'Page ${idx + 2}:',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    if (idx > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _reorderAttachment(idx, idx - 1),
                      ),
                    const SizedBox(width: 8),
                    if (idx < _attachmentImages.length - 1)
                      IconButton(
                        icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _reorderAttachment(idx, idx + 1),
                      ),
                  ],
                ),
              );
            }),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildShapeChip(String label, ImageShapeType shape) {
    final isSelected = _imageShape == shape;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            _imageShape = shape;
          });
        }
      },
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      selectedColor: _primaryColor,
      backgroundColor: AppColors.surfaceVariant,
      side: BorderSide(
        color: isSelected ? _primaryColor : AppColors.border,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  String _getDefaultFieldValue(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('name')) return 'Aarav Sharma';
    if (lower.contains('caste')) return 'Hindu - Brahmin';
    if (lower.contains('dob') || lower.contains('birth')) return '15 Aug 1996';
    if (lower.contains('height')) return "5' 10\"";
    if (lower.contains('weight')) return '72 kg';
    if (lower.contains('blood')) return 'B+ Positive';
    if (lower.contains('education')) return 'B.Tech - Computer Science';
    if (lower.contains('occupation')) return 'Senior Software Engineer';
    if (lower.contains('income')) return '₹ 32 LPA';
    if (lower.contains('father')) return 'Rajesh Sharma (Businessman)';
    if (lower.contains('mother')) return 'Sunita Sharma (Teacher)';
    if (lower.contains('brother')) return '1 Younger Brother';
    if (lower.contains('sister')) return '1 Elder Sister';
    if (lower.contains('property')) return 'Own House in Bengaluru';
    if (lower.contains('address')) return 'Indiranagar, Bengaluru';
    if (lower.contains('email')) return 'aarav.sharma@example.com';
    if (lower.contains('contact')) return '+91 98765 43210';
    return 'Details Provided';
  }
}
