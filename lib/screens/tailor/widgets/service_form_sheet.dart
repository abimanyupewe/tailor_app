import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tailor_app/controllers/service_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/core/utils/app_toast.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/models/tailor_model.dart';

/// Opens the add/edit service form. Returns true when a service was saved.
Future<bool?> showServiceFormSheet(BuildContext context, {Service? service}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ServiceFormSheet(service: service),
  );
}

class _ServiceFormSheet extends StatefulWidget {
  final Service? service;
  const _ServiceFormSheet({this.service});

  @override
  State<_ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends State<_ServiceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<ServiceController>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descController;
  late final TextEditingController _durationController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _nameController = TextEditingController(text: s?.name ?? '');
    _priceController = TextEditingController(
      text: s == null ? '' : s.price.toStringAsFixed(0),
    );
    _descController = TextEditingController(text: s?.description ?? '');
    _durationController = TextEditingController(
      text: (s?.estimatedDurationDays ?? 1).toString(),
    );
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final error = await _controller.save(
      existing: widget.service,
      name: _nameController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      description: _descController.text.trim(),
      durationDays: int.tryParse(_durationController.text.trim()) ?? 1,
      isActive: _isActive,
    );

    if (!mounted) return;
    if (error == null) {
      Get.back(result: true);
      AppToast.success(l10n.serviceSaved);
    } else {
      AppToast.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.service != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isEditing ? l10n.editService : l10n.addService,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _label(l10n.serviceNameLabel),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(l10n.serviceNameHint),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.requiredField
                    : null,
              ),
              const SizedBox(height: 16),
              _label(l10n.servicePriceLabel),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(l10n.servicePriceHint, prefix: 'Rp '),
                validator: (v) {
                  final value = double.tryParse((v ?? '').trim());
                  if (value == null || value <= 0) return l10n.invalidPrice;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _label(l10n.serviceDurationLabel),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(l10n.serviceDurationHint),
                validator: (v) {
                  final value = int.tryParse((v ?? '').trim());
                  if (value == null || value < 1) return l10n.requiredField;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _label(l10n.serviceDescriptionLabel),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(l10n.serviceDescriptionHint),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
                title: Text(
                  l10n.serviceActiveLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.serviceActiveHint,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: _controller.isSaving.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            l10n.save,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );

  InputDecoration _inputDecoration(String hint, {String? prefix}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefix,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondary.withValues(alpha: 0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
