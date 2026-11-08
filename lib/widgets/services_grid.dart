import 'package:flutter/material.dart';

class ServiceEntry {
  final String label;
  final String query;
  final IconData icon;
  final Color background;
  final Color foreground;

  const ServiceEntry({
    required this.label,
    required this.query,
    required this.icon,
    required this.background,
    required this.foreground,
  });
}

/// Gojek-style quick-access service grid. Fixed 4-column layout sized to
/// fit a 56px icon box plus a 2-line label without overflow down to 320px
/// phones (aspect 0.6 gives each cell enough vertical room for the label).
class ServicesGrid extends StatelessWidget {
  final List<ServiceEntry> services;
  final ValueChanged<String> onSelect;

  const ServicesGrid({
    super.key,
    required this.services,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return GestureDetector(
          onTap: () => onSelect(service.query),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: service.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  service.icon,
                  color: service.foreground,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
