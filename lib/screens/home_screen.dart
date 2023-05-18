import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocks/bots_bloc/bots_bloc.dart';
import '../providers/bots_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/bot_widget.dart';
import '../widgets/text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final botsProvider = Provider.of<BotsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Home'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Choose bot to have conversation with',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<BotsBloc, BotsState>(
                builder: (context, state) {
                  if (state is BotsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is BotsLoaded) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: state.bots.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 5 / 3,
                        ),
                        // shrinkWrap: true,
                        itemBuilder: (context, index) => BotWidget(
                          bot: state.bots[index],
                        ),
                      ),
                    );
                  }
                  if (state is BotsError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
