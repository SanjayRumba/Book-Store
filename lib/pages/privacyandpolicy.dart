import 'package:flutter/material.dart';
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,


        title:  Text("PRIVACY POLICY", style: TextStyle(
                                          fontSize: 20,  fontWeight: FontWeight.w600, color: Color.fromARGB(255, 7, 77, 134),),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:20, right: 20, bottom: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
                                          Text("Book Store Service is the quickest and easiest way to order books from home.",
                                          textAlign: TextAlign.justify, style: TextStyle(
                                            fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.8, height: 1.8),),
                                         const   SizedBox(height: 15,),
      
                                              Text("AGREEMENT TO TERMS", style:TextStyle(
                                          fontSize: 20,  fontWeight: FontWeight.w600, color: Color.fromARGB(255, 7, 77, 134),letterSpacing: 0.8),),
                                          Text("Supplemental terms and conditions or documents that may be posted on the Site from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms of Use at any time and for any reason.  and you waive any right to receive specific notice of each such partnership, employment or agency relationship created between you and us as a result of these Terms of Use or use of the Site. You agree that these Terms of Use will not be construed against us by virtue of having drafted them. You hereby waive any and all defenses you may have based on the electronic form of these Terms of Use and the lack of signing by the parties hereto to execute these Terms of Use.",
                                           style: TextStyle(
                                            fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.8, height: 1.8),),
                                         const   SizedBox(height: 15,),
                                         Text("USER REGSITRATION", style: TextStyle(
                                          fontSize: 20,  fontWeight: FontWeight.w600, color: Color.fromARGB(255, 7, 77, 134),letterSpacing: 0.8),),
                                          Text("You may not be required to register with the Site."
                                          , textAlign: TextAlign.justify, style: TextStyle(
                                            fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.8, height: 1.8),),
                                         const   SizedBox(height: 15,),
      
      
      
            ],
          ),
        ),
      ),
    );
  }
}