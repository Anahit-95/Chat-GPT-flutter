import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/models_bloc/models_bloc.dart';
import '../widgets/text_widget.dart';

import '../constants/constants.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  bool isFirstLoading = true;

  @override
  void initState() {
    context.read<ModelsBloc>().add(FetchModels());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modelsBloc = BlocProvider.of<ModelsBloc>(context, listen: false);
    return BlocBuilder<ModelsBloc, ModelsState>(
      builder: (context, state) {
        if (state is ModelsLoading) {
          isFirstLoading = false;
          return FittedBox(
            child: SpinKitFadingCircle(
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          );
        }
        if (state is ModelsError) {
          return TextWidget(
            label: state.message,
            color: CupertinoColors.systemRed,
          );
        }
        if (state is ModelsLoaded) {
          final modelsList = modelsBloc.modelsList;
          if (modelsList.isEmpty) {
            return const SizedBox.shrink();
          }
          return FittedBox(
            child: DropdownButton(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              iconEnabledColor: Theme.of(context).primaryColor,
              items: List<DropdownMenuItem<String>>.generate(
                modelsList.length,
                (index) => DropdownMenuItem(
                  value: modelsList[index].id,
                  child: TextWidget(
                    label: modelsList[index].id,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              value: modelsBloc.currentModel,
              onChanged: (value) async {
                modelsBloc.add(SetCurrentModel(value.toString()));
                await Future.delayed(
                  const Duration(seconds: 1),
                  () => Navigator.pop(context),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
  //   currentModel = modelsProvider.getCurrentModel;
  //   return FutureBuilder<List<ModelsModel>>(
  //     future: modelsProvider.getAllModels(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting &&
  //           isFirstLoading == true) {
  //         isFirstLoading = false;
  //         return const FittedBox(
  //           child: SpinKitFadingCircle(
  //             color: Colors.lightBlue,
  //             size: 30,
  //           ),
  //         );
  //       }
  //       if (snapshot.hasError) {
  //         return Center(
  //           child: TextWidget(
  //             label: snapshot.error.toString(),
  //           ),
  //         );
  //       }
  //       return snapshot.data == null || snapshot.data!.isEmpty
  //           ? SizedBox.shrink()
  //           : FittedBox(
  //               child: DropdownButton(
  //                 dropdownColor: scaffoldBackgroundColor,
  //                 iconEnabledColor: Colors.white,
  //                 items: List<DropdownMenuItem<String>>.generate(
  //                   snapshot.data!.length,
  //                   (index) => DropdownMenuItem(
  //                     value: snapshot.data![index].id,
  //                     child: TextWidget(
  //                       label: snapshot.data![index].id,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                 ),
  //                 value: currentModel,
  //                 onChanged: (value) async {
  //                   setState(() {
  //                     currentModel = value.toString();
  //                   });
  //                   modelsProvider.setCurrentModel(value.toString());
  //                   await Future.delayed(const Duration(seconds: 1));
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             );
  //     },
  //   );
  // }
}
