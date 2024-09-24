import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/sell/sell_bloc.dart';
import 'package:frontend_chat/models/sell_model.dart';
import 'package:frontend_chat/utils/component/bottombar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  // final SellBloc _sellBloc = SellBloc();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SellBloc>().add(SellSearchEvent(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController sellDescriptionController =
                    TextEditingController();
                TextEditingController nameController = TextEditingController();
                TextEditingController priceController = TextEditingController();
                List<XFile>? imageFiles;
                List<String>? _imageFilespath;
                Future<void> _pickImages() async {
                  final ImagePicker _picker = ImagePicker();
                  // final ImagePickerPlugin pickerPlugin = ImagePickerPlugin();
                  if (kIsWeb) {
                    // Web image picker
                    imageFiles = await _picker.pickMultiImage();
                  } else {
                    // Mobile image picker
                    imageFiles = await _picker.pickMultiImage();
                  }
                  if (imageFiles != null) {
                    _imageFilespath = imageFiles!.map((e) => e.path).toList();
                  }
                  print('Image path: $_imageFilespath');
                }

                return AlertDialog(
                    title: const Text('Create Sell item'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                hintText: 'Enter Name of Product'),
                          ),
                          TextField(
                            controller: sellDescriptionController,
                            decoration: const InputDecoration(
                                hintText: 'Sell Item Description'),
                          ),
                          TextField(
                            controller: priceController,
                            decoration: const InputDecoration(
                                hintText: 'Sell Item Price'),
                          ),

                          //pick image check platfor specific image_picker_for_web web and image_picker_for for mobile
                          ElevatedButton(
                            onPressed: _pickImages,
                            child: const Text('Pick Images'),
                          ),
                          if (imageFiles != null)
                            Wrap(
                              children: imageFiles!.map((file) {
                                return Image.network(file.path,
                                    width: 100, height: 100);
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                          onPressed: () {
                            // Create Sell API call
                            if (_imageFilespath != null) {
                              context.read<SellBloc>().add(SellCreateEvent(
                                  nameController.text,
                                  sellDescriptionController.text,
                                  priceController.text,
                                  _imageFilespath!));
                            } else {
                              //show error

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text('Error'),
                                        content: const SingleChildScrollView(
                                            child: ListBody(children: <Widget>[
                                          Text('Please select image'),
                                        ])),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK')),
                                        ]);
                                  });
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Create'))
                    ]);
              });
        },
        child: const Icon(Icons.add),
      ),
      bottomSheet: BottomBar(currentIndex: 2),
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            context.read<SellBloc>().add(SellSearchEvent(value));
          },
        ),
      ),
      body: BlocBuilder<SellBloc, SellState>(
        builder: (context, state) {
          if (state is SellError) {
            return Center(child: Text(state.message));
          } else if (state is SellLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SellLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSellList(state.sell),
            );
          } else {
            return Center(
                child: Text('Unknown Error State = ${state.toString()}'));
          }
        },
      ),
    );
  }

  Widget _buildSellList(AllSellModel sell) {
    return ListView.builder(
        itemCount: sell.data.length, // Assuming only one item for simplicity
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sell.data[index].name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildImageGallery(sell.data[index].images),
                        const SizedBox(height: 10),
                        Text('Description: ${sell.data[index].description}'),
                        const SizedBox(height: 10),
                        Text('Price: \$${sell.data[index].price}'),
                        const SizedBox(height: 10),
                        Text('Owner: ${sell.data[index].owner.username}'),
                        const SizedBox(height: 10)
                      ])));
        });
  }

  Widget _buildImageGallery(List<String> images) {
    return SizedBox(
        height: 200,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(images[index]));
            }));
  }
}
