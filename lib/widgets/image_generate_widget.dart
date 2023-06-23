import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/image_bloc/image_bloc.dart';
import '../constants/constants.dart';
import '../services/services.dart';

class ImageGenerateWidget extends StatefulWidget {
  const ImageGenerateWidget({super.key});

  @override
  State<ImageGenerateWidget> createState() => _ImageGenerateWidgetState();
}

class _ImageGenerateWidgetState extends State<ImageGenerateWidget> {
  List<String> sizes = ['Small', 'Medium', 'Large'];
  List<String> values = ['256x256', '512x512', '1024x1024'];
  // String? dropValue;

  late TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // isLandscape
          //     ? _formLandscape()
          //     :
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black.withOpacity(.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: "Describe your image",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withOpacity(.2),
                    width: 1,
                  ),
                ),
                child: BlocBuilder<ImageBloc, ImageState>(
                  builder: (context, state) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        icon: const Icon(
                          Icons.expand_more,
                          color: btnColor,
                        ),
                        value: imageBloc.dropValue,
                        hint: const Text('Select size'),
                        items: List.generate(
                          sizes.length,
                          (index) => DropdownMenuItem(
                            value: values[index],
                            child: Text(sizes[index]),
                          ),
                        ),
                        onChanged: (value) {
                          imageBloc.add(SetSizeValue(value.toString()));
                          // setState(() {
                          //   dropValue = value.toString();
                          //   print(dropValue);
                          // });
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          SizedBox(
            width: 300,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                if (textController.text.isNotEmpty &&
                    imageBloc.dropValue!.isNotEmpty) {
                  imageBloc.add(
                    ImageGenerate(
                      text: textController.text,
                      size: imageBloc.dropValue!,
                    ),
                  );
                } else {
                  Services.errorSnackBar(
                    context: context,
                    errorMessage: 'Please pass the description and size.',
                  );
                }
              },
              child: const Text('Generate'),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _formLandscape() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         height: 46,
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: 10,
  //           vertical: 2,
  //         ),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(
  //             color: Colors.black.withOpacity(.2),
  //             width: 1,
  //           ),
  //         ),
  //         child: TextFormField(
  //           controller: textController,
  //           decoration: const InputDecoration(
  //             hintText: "Describe your image",
  //             border: InputBorder.none,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //       Container(
  //         height: 46,
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: 10,
  //           vertical: 2,
  //         ),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(
  //             color: Colors.black.withOpacity(.2),
  //             width: 1,
  //           ),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton(
  //             borderRadius: const BorderRadius.all(
  //               Radius.circular(20.0),
  //             ),
  //             icon: const Icon(
  //               Icons.expand_more,
  //               color: btnColor,
  //             ),
  //             value: dropValue,
  //             hint: const Text('Select size'),
  //             items: List.generate(
  //               sizes.length,
  //               (index) => DropdownMenuItem(
  //                 value: values[index],
  //                 child: Text(sizes[index]),
  //               ),
  //             ),
  //             onChanged: (value) {
  //               setState(() {
  //                 dropValue = value.toString();
  //               });
  //             },
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
