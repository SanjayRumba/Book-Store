import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/apiservices/apievent.dart';
import 'package:book_shop/apiservices/apistate.dart';
import 'package:book_shop/model/AdminProfileData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ApiBloc>(context).add(AdminProfileEvents());
    return Scaffold(
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is LoadedState) {
            // If data is available, display the UI with the fetched data
            return Stack(
              children: [
                _buildBackgroundImage(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Admin Profile",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      _buildUserProfiles(state.adminProfileList!, context),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is LoadingState) {
            // If data is still loading, display a loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // If there's an error or no data, display a message
            return Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return AnimatedBuilder(
      animation: const AlwaysStoppedAnimation(0.5),
      builder: (context, child) {
        final double translate = 100 * 0.5;
        return Transform.translate(
          offset: Offset(0, translate),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserProfiles(List<AdminProfileData> userList, context) {
    if (userList == null || userList.isEmpty) {
      // If there's no data, you can show a message or loading indicator here
      return Center(
        child: Text("No data available"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  userList[index].image!= null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        userList[index].image!,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                        "assets/images/profile.png",
                                      ),
                                    ),
                  const SizedBox(height: 16),
                  Text(
                    userList[index].fullname ?? "Name",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userList[index].email ?? "Email",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileInfoRow(
                    icon: Icons.location_on,
                    label: "Address",
                    info: userList[index].address ?? "N/A",
                  ),
                  const SizedBox(height: 8),
                  _buildProfileInfoRow(
                    icon: Icons.phone,
                    label: "Phone",
                    info: userList[index].phone.toString() ?? "N/A",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfoRow({
    required IconData icon,
    required String label,
    required String info,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                info,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

