import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tailor_app/controllers/profile_controller.dart';
import 'package:tailor_app/core/constants/app_colors.dart';
import 'package:tailor_app/data/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_app/l10n/generated/app_localizations.dart';
import 'package:tailor_app/widgets/skeleton.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final userData = controller.user.value ?? {};
    final user = userData['user'] ?? {};

    // Check both locations for address and phone
    final address = userData['address'] ?? user['address'] ?? '';
    final phone = userData['phone_number'] ?? user['phone_number'] ?? '';
    final email = user['email'] ?? '';

    final String firstName = user['first_name'] ?? '';
    final String lastName = user['last_name'] ?? '';
    _fullNameController = TextEditingController(
      text: '$firstName $lastName'.trim(),
    );
    _phoneController = TextEditingController(text: phone);
    _addressController = TextEditingController(text: address);
    _emailController = TextEditingController(text: email);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensuring user data is available
    if (controller.user.value == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: FormLoadingSkeleton()),
      );
    }

    final avatarUrl = controller.user.value?['user']?['avatar'];
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).editProfileTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => controller.isSaving.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      final fullName = _fullNameController.text.trim();
                      final nameParts = fullName.split(' ');
                      final firstName = nameParts.isNotEmpty
                          ? nameParts.first
                          : '';
                      final lastName = nameParts.length > 1
                          ? nameParts.sublist(1).join(' ')
                          : '';

                      controller.updateUserProfile(
                        firstName: firstName,
                        lastName: lastName,
                        phoneNumber: _phoneController.text,
                        address: _addressController.text,
                        email: _emailController.text,
                      );
                    },
                    child: Builder(
                      builder: (context) => Text(
                        AppLocalizations.of(context).save,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- Avatar Picker ---
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    ImageProvider? imageProvider;
                    if (controller.selectedImage.value != null) {
                      imageProvider = FileImage(
                        controller.selectedImage.value!,
                      );
                    } else if (avatarUrl != null &&
                        avatarUrl.toString().isNotEmpty) {
                      imageProvider = NetworkImage(
                        Get.find<ApiService>().getImageUrl(avatarUrl),
                      );
                    }

                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(color: AppColors.primary, width: 2),
                        image: imageProvider != null
                            ? DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imageProvider == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : null,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showImagePickerOptions(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Iconsax.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Form Fields ---
            _buildTextField(
              label: l10n.fullName,
              controller: _fullNameController,
              icon: Iconsax.user,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: l10n.phoneNumber,
              controller: _phoneController,
              icon: Iconsax.mobile,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: l10n.emailLabel,
              controller: _emailController,
              icon: Iconsax.sms,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: l10n.addressLabel,
              controller: _addressController,
              icon: Iconsax.location,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context).chooseGallery),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context).takePhoto),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary.withValues(alpha: 0.12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary.withValues(alpha: 0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
