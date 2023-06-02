import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/bots_bloc/bots_bloc.dart';
import 'bot_widget.dart';

class BotList extends StatelessWidget {
  const BotList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotsBloc, BotsState>(
      builder: (context, state) {
        if (state is BotsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is BotsLoaded) {
          return Row(
            children: [
              Flexible(
                child: GridView.builder(
                  itemCount: state.bots.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 5 / 3,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => BotWidget(
                    bot: state.bots[index],
                  ),
                ),
              ),
            ],
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
    );
  }
}
