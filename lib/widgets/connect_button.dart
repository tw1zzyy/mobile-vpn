// lib/widgets/connect_button.dart
import 'package:flutter/material.dart';
import '../providers/vpn_provider.dart';
import '../utils/theme.dart';

class ConnectButton extends StatefulWidget {
  final VpnStatus status;
  final VoidCallback onTap;

  const ConnectButton({super.key, required this.status, required this.onTap});

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _updateAnimations();
  }

  @override
  void didUpdateWidget(ConnectButton old) {
    super.didUpdateWidget(old);
    if (old.status != widget.status) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    switch (widget.status) {
      case VpnStatus.connecting:
        _spinController.repeat();
        _pulseController.stop();
        break;
      case VpnStatus.connected:
        _spinController.stop();
        _pulseController.repeat(reverse: true);
        break;
      case VpnStatus.disconnected:
        _spinController.stop();
        _pulseController.stop();
        break;
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _buttonColor {
    switch (widget.status) {
      case VpnStatus.connected:
        return AppTheme.connectedGreen;
      case VpnStatus.connecting:
        return Colors.white;
      case VpnStatus.disconnected:
        return Colors.grey.shade600;
    }
  }

  String get _label {
    switch (widget.status) {
      case VpnStatus.connected:
        return 'Connected';
      case VpnStatus.connecting:
        return 'Connecting...';
      case VpnStatus.disconnected:
        return 'Disconnected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.status == VpnStatus.connecting ? null : widget.onTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_spinController, _pulseController]),
            builder: (context, child) {
              return ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _buttonColor.withOpacity(0.15),
                    border: Border.all(
                      color: _buttonColor,
                      width: widget.status == VpnStatus.connected ? 3 : 2,
                    ),
                    boxShadow: widget.status == VpnStatus.connected
                        ? [
                            BoxShadow(
                              color: AppTheme.connectedGreen.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ]
                        : widget.status == VpnStatus.connecting
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  child: widget.status == VpnStatus.connecting
                      ? RotationTransition(
                          turns: _spinController,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shield,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.shield,
                            size: 56,
                            color: _buttonColor,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _buttonColor,
            letterSpacing: 0.5,
          ),
          child: Text(_label),
        ),
      ],
    );
  }
}
