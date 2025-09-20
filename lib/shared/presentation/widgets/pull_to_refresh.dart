import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class PullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double triggerDistance;
  final double refreshDistance;
  
  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerDistance = 80.0,
    this.refreshDistance = 100.0,
  });

  @override
  State<PullToRefresh> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  bool _isRefreshing = false;
  double _dragDistance = 0.0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    _controller.forward();
    HapticFeedback.mediumImpact();
    
    try {
      await widget.onRefresh();
    } finally {
      await _controller.reverse();
      setState(() {
        _isRefreshing = false;
        _dragDistance = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      backgroundColor: AppColors.surface,
      color: AppColors.primary,
      strokeWidth: 3.0,
      displacement: 40.0,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels < -widget.triggerDistance && !_isRefreshing) {
              setState(() {
                _dragDistance = (-notification.metrics.pixels - widget.triggerDistance)
                    .clamp(0.0, widget.refreshDistance);
              });
            }
          }
          return false;
        },
        child: Stack(
          children: [
            widget.child,
            if (_dragDistance > 0 || _isRefreshing)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isRefreshing ? _animation.value : _dragDistance / widget.refreshDistance,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.purpleBlueGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonGlowPurple.withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: _isRefreshing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}