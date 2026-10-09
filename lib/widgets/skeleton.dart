import 'package:flutter/material.dart';

/// Animated placeholder box (flat, no shadow). Pulse between [baseColor]
/// and [highlightColor] so content loading feels alive without a spinner.
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final bool circle;
  final Color baseColor;
  final Color highlightColor;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.circle = false,
    this.baseColor = const Color(0xFFE6ECE9),
    this.highlightColor = const Color(0xFFF1F5F3),
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(
            widget.baseColor,
            widget.highlightColor,
            _controller.value,
          ),
          borderRadius: widget.circle
              ? null
              : BorderRadius.circular(widget.borderRadius),
          shape: widget.circle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

/// Full home-page loading state. Mirrors the real layout
/// (header → search → banner → categories → tailor rows).
class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // Header
        const Row(
          children: [
            SkeletonBox(width: 48, height: 48, circle: true),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 90, height: 10),
                  SizedBox(height: 6),
                  SkeletonBox(width: 140, height: 14),
                  SizedBox(height: 6),
                  SkeletonBox(width: 180, height: 10),
                ],
              ),
            ),
            SizedBox(width: 12),
            SkeletonBox(width: 44, height: 44, borderRadius: 12),
          ],
        ),
        const SizedBox(height: 24),
        // Search bar
        const SkeletonBox(height: 52, borderRadius: 10),
        const SizedBox(height: 24),
        // Banner
        const SkeletonBox(height: 160, borderRadius: 12),
        const SizedBox(height: 24),
        // Section title
        const SkeletonBox(width: 120, height: 16),
        const SizedBox(height: 12),
        // Categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (_) => const Column(
              children: [
                SkeletonBox(width: 56, height: 56, borderRadius: 16),
                SizedBox(height: 8),
                SkeletonBox(width: 48, height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SkeletonBox(width: 140, height: 16),
        const SizedBox(height: 16),
        // Tailor rows
        ...List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SkeletonBox(width: 84, height: 84, borderRadius: 12),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 150, height: 14),
                      SizedBox(height: 8),
                      SkeletonBox(width: 100, height: 10),
                      SizedBox(height: 8),
                      SkeletonBox(width: 180, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Vertical list of card rows (search, orders, map sheet).
class CardListSkeleton extends StatelessWidget {
  final int itemCount;

  const CardListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const Row(
        children: [
          SkeletonBox(width: 72, height: 72, borderRadius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 150, height: 14),
                SizedBox(height: 8),
                SkeletonBox(width: 100, height: 10),
                SizedBox(height: 8),
                SkeletonBox(width: 180, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat room rows (avatar + text lines).
class ChatListSkeleton extends StatelessWidget {
  const ChatListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => const Row(
        children: [
          SkeletonBox(width: 52, height: 52, circle: true),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 120, height: 13),
                SizedBox(height: 8),
                SkeletonBox(width: double.infinity, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat bubbles (alternating left / right).
class ChatBubbleSkeleton extends StatelessWidget {
  const ChatBubbleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final isMe = index.isOdd;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: SkeletonBox(
            width: 180 + (index % 3) * 30,
            height: 44,
            borderRadius: 14,
          ),
        );
      },
    );
  }
}

/// Profile loading state — mirrors the real layout
/// (dark header + white rounded sheet with grouped menus).
class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const base = Color(0xFF24463F);
    const highlight = Color(0xFF2F5A51);
    return Column(
      children: [
        const SizedBox(height: 12),
        const Center(
          child: SkeletonBox(
            width: 94,
            height: 94,
            circle: true,
            baseColor: base,
            highlightColor: highlight,
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: SkeletonBox(
            width: 150,
            height: 18,
            baseColor: base,
            highlightColor: highlight,
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: SkeletonBox(
            width: 190,
            height: 12,
            baseColor: base,
            highlightColor: highlight,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: List.generate(
                      2,
                      (_) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            SkeletonBox(
                              width: 38,
                              height: 38,
                              borderRadius: 12,
                            ),
                            SizedBox(width: 14),
                            Expanded(child: SkeletonBox(height: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        SkeletonBox(width: 38, height: 38, borderRadius: 12),
                        SizedBox(width: 14),
                        Expanded(child: SkeletonBox(height: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Form skeleton (edit profile).
class FormLoadingSkeleton extends StatelessWidget {
  const FormLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        const Center(child: SkeletonBox(width: 96, height: 96, circle: true)),
        const SizedBox(height: 24),
        ...List.generate(
          4,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 100, height: 12),
                SizedBox(height: 8),
                SkeletonBox(height: 52),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
