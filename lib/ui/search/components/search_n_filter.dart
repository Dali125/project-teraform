import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/search/components/custom_search_bar.dart';
import 'package:projectTeraform/ui/search/components/expanded_search.dart';

class SearchAndFilter extends StatefulWidget {
  const SearchAndFilter({super.key});

  @override
  State<SearchAndFilter> createState() => _SearchAndFilterState();
}

class _SearchAndFilterState extends State<SearchAndFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            OpenContainer(closedBuilder: (context, VoidCallback _){
              return const CustomSearchBar();
            }, openBuilder: (context, _){
              return const ExpandedSearch();

            }),

            Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: IconButton(onPressed: (){

                  showModalBottomSheet(
                    constraints: const BoxConstraints(
                      minHeight: 200,
                      minWidth: 1
                    ),

                      context: context, builder: (context){


                        double val = 0.1;
                    return Container(

                      child: Column(
                        children: [

                          Slider(value: val, onChanged: (value){
                            setState(() {
                              val = value;
                              log('$value');
                            });
                          })

                        ],
                      ),

                    );




                  });
                }, icon: const Icon(Icons.filter_list)))
          ],
        ),
        const SizedBox(
          height: 20,
        ),


      ],
    );
  }
}
