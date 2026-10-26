import 'package:flutter/material.dart';

enum TemplateCategory { all, traditional, modern, floral, executive }

enum PhotoPosition { top, right }

enum TemplateFrameStyle {
  ornateDouble, // Royal traditional double gold border with corner knots
  floralScallop, // Classic floral curved scalloped corners with botanical motifs
  modernMinimal, // Modern crisp clean hairline frame with subtle shadow
  vedicTemple, // Authentic Vedic stepped pillar / temple arch frame
  executiveBox, // Executive dual-line pinstripe frame with metallic badge
  blushDashed, // Blush elegance dashed decorative border with floating cards
}

class BiodataTemplateModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String tag;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final IconData emblemIcon;
  final String emblemText;
  final PhotoPosition photoPosition;
  final TemplateFrameStyle frameStyle;
  final bool isPhotoCentered;
  final bool hasSidebar;

  const BiodataTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tag,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.emblemIcon,
    required this.emblemText,
    required this.photoPosition,
    required this.frameStyle,
    this.isPhotoCentered = false,
    this.hasSidebar = false,
  });

  static List<BiodataTemplateModel> getTemplates() {
    return [
      const BiodataTemplateModel(
        id: 'royal_traditional',
        name: 'Royal Traditional',
        description:
            'Auspicious maroon & gold with ornate double border, gold halo top photo, and traditional motifs.',
        category: 'Traditional',
        tag: 'Most Popular',
        primaryColor: Color(0xFF900C3F),
        secondaryColor: Color(0xFFD4AF37),
        backgroundColor: Color(0xFFFFFDF5),
        cardColor: Color(0xFFFFF8E7),
        emblemIcon: Icons.favorite_rounded,
        emblemText: '|| श्री गणेशाय नमः ||',
        photoPosition: PhotoPosition.top,
        frameStyle: TemplateFrameStyle.ornateDouble,
        isPhotoCentered: true,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'classic_floral',
        name: 'Classic Floral',
        description:
            'Romantic blush & rose with scalloped petal corners, floral wreath top photo, and pastel cards.',
        category: 'Floral',
        tag: 'Trending',
        primaryColor: Color(0xFFC0405E),
        secondaryColor: Color(0xFFE8A598),
        backgroundColor: Color(0xFFFDF8F9),
        cardColor: Color(0xFFFFF2F5),
        emblemIcon: Icons.local_florist_rounded,
        emblemText: '❀ Vivah Hetu Biodata ❀',
        photoPosition: PhotoPosition.top,
        frameStyle: TemplateFrameStyle.floralScallop,
        isPhotoCentered: true,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'modern_minimalist',
        name: 'Modern Minimalist',
        description:
            'Contemporary crisp layout with prominent right-side photo, bold accent bar, and clean typography.',
        category: 'Modern',
        tag: 'Recommended',
        primaryColor: Color(0xFF1E293B),
        secondaryColor: Color(0xFF0284C7),
        backgroundColor: Color(0xFFFFFFFF),
        cardColor: Color(0xFFF8FAFC),
        emblemIcon: Icons.auto_awesome_rounded,
        emblemText: 'MATRIMONIAL PROFILE',
        photoPosition: PhotoPosition.right,
        frameStyle: TemplateFrameStyle.modernMinimal,
        isPhotoCentered: false,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'vedic_heritage',
        name: 'Vedic Heritage',
        description:
            'Sacred saffron & sandalwood parchment with temple arch frame, centered top photo, and shlokas.',
        category: 'Traditional',
        tag: 'Classic',
        primaryColor: Color(0xFFC2410C),
        secondaryColor: Color(0xFFD97706),
        backgroundColor: Color(0xFFFFFBEB),
        cardColor: Color(0xFFFEF3C7),
        emblemIcon: Icons.brightness_7_rounded,
        emblemText: '|| ॐ श्रीं गणेशाय नमः ||',
        photoPosition: PhotoPosition.top,
        frameStyle: TemplateFrameStyle.vedicTemple,
        isPhotoCentered: true,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'executive_elite',
        name: 'Executive Elite',
        description:
            'Deep peacock navy & champagne gold with right-aligned framed portrait and structured boxed cards.',
        category: 'Executive',
        tag: 'Premium',
        primaryColor: Color(0xFF0F2E4A),
        secondaryColor: Color(0xFFC5A059),
        backgroundColor: Color(0xFFF8FAFC),
        cardColor: Color(0xFFF1F5F9),
        emblemIcon: Icons.workspace_premium_rounded,
        emblemText: 'EXECUTIVE BIODATA',
        photoPosition: PhotoPosition.right,
        frameStyle: TemplateFrameStyle.executiveBox,
        isPhotoCentered: false,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'blush_elegance',
        name: 'Blush Elegance',
        description:
            'Gentle coral & honey peach with dashed ornamental frame, right-side oval photo, and floating cards.',
        category: 'Floral',
        tag: 'New',
        primaryColor: Color(0xFFD9534F),
        secondaryColor: Color(0xFFE08E45),
        backgroundColor: Color(0xFFFFF8F3),
        cardColor: Color(0xFFFFF1EB),
        emblemIcon: Icons.spa_rounded,
        emblemText: '|| शुभम् भवतु ||',
        photoPosition: PhotoPosition.right,
        frameStyle: TemplateFrameStyle.blushDashed,
        isPhotoCentered: false,
        hasSidebar: false,
      ),
    ];
  }
}
