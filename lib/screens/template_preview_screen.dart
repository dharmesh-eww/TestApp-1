import 'package:flutter/material.dart';
import '../models/biodata_template_model.dart';
import '../theme/app_colors.dart';

class TemplatePreviewScreen extends StatelessWidget {
  final BiodataTemplateModel template;
  final String? candidateName;
  final bool isSelectionMode;

  const TemplatePreviewScreen({
    super.key,
    required this.template,
    this.candidateName,
    this.isSelectionMode = true,
  });

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${template.name} Preview',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              'Printable A4 PDF & Image Ready',
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
              color: template.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              template.category,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: template.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: _buildRealisticBiodataSheet(template),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (isSelectionMode) ...[
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text(
                      'Choose This Template',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: template.primaryColor,
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
            ],
          ),
        ),
      ),
    );
  }

  // Realistic Full A4 Preview Sheet (without top header)
  Widget _buildRealisticBiodataSheet(BiodataTemplateModel template) {
    final previewName = candidateName ?? 'Aarav Sharma';

    // If template is a two-column profile layout with facts panel
    if (template.hasSidebar) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _buildRealisticSheetDecoration(template),
        child: _buildRealisticTwoColumnProfile(template, previewName),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _buildRealisticSheetDecoration(template),
      child: Column(
        children: [
          // Profile Section directly at top (top header removed)
          if (template.photoPosition == PhotoPosition.top)
            _buildRealisticTopPhotoProfile(template, previewName)
          else
            _buildRealisticRightPhotoProfile(template, previewName),

          const SizedBox(height: 16),

          // Section 1: Personal Details (from form screen)
          _buildFullSectionHeader('Personal Details', template),
          const SizedBox(height: 8),
          _buildFullFieldRow(
              'Date of Birth:', '15 October 1996 (28 Yrs)', template),
          _buildFullFieldRow(
              'Height:', "5' 10\" (178 cm)", template),
          _buildFullFieldRow(
              'Caste / Sub-caste:', 'Hindu - Brahmin (Kashyap)', template),
          _buildFullFieldRow(
              'Education:', 'B.Tech in Computer Science', template),
          _buildFullFieldRow(
              'Occupation:', 'Software Professional', template),
          _buildFullFieldRow(
              'Income / Salary:', '₹ 25,00,000 / Year', template),

          const SizedBox(height: 14),

          // Section 2: Family Details (from form screen)
          _buildFullSectionHeader('Family Details', template),
          const SizedBox(height: 8),
          _buildFullFieldRow(
              'Father Name:', 'Rajesh Sharma (Businessman)', template),
          _buildFullFieldRow(
              'Mother Name:', 'Sunita Sharma (Homemaker)', template),
          _buildFullFieldRow(
              'Brother(s):', '1 Younger Brother (Studying MBA)', template),
          _buildFullFieldRow(
              'Sister(s):', '1 Elder Sister (Married)', template),

          const SizedBox(height: 14),

          // Section 3: Others / Contact (from form screen)
          _buildFullSectionHeader('Others / Contact', template),
          const SizedBox(height: 8),
          _buildFullFieldRow(
              'Address:', '104, Golden Palms, Ahmedabad, Gujarat', template),
          _buildFullFieldRow(
              'Contact Number:', '+91 98765 43210', template),
          _buildFullFieldRow(
              'Email:', 'sharma.aarav@example.com', template),
        ],
      ),
    );
  }

  // Realistic Two-Column Matrimonial Profile Layout
  Widget _buildRealisticTwoColumnProfile(
      BiodataTemplateModel template, String previewName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column / Facts Panel
        Container(
          width: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: template.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: template.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildRealisticPhotoWidget(template, isTop: true),
              const SizedBox(height: 10),
              Text(
                previewName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: template.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Marriage Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              // Contact details in panel
              _buildSidebarItem(Icons.phone_rounded, '+91 98765 43210', template),
              _buildSidebarItem(Icons.email_rounded, 'aarav@mail.com', template),
              _buildSidebarItem(Icons.location_on_rounded, 'Ahmedabad', template),
              const SizedBox(height: 10),
              Container(
                height: 1,
                width: double.infinity,
                color: template.primaryColor.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 10),
              _buildSidebarItem(Icons.cake_rounded, '15 Oct 1996', template),
              _buildSidebarItem(Icons.height_rounded, "5' 10\" Height", template),
              _buildSidebarItem(Icons.temple_hindu_rounded, 'Brahmin Gotra', template),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // Right Column: Main Form Fields
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFullSectionHeader('Personal Details', template),
              const SizedBox(height: 6),
              _buildFullFieldRow('Education:', 'B.Tech Computer Science', template),
              _buildFullFieldRow('Occupation:', 'Software Professional', template),
              _buildFullFieldRow('Income / Salary:', '₹ 25 LPA', template),
              _buildFullFieldRow('Caste / Sub-caste:', 'Hindu - Brahmin', template),

              const SizedBox(height: 12),

              _buildFullSectionHeader('Family Details', template),
              const SizedBox(height: 6),
              _buildFullFieldRow('Father Name:', 'Rajesh Sharma (Business)', template),
              _buildFullFieldRow('Mother Name:', 'Sunita Sharma (Homemaker)', template),
              _buildFullFieldRow('Brother(s):', '1 Younger Brother (MBA)', template),
              _buildFullFieldRow('Sister(s):', '1 Elder Sister (Married)', template),

              const SizedBox(height: 12),

              _buildFullSectionHeader('Others / Residence', template),
              const SizedBox(height: 6),
              _buildFullFieldRow('Address:', 'Ahmedabad, Gujarat', template),
              _buildFullFieldRow('Contact Number:', '+91 98765 43210', template),
              _buildFullFieldRow('Email:', 'sharma.aarav@example.com', template),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(
      IconData icon, String text, BiodataTemplateModel template) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 12, color: template.primaryColor),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: template.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Realistic Sheet Outer Decoration with Distinct Frames & Backgrounds
  BoxDecoration _buildRealisticSheetDecoration(BiodataTemplateModel template) {
    DecorationImage? bgImage;
    if (template.backgroundImage != null) {
      bgImage = DecorationImage(
        image: AssetImage(template.backgroundImage!),
        fit: BoxFit.cover,
        opacity: 0.12,
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
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        );

      case TemplateFrameStyle.simpleCard:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: template.secondaryColor.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        );

      case TemplateFrameStyle.ornateDouble:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: template.secondaryColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.floralScallop:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: template.secondaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.modernMinimal:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.vedicTemple:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: template.primaryColor, width: 2.2),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.20),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.executiveBox:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: template.secondaryColor, width: 2.2),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.blushDashed:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: template.primaryColor.withValues(alpha: 0.5),
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.geometricFretwork:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: template.secondaryColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.22),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.botanicalWreath:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: template.secondaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.artisticMosaic:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: template.secondaryColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: template.primaryColor.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.luxuryPinstripe:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: template.secondaryColor, width: 2.8),
          boxShadow: [
            BoxShadow(
              color: template.secondaryColor.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case TemplateFrameStyle.twoColumnProfile:
        return BoxDecoration(
          color: template.backgroundColor,
          image: bgImage,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: template.secondaryColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }

  // Realistic Sheet: Centered Top Photo (Never Left!)
  Widget _buildRealisticTopPhotoProfile(
      BiodataTemplateModel template, String previewName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Centered Photo
        Center(
          child: _buildRealisticPhotoWidget(template, isTop: true),
        ),
        const SizedBox(height: 10),

        // 2. Full Name & Subtitle
        Text(
          previewName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: template.primaryColor,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Marriage Biodata Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),

        // 3. Highlight Details Box (Full Width)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: template.secondaryColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildFullFieldRow(
                  'Date of Birth:', '15 October 1996 (28 Yrs)', template),
              _buildFullFieldRow(
                  'Height:', "5' 10\" (178 cm)", template),
              _buildFullFieldRow(
                  'Caste / Sub-caste:', 'Hindu - Brahmin • Kashyap Gotra', template),
            ],
          ),
        ),
      ],
    );
  }

  // Realistic Sheet: Photo on RIGHT of Content (Never Left!)
  Widget _buildRealisticRightPhotoProfile(
      BiodataTemplateModel template, String previewName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content on the LEFT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                previewName,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: template.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Marriage Biodata Profile',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              _buildFullFieldRow(
                  'Date of Birth:', '15 October 1996 (28 Yrs)', template),
              _buildFullFieldRow(
                  'Height:', "5' 10\" (178 cm)", template),
              _buildFullFieldRow(
                  'Caste / Sub-caste:', 'Hindu - Brahmin • Kashyap Gotra', template),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Photo on the RIGHT (Strictly Right side, Never Left)
        _buildRealisticPhotoWidget(template, isTop: false),
      ],
    );
  }

  // Realistic Photo Frame styled per template
  Widget _buildRealisticPhotoWidget(BiodataTemplateModel template,
      {required bool isTop}) {
    final double width = isTop ? 94 : 96;
    final double height = isTop ? 94 : 118;

    switch (template.frameStyle) {
      case TemplateFrameStyle.ornateDouble:
      case TemplateFrameStyle.geometricFretwork:
        return Container(
          width: width,
          height: width, // Circular halo
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.cardColor,
            border: Border.all(color: template.secondaryColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: template.secondaryColor.withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: 52,
              color: template.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        );

      case TemplateFrameStyle.floralScallop:
      case TemplateFrameStyle.botanicalWreath:
        return Container(
          width: width,
          height: width, // Floral wreath circular
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: template.cardColor,
            border: Border.all(color: template.secondaryColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: template.primaryColor.withValues(alpha: 0.15),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: 50,
              color: template.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        );

      case TemplateFrameStyle.simpleLine:
      case TemplateFrameStyle.simpleCard:
      case TemplateFrameStyle.modernMinimal:
      case TemplateFrameStyle.twoColumnProfile:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: template.primaryColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: 52,
              color: template.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        );

      case TemplateFrameStyle.vedicTemple:
        return Container(
          width: width,
          height: width * 1.15,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
              bottom: Radius.circular(8),
            ),
            border: Border.all(color: template.primaryColor, width: 2.5),
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: 50,
              color: template.primaryColor,
            ),
          ),
        );

      case TemplateFrameStyle.executiveBox:
      case TemplateFrameStyle.luxuryPinstripe:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: template.secondaryColor, width: 2.2),
            boxShadow: [
              BoxShadow(
                color: template.primaryColor.withValues(alpha: 0.18),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: 52,
              color: template.primaryColor.withValues(alpha: 0.75),
            ),
          ),
        );

      case TemplateFrameStyle.blushDashed:
      case TemplateFrameStyle.artisticMosaic:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: template.primaryColor.withValues(alpha: 0.5),
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: template.primaryColor.withValues(alpha: 0.12),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: 52,
              color: template.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        );
    }
  }

  // Realistic Section Header styled uniquely per template
  Widget _buildFullSectionHeader(
      String title, BiodataTemplateModel template) {
    switch (template.frameStyle) {
      case TemplateFrameStyle.ornateDouble:
      case TemplateFrameStyle.geometricFretwork:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: template.primaryColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: template.secondaryColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('✦ ',
                  style: TextStyle(
                      color: template.secondaryColor, fontSize: 11)),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Text(' ✦',
                  style: TextStyle(
                      color: template.secondaryColor, fontSize: 11)),
            ],
          ),
        );

      case TemplateFrameStyle.floralScallop:
      case TemplateFrameStyle.botanicalWreath:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: template.secondaryColor, width: 1.2),
          ),
          child: Row(
            children: [
              Icon(Icons.local_florist_rounded,
                  size: 14, color: template.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: template.primaryColor,
                ),
              ),
            ],
          ),
        );

      case TemplateFrameStyle.simpleLine:
      case TemplateFrameStyle.simpleCard:
      case TemplateFrameStyle.modernMinimal:
      case TemplateFrameStyle.twoColumnProfile:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(color: template.primaryColor, width: 4),
            ),
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: template.primaryColor,
            ),
          ),
        );

      case TemplateFrameStyle.vedicTemple:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: template.primaryColor, width: 1.2),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: template.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );

      case TemplateFrameStyle.executiveBox:
      case TemplateFrameStyle.luxuryPinstripe:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: template.cardColor,
            border: Border(
              bottom: BorderSide(color: template.secondaryColor, width: 2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.check_box_outline_blank_rounded,
                  size: 10, color: template.secondaryColor),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: template.primaryColor,
                ),
              ),
            ],
          ),
        );

      case TemplateFrameStyle.blushDashed:
      case TemplateFrameStyle.artisticMosaic:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: template.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.spa_rounded, size: 14, color: template.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: template.primaryColor,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildFullFieldRow(
      String label, String value, BiodataTemplateModel template) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
}
