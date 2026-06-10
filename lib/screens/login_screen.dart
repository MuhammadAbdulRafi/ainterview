import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
// Inline lightweight signup page used only for navigation from login.
// A separate full `SignupScreen` file also exists; this inline widget
// avoids potential circular import issues when navigating.

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Center(
                child: Text(
                  'Log in',
                  style: AppTextStyles.h1,
                ),
              ),
              const SizedBox(height: 32),

              // Email / Name field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Full Name or email',
                  filled: true,
                  fillColor: AppColors.light,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColors.main),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Ex: Nicholas Abel or nicholasabel@gmail.com', style: AppTextStyles.caption),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: AppColors.light,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColors.main),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('*enter your password', style: AppTextStyles.caption),
              const SizedBox(height: 20),

                SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // UI only: tidak ada autentikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login pressed (UI only)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                  child: Text('Log in', style: AppTextStyles.button),
                ),
              ),

              const SizedBox(height: 18),

              // Link to Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? ', style: AppTextStyles.caption),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const _SignupInline()),
                      );
                    },
                    child: const Text('Sign up'),
                  )
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupInline extends StatelessWidget {
  const _SignupInline({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textMain,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.pLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(child: Text('Sign up', style: AppTextStyles.h1)),
              const SizedBox(height: 18),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  filled: true,
                  fillColor: AppColors.light,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.pMedium,
                    vertical: AppSizes.pLarge / 1.5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Ex: Nicholas Abel', style: AppTextStyles.caption),
              const SizedBox(height: 12),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: AppColors.light,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.pMedium,
                    vertical: AppSizes.pLarge / 1.5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Ex: nicholasabel@gmail.com', style: AppTextStyles.caption),
              const SizedBox(height: 12),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: AppColors.light,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.pMedium,
                    vertical: AppSizes.pLarge / 1.5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text('*minimum 6 digit', style: AppTextStyles.caption),
              const SizedBox(height: 12),

              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  filled: true,
                  fillColor: AppColors.light,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.pMedium,
                    vertical: AppSizes.pLarge / 1.5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('*enter password', style: AppTextStyles.caption),
              const SizedBox(height: 18),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign up pressed (UI only)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                  child: Text('Sign up', style: AppTextStyles.button),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: AppTextStyles.caption),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Log in'),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

