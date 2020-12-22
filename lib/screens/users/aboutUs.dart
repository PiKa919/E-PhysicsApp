
import 'package:ephysicsapp/globals/colors.dart';
import 'package:ephysicsapp/globals/labels.dart';
import 'package:ephysicsapp/widgets/generalWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';



class AboutUs extends StatefulWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  AboutUsState createState() => new AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
     newSlide(imgPath:"assets/sakec.jpg",discription:sakecDiscription,title: "About SAKEC"),
    );
    slides.add(
      newSlide(imgPath:"assets/rc.png",discription:rcDiscription,title: "About Research Cell"),
    );
    slides.add(
     newSlide(imgPath:"assets/rc.png",discription:teamDiscription,title: "About Team"),
    );
  }

  void onDonePress() {
    // Back to the first tab
    Navigator.of(context).pop();
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: color2,
      size: 25.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: color2,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: color2,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0,left: 20,right: 20),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 15,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: color5,
      highlightColorSkipBtn:  color5,

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn:  color5,
      highlightColorDoneBtn:  color5,

      // Dot indicator
      colorDot:  color5,
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      //shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}