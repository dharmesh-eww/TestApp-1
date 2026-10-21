import 'package:flutter/material.dart';

enum TemplateCategory { all, traditional, modern, floral, executive }

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
    this.isPhotoCentered = false,
    this.hasSidebar = false,
  });

  static List<BiodataTemplateModel> getTemplates() {
    return [
      const BiodataTemplateModel(
        id: 'royal_traditional',
        name: 'Royal Traditional',
        description:
            'Auspicious maroon & gold with ornamental borders and traditional motifs.',
        category: 'Traditional',
        tag: 'Most Popular',
        primaryColor: Color(0xFF900C3F),
        secondaryColor: Color(0xFFD4AF37),
        backgroundColor: Color(0xFFFFFDF9),
        cardColor: Color(0xFFFFF8E7),
        emblemIcon: Icons.favorite_rounded,
        emblemText: '|| Shree Ganeshay Namah ||',
        isPhotoCentered: false,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'classic_floral',
        name: 'Classic Floral',
        description:
            'Soft rose pink with delicate botanical corner designs and elegant headings.',
        category: 'Floral',
        tag: 'Trending',
        primaryColor: Color(0xFFC0405E),
        secondaryColor: Color(0xFFE8A598),
        backgroundColor: Color(0xFFFCF8F8),
        cardColor: Color(0xFFFFF2F4),
        emblemIcon: Icons.local_florist_rounded,
        emblemText: '|| Vivah Hetu Biodata ||',
        isPhotoCentered: true,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'modern_minimalist',
        name: 'Modern Minimalist',
        description:
            'Clean split-column layout with photo sidebar and crisp typography.',
        category: 'Modern',
        tag: 'Recommended',
        primaryColor: Color(0xFF2C3E50),
        secondaryColor: Color(0xFF3498DB),
        backgroundColor: Color(0xFFFAFAFA),
        cardColor: Color(0xFFFFFFFF),
        emblemIcon: Icons.auto_awesome_rounded,
        emblemText: 'Matrimonial Resume',
        isPhotoCentered: false,
        hasSidebar: true,
      ),
      const BiodataTemplateModel(
        id: 'vedic_heritage',
        name: 'Vedic Heritage',
        description:
            'Warm saffron & sandalwood tones with sacred shlokas and dual-line frames.',
        category: 'Traditional',
        tag: 'Classic',
        primaryColor: Color(0xFFD35400),
        secondaryColor: Color(0xFFF39C12),
        backgroundColor: Color(0xFFFFFDF5),
        cardColor: Color(0xFFFFF7E6),
        emblemIcon: Icons.brightness_7_rounded,
        emblemText: '|| Om Shreem Namah ||',
        isPhotoCentered: true,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'executive_elite',
        name: 'Executive Elite',
        description:
            'Premium emerald green & champagne gold with structured section boxes.',
        category: 'Executive',
        tag: 'Premium',
        primaryColor: Color(0xFF1B4F72),
        secondaryColor: Color(0xFFC5A059),
        backgroundColor: Color(0xFFFBFBFB),
        cardColor: Color(0xFFF4F6F7),
        emblemIcon: Icons.workspace_premium_rounded,
        emblemText: 'Marriage Biodata',
        isPhotoCentered: false,
        hasSidebar: false,
      ),
      const BiodataTemplateModel(
        id: 'blush_elegance',
        name: 'Blush Elegance',
        description:
            'Gentle coral & peach aesthetic crafted for simple and graceful presentation.',
        category: 'Floral',
        tag: 'New',
        primaryColor: Color(0xFFD9534F),
        secondaryColor: Color(0xFFF0AD4E),
        backgroundColor: Color(0xFFFFFBF8),
        cardColor: Color(0xFFFFF3ED),
        emblemIcon: Icons.spa_rounded,
        emblemText: '|| Shubham Bhavatu ||',
        isPhotoCentered: false,
        hasSidebar: false,
      ),
    ];
  }
}
