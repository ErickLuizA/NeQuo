import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/presentation/details/bloc/delete_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/delete_state.dart';
import 'package:NeQuo/presentation/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionsMenu extends StatelessWidget {
  final Function getQuotesList;
  final Function handleDeleteQuoteList;

  const OptionsMenu({
    Key key,
    @required this.getQuotesList,
    @required this.handleDeleteQuoteList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteBloc, DeleteState>(
      key: Key("options_menu_bloc_builder"),
      builder: (_, state) {
        if (state is DeleteListLoadingState) {
          return LoadingWidget(
            key: Key("delete_list_loading"),
          );
        } else if (state is DeleteListErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                key: Key("delete_list_snackbar"),
                content: Text(AppLocalizations.of(context)
                    .translate("del_quote_list_error")),
              ),
            );
          });
          return PopupMenuButton<String>(
            key: Key("delete_popup_menu_button"),
            onSelected: (val) {
              if (val == AppLocalizations.of(context).translate("del_list")) {
                handleDeleteQuoteList();
              }
            },
            itemBuilder: (BuildContext context) {
              return {AppLocalizations.of(context).translate("del_list")}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          );
        } else if (state is DeleteListSuccessState) {
          getQuotesList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });

          return Container();
        } else {
          return PopupMenuButton(
            key: Key("popup_menu_button"),
            onSelected: (val) {
              if (val == AppLocalizations.of(context).translate("del_list")) {
                handleDeleteQuoteList();
              }
            },
            itemBuilder: (BuildContext context) {
              return {AppLocalizations.of(context).translate("del_list")}
                  .map((String choice) {
                return PopupMenuItem<dynamic>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          );
        }
      },
    );
  }
}
