import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/bots_bloc/bots_bloc.dart';
import './bot_widget.dart';

class BotList extends StatelessWidget {
  const BotList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotsBloc, BotsState>(
      builder: (context, state) {
        if (state is BotsLoading) {
          SizedBox(
            height: 200,
            child: Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor.withOpacity(.8),
                size: 50,
              ),
            ),
          );
        }
        if (state is BotsLoaded) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                // color: scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                childAspectRatio: 9 / 7,
                physics: const NeverScrollableScrollPhysics(),
                children: state.bots.map((bot) => BotWidget(bot: bot)).toList(),
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
    );
  }
}
