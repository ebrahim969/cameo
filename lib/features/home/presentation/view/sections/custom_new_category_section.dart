import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tigor_store/core/utils/app_strings.dart';
import 'package:tigor_store/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:tigor_store/features/home/presentation/view/components/custom_category_list_view.dart';
import '../components/custom_categorys_header.dart';

class CustomNewCategorysSection extends StatelessWidget {
  const CustomNewCategorysSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomCategorysHeader(
          title: AppString.neww,
          subTitle: AppString.youvNeverSeenItBefore,
          trailing: AppString.viewAll,
        ),
        BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is NewProductFailure) {
              Text(state.errMessage);
            }
          },
          builder: (context, state) {
            return state is NewProductLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomCategoryListView(
                    dataList: context.read<HomeCubit>().newProducts,
                  );
          },
        )
      ],
    );
  }
}