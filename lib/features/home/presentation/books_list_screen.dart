import 'package:absar/features/home/cubit/home_cubit.dart';
import 'package:absar/features/home/cubit/home_staets.dart';
import 'package:absar/features/home/presentation/audio_book_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Books extends StatelessWidget {
  const Books({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeInitialState) {
          return const Center(
            child: Text('initial'),
          );
        } else if (state is HomeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeSuccessState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: context.read<HomeCubit>().books!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<HomeCubit>(),
                          child: BookAudio(
                            index: index,
                            snapshot: context.read<HomeCubit>().books![index],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              context.read<HomeCubit>().books![index]['book_name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                context.read<HomeCubit>().books![index]['book_image'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is HomeErrorState) {
          return const Center(
            child: Text('error'),
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}