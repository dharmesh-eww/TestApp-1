class BiodataFieldModel {
  String id;
  String label;
  String value;
  final bool canDelete;
  final bool canEditLabel;

  BiodataFieldModel({
    required this.id,
    required this.label,
    this.value = '',
    this.canDelete = true,
    this.canEditLabel = true,
  });

  BiodataFieldModel copyWith({
    String? id,
    String? label,
    String? value,
    bool? canDelete,
    bool? canEditLabel,
  }) {
    return BiodataFieldModel(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      canDelete: canDelete ?? this.canDelete,
      canEditLabel: canEditLabel ?? this.canEditLabel,
    );
  }
}

class BiodataSectionModel {
  String id;
  String title;
  final bool canDelete;
  List<BiodataFieldModel> fields;

  BiodataSectionModel({
    required this.id,
    required this.title,
    this.canDelete = true,
    required this.fields,
  });

  static List<BiodataSectionModel> getInitialSections() {
    return [
      // Section 1: Personal Details (Cannot be deleted)
      BiodataSectionModel(
        id: 'personal_details',
        title: 'Personal Details',
        canDelete: false,
        fields: [
          BiodataFieldModel(
            id: 'p_name',
            label: 'Full Name',
            value: '',
            canDelete: false, // Name can be edited but cannot be deleted
            canEditLabel: true,
          ),
          BiodataFieldModel(
            id: 'p_caste',
            label: 'Caste / Sub-caste',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_dob',
            label: 'Date of Birth',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_height',
            label: 'Height',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_weight',
            label: 'Weight',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_blood_group',
            label: 'Blood Group',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_education',
            label: 'Education',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_occupation',
            label: 'Occupation',
            value: '',
          ),
          BiodataFieldModel(
            id: 'p_income',
            label: 'Income / Salary',
            value: '',
          ),
        ],
      ),

      // Section 2: Family Details (Can be edited, reordered, deleted)
      BiodataSectionModel(
        id: 'family_details',
        title: 'Family Details',
        canDelete: true,
        fields: [
          BiodataFieldModel(
            id: 'f_father_name',
            label: 'Father Name',
            value: '',
          ),
          BiodataFieldModel(
            id: 'f_father_occupation',
            label: 'Father Occupation',
            value: '',
          ),
          BiodataFieldModel(
            id: 'f_mother_name',
            label: 'Mother Name',
            value: '',
          ),
          BiodataFieldModel(
            id: 'f_mother_occupation',
            label: 'Mother Occupation',
            value: '',
          ),
          BiodataFieldModel(
            id: 'f_brother',
            label: 'Brother(s)',
            value: '',
          ),
          BiodataFieldModel(
            id: 'f_sister',
            label: 'Sister(s)',
            value: '',
          ),
        ],
      ),

      // Section 3: Others (Can be edited, reordered, deleted)
      BiodataSectionModel(
        id: 'others',
        title: 'Others',
        canDelete: true,
        fields: [
          BiodataFieldModel(
            id: 'o_property',
            label: 'Property / Assets',
            value: '',
          ),
          BiodataFieldModel(
            id: 'o_address',
            label: 'Address',
            value: '',
          ),
          BiodataFieldModel(
            id: 'o_email',
            label: 'Email',
            value: '',
          ),
          BiodataFieldModel(
            id: 'o_contact',
            label: 'Contact Number',
            value: '',
          ),
        ],
      ),
    ];
  }
}
