import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';

class WifiNotConnectedPage extends StatelessWidget {
  const WifiNotConnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
          // Lottie.asset('assets/Lottie/Animation - 1747338928366.json',
          //     height: 300, width: 300),
          Image.asset('assets/Lottie/images/5406715.jpg',
              width: 400, height: 400),
          const SizedBox(height: 10),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please check your network and try again.'),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () => homeCubit.retry(),
              child: const Text(
                'Try Again',
                style: TextStyle(color: AppColors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 50),
                backgroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              )),
          Spacer()
        ],
      ),
    );
  }
}
