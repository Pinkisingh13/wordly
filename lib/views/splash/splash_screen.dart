import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:wordly/data/services/analytics_service.dart';
import 'package:wordly/utils/helper_function.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Posthog().screen(screenName: 'Example Screen');

    final width = HelperFunction.width(context);
    final height = HelperFunction.height(context);

    // Animation configuration
    final slideDuration = 800.ms;
    final fadeDuration = 1.seconds;
    final starDelay = 400.ms;

    return Scaffold(
      backgroundColor: const Color(0xffF5FFFA),
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: const Color(0xffF5FFFA),
      ),
      body: Column(
        children: [
          // Top star with bouncing entrance
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 50, top: 40),
              child: SvgPicture.asset(
                    'assets/singlestar.svg',
                    width: 20,
                    height: 20,
                  )
                  .animate()
                  .slideX(
                    begin: 1.5,
                    end: 0,
                    duration: slideDuration,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: fadeDuration),
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                // Main content column
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: Column(
                    children: [
                      // Logo with elastic pop-in
                      Image.asset(
                        'assets/logo_png.png',
                        width: 200,
                        height: 200,
                      ).animate().scale(
                        duration: 3.seconds,
                        begin: const Offset(0.5, 0.5),
                        curve: Curves.elasticOut,
                      ),
                      SizedBox(height: 20),
                      // Text with fade and slide
                      const Text(
                            "Word Fun For Little Champions!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 107, 107, 107),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 2.seconds)
                          .slideY(begin: 0.5, end: 0),

                      // Play button with multiple effects
                      SizedBox(height: 200),
                      GestureDetector(
                        onTap: () {

                          //Post Hog
                        AnalyticsService.trackEvent(eventName: "Going to HomeScreen",);
                          Navigator.pushReplacementNamed(
                            context,
                            '/homescreen',
                          );
                        },
                        child: Container(
                              alignment: Alignment.center,
                              height: 64,
                              width: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffFF6B6B),
                                    Color(0xffFF8B94),
                                  ],
                                ),
                              ),
                              child: const Text(
                                "Let's Play! ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            // .flip(duration: 800.ms, curve: Curves.easeInOut)
                            .then(delay: 400.ms)
                            .shimmer(
                              duration: 1.seconds,
                              color: Colors.white.withAlpha(
                                (0.4 * 255).toInt(),
                              ),
                            )
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.05, 1.05),
                              duration: 2.seconds,
                            ),
                      ),
                    ],
                  ),
                ),

                // Animated elements with proper infinite animations
                Positioned(
                  top: height * 0.4,
                  left: width * 0.2,
                  child: SvgPicture.asset(
                        'assets/stars.svg',
                        width: 50,
                        height: 50,
                      )
                      .animate(delay: starDelay)
                      .slide(
                        begin: const Offset(-1, 0),
                        duration: slideDuration,
                      )
                      .fadeIn(duration: fadeDuration)
                      .rotate(begin: -0.2, end: 0.2, duration: 2.seconds),
                ),

                // Blue circle with bounce effect
                SvgPicture.asset(
                      'assets/blue_circle.svg',
                      height: 50,
                      width: 50,
                    )
                    .animate(delay: starDelay * 2)
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                    )
                    .fadeIn(),

                // R Character with continuous shake
                Positioned(
                  bottom: height * 0.7,
                  left: width * 0.12,
                  child: SvgPicture.asset(
                        'assets/charr.svg',
                        height: 20,
                        width: 20,
                      )
                      .animate(delay: starDelay * 3)
                      .slideY(begin: 1.5, end: 0, curve: Curves.bounceOut),
                ),

                // Bouncing E character
                Positioned(
                  bottom: height * 0.5,
                  right: width * 0.12,
                  child: SvgPicture.asset(
                        'assets/chare.svg',
                        height: 15,
                        width: 15,
                      )
                      .animate(delay: starDelay * 4)
                      .slideX(begin: 1.5, end: 0, curve: Curves.easeOutBack),
                ),

                // Swinging W character
                Positioned(
                  bottom: height * 0.5,
                  right: width * 0.40,
                  child: SvgPicture.asset(
                        'assets/charw.svg',
                        height: 15,
                        width: 15,
                      )
                      .animate(delay: starDelay * 5)
                      .slideX(begin: -1.5, end: 0, curve: Curves.easeOutBack),
                ),

                // Pulsing pink circle
                Positioned(
                  right: width * 0.1,
                  bottom: height * 0.3,
                  child: SvgPicture.asset(
                        'assets/pink_circle.svg',
                        height: 40,
                        width: 40,
                      )
                      .animate(delay: starDelay * 6)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        curve: Curves.elasticOut,
                      ),
                ),

                // Rotating star
                Positioned(
                  left: width * 0.2,
                  bottom: height * 0.16,
                  child: SvgPicture.asset(
                        'assets/star_two.svg',
                        height: 20,
                        width: 20,
                      )
                      .animate(delay: starDelay * 7)
                      .slideX(begin: -1.5, end: 0, curve: Curves.easeOutBack)
                      .rotate(duration: 1.seconds),
                ),

                // Shaking peach circle
                Positioned(
                  left: width * 0.5,
                  bottom: height * 0.20,
                  child: SvgPicture.asset(
                        'assets/peach_circle.svg',
                        height: 40,
                        width: 40,
                      )
                      .animate(
                        delay: starDelay * 8,
                        // onPlay: (controller) => controller.repeat(),
                      )
                      .scale(
                        begin: const Offset(0.2, 0.2),
                        end: Offset(1, 1),

                        // duration: 800.ms,
                        duration: 1.seconds,
                        curve: Curves.bounceOut,
                      )
                      .shake(delay: 1.seconds, duration: 2.seconds, hz: 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
