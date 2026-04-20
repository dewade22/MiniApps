import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/school_provider.dart';
import '../../data/datasources/academic_remote_datasource.dart';
import '../../data/repositories/school_repository_impl.dart';
import '../../domain/entities/school.dart';
import '../../domain/usecases/get_schools_usecase.dart';
import '../../domain/usecases/create_school_usecase.dart';
import '../../domain/usecases/update_school_usecase.dart';
import '../../domain/usecases/delete_school_usecase.dart';

class SchoolsPage extends StatelessWidget {
  const SchoolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AcademicRemoteDataSource();
    final repo = SchoolRepositoryImpl(ds);
    return ChangeNotifierProvider(
      create: (_) => SchoolProvider(
        getSchoolsUseCase: GetSchoolsUseCase(repo),
        createSchoolUseCase: CreateSchoolUseCase(repo),
        updateSchoolUseCase: UpdateSchoolUseCase(repo),
        deleteSchoolUseCase: DeleteSchoolUseCase(repo),
      )..load(),
      child: const _SchoolsView(),
    );
  }
}

class _SchoolsView extends StatelessWidget {
  const _SchoolsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Schools')),
      body: Consumer<SchoolProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: provider.load, child: const Text('Retry')),
                ],
              ),
            );
          }
          if (provider.schools.isEmpty) {
            return const Center(child: Text('No schools found'));
          }
          return RefreshIndicator(
            onRefresh: provider.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.schools.length,
              itemBuilder: (context, index) =>
                  _SchoolTile(school: provider.schools[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _SchoolFormDialog(provider: context.read<SchoolProvider>()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SchoolTile extends StatelessWidget {
  final School school;
  const _SchoolTile({required this.school});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SchoolProvider>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: school.isActive ? Colors.blue : Colors.grey,
          child: Text(
            school.educationLevel,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(school.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${school.code} · ${school.city}, ${school.province}'),
            Text(
              '${school.schoolType} · Akreditasi ${school.accreditation} · ${school.isActive ? "Aktif" : "Tidak Aktif"}',
              style: TextStyle(color: school.isActive ? Colors.green : Colors.red, fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _SchoolFormDialog(provider: provider, school: school),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, SchoolProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete School'),
        content: Text('Delete "${school.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await provider.delete(school.uuid);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'School deleted' : provider.error ?? 'Failed'),
                  backgroundColor: ok ? Colors.green : Colors.red,
                ));
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── Form Dialog ──────────────────────────────────────────────────────────────

class _SchoolFormDialog extends StatefulWidget {
  final SchoolProvider provider;
  final School? school;
  const _SchoolFormDialog({required this.provider, this.school});

  @override
  State<_SchoolFormDialog> createState() => _SchoolFormDialogState();
}

class _SchoolFormDialogState extends State<_SchoolFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _provinceCtrl;
  late final TextEditingController _postalCodeCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _principalNameCtrl;
  late String _accreditation;
  late String _schoolType;
  late String _educationLevel;
  late bool _isActive;

  bool get _isEdit => widget.school != null;

  static const _accreditationOptions = ['A', 'B', 'C', 'Not Yet'];
  static const _schoolTypeOptions = ['Public', 'Private'];
  static const _educationLevelOptions = ['SD', 'SMP', 'SMA', 'SMK'];

  @override
  void initState() {
    super.initState();
    final s = widget.school;
    _nameCtrl          = TextEditingController(text: s?.name ?? '');
    _codeCtrl          = TextEditingController(text: s?.code ?? '');
    _addressCtrl       = TextEditingController(text: s?.address ?? '');
    _cityCtrl          = TextEditingController(text: s?.city ?? '');
    _provinceCtrl      = TextEditingController(text: s?.province ?? '');
    _postalCodeCtrl    = TextEditingController(text: s?.postalCode ?? '');
    _phoneCtrl         = TextEditingController(text: s?.phone ?? '');
    _emailCtrl         = TextEditingController(text: s?.email ?? '');
    _websiteCtrl       = TextEditingController(text: s?.website ?? '');
    _principalNameCtrl = TextEditingController(text: s?.principalName ?? '');
    _accreditation     = s?.accreditation ?? 'Not Yet';
    _schoolType        = s?.schoolType ?? 'Public';
    _educationLevel    = s?.educationLevel ?? 'SMA';
    _isActive          = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _postalCodeCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _websiteCtrl.dispose();
    _principalNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit School' : 'Add School'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(_nameCtrl, 'School Name', required: true),
                _field(_codeCtrl, 'School Code (NPSN)', required: true),
                _field(_addressCtrl, 'Address', required: true, maxLines: 2),
                Row(children: [
                  Expanded(child: _field(_cityCtrl, 'City', required: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _field(_provinceCtrl, 'Province', required: true)),
                ]),
                Row(children: [
                  Expanded(child: _field(_postalCodeCtrl, 'Postal Code', required: true, keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: _field(_phoneCtrl, 'Phone', required: true, keyboardType: TextInputType.phone)),
                ]),
                _field(_emailCtrl, 'Email', required: true, keyboardType: TextInputType.emailAddress),
                _field(_websiteCtrl, 'Website (optional)'),
                _field(_principalNameCtrl, 'Principal Name', required: true),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: _dropdown('Education Level', _educationLevelOptions, _educationLevel,
                      (v) => setState(() => _educationLevel = v!))),
                  const SizedBox(width: 8),
                  Expanded(child: _dropdown('School Type', _schoolTypeOptions, _schoolType,
                      (v) => setState(() => _schoolType = v!))),
                ]),
                const SizedBox(height: 8),
                _dropdown('Accreditation', _accreditationOptions, _accreditation,
                    (v) => setState(() => _accreditation = v!)),
                const SizedBox(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }

  Widget _dropdown(String label, List<String> options, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final ok = _isEdit
        ? await widget.provider.update(
            uuid:           widget.school!.uuid,
            name:           _nameCtrl.text.trim(),
            code:           _codeCtrl.text.trim(),
            address:        _addressCtrl.text.trim(),
            city:           _cityCtrl.text.trim(),
            province:       _provinceCtrl.text.trim(),
            postalCode:     _postalCodeCtrl.text.trim(),
            phone:          _phoneCtrl.text.trim(),
            email:          _emailCtrl.text.trim(),
            website:        _websiteCtrl.text.trim().isEmpty ? null : _websiteCtrl.text.trim(),
            principalName:  _principalNameCtrl.text.trim(),
            accreditation:  _accreditation,
            schoolType:     _schoolType,
            educationLevel: _educationLevel,
            isActive:       _isActive,
          )
        : await widget.provider.create(
            name:           _nameCtrl.text.trim(),
            code:           _codeCtrl.text.trim(),
            address:        _addressCtrl.text.trim(),
            city:           _cityCtrl.text.trim(),
            province:       _provinceCtrl.text.trim(),
            postalCode:     _postalCodeCtrl.text.trim(),
            phone:          _phoneCtrl.text.trim(),
            email:          _emailCtrl.text.trim(),
            website:        _websiteCtrl.text.trim().isEmpty ? null : _websiteCtrl.text.trim(),
            principalName:  _principalNameCtrl.text.trim(),
            accreditation:  _accreditation,
            schoolType:     _schoolType,
            educationLevel: _educationLevel,
            isActive:       _isActive,
          );

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? (_isEdit ? 'School updated' : 'School created')
            : widget.provider.error ?? 'Operation failed'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }
}
