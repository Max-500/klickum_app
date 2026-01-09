import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klicum/config/style/app_style.dart';
import 'package:klicum/presentation/providers/address_provider.dart';
import '../widgets.dart';

class CountriesSheet extends ConsumerWidget {
  const CountriesSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppStyle.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18))
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                InputField(
                  autoValidateMode: false,
                  labelText: 'Buscar país',
                  onChanged: (value) => ref.read(countriesProvider.notifier).setSearchQuery(value)
                ),

                const SizedBox(height: 20),
                  
                Expanded(
                  child: countriesAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => NoData(),
                    data: (list) => ListView.separated(
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemCount: list.length,
                      itemBuilder: (context, index) => InputTile(
                        title: list[index].name,
                        trailing: Icon(Icons.chevron_right,  color: Colors.white.withValues(alpha: 0.7)),
                        focusedBorderColor: AppStyle.primaryColor,
                        onTap: () => context.pop('${list[index].id}|${list[index].name}')
                      )
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}