import 'package:flash_card/screens/home/nav/widget/widgets.dart';
import 'package:flash_card/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flash_card/blocs/blocs.dart';
import 'package:flash_card/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(message: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        print(state.decks);
        return Scaffold(
          body: CustomAppBar(
            header: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        "Profile",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () =>
                            context.read<AuthBloc>().add(AuthLogoutRequest()),
                        color: Colors.white,
                        icon: Icon(Icons.exit_to_app),
                      ),
                      IconButton(
                        onPressed: () => context
                            .read<ProfileBloc>()
                            .add(ProfileLoadUser(userId: state.user.id)),
                        color: Colors.white,
                        icon: Icon(Icons.refresh),
                      )
                    ],
                  ),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ProfileAvatar(
                    radius: 50,
                    profileImageUrl: state.user.photoURL,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.user.displayName,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    state.user.email,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    minWidth: 200,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text("Edit Profile"),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      EditProfile.routeName,
                      arguments: EditProfileScreenArgs(context: context),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Recent decks",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: state.decks.length > 3 ? 3 : state.decks.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 70,
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(state.decks[index]!.title),
                        decoration: BoxDecoration(
                          color: state.decks[index]!.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> deleteConformationDialgo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Text("Delete Conformation", style: TextStyle(fontSize: 16)),
              Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.cancel_outlined, color: Colors.grey),
              )
            ],
          ),
          content: ListView(
            shrinkWrap: true,
            children: [
              Text("are you sure want to delete ?"),
              const SizedBox(height: 20),
              Text(
                "Warning: all card insid this deks will delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {},
              child: Text("Delete"),
            )
          ],
        );
      },
    );
  }
}
