import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.pLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Center(child: Text('Sign up', style: AppTextStyles.h1)),
              const SizedBox(height: 28),

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

