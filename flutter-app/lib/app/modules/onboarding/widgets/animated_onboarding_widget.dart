import 'package:flutter/material.dart';

import 'animated_onboarding_type.dart';

class AnimatedOnboardingImage extends StatefulWidget {
  final String imagePath;
  final AnimationType animationType;
  final double height;

  const AnimatedOnboardingImage({
    super.key,
    required this.imagePath,
    required this.animationType,
    this.height = 200,
  });

  @override
  State<AnimatedOnboardingImage> createState() =>
      _AnimatedOnboardingImageState();
}

class _AnimatedOnboardingImageState extends State<AnimatedOnboardingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    switch (widget.animationType) {
      case AnimationType.fade:
        _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeIn),
        );
        break;

      case AnimationType.scale:
        _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        );
        break;

      case AnimationType.slideFromBottom:
        _slideAnimation =
            Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
                .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
        break;

      case AnimationType.slideFromLeft:
        _slideAnimation =
            Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
        break;

      case AnimationType.rotation:
        _rotationAnimation = Tween<double>(begin: -0.3, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
        break;
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Image.asset(
        widget.imagePath,
        height: widget.height,
        fit: BoxFit.cover,
      ),
    );

    switch (widget.animationType) {
      case AnimationType.fade:
        return FadeTransition(opacity: _fadeAnimation, child: image);

      case AnimationType.scale:
        return ScaleTransition(scale: _scaleAnimation, child: image);

      case AnimationType.slideFromBottom:
      case AnimationType.slideFromLeft:
        return SlideTransition(position: _slideAnimation, child: image);

      case AnimationType.rotation:
        return RotationTransition(turns: _rotationAnimation, child: image);
    }
  }
}
