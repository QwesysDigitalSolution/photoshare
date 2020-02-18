import 'package:flutter/material.dart';
import 'package:photoshare/common/ClassList.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final CartData cartData;

  StateContainer({@required this.child,this.cartData});

  static StateContainerState of(BuildContext context){
    return(context.inheritFromWidgetOfExactType(InheritedContainer) as InheritedContainer).data;
  }

  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  CartData cartData;

  void updateCartData({cartCount}){
    if(cartData==null){
      cartData=new CartData(CartCount: cartCount);
      setState(() {
        cartData=cartData;
      });
    }
    else{
      setState(() {
        cartData.CartCount=cartCount ?? cartData.CartCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedContainer(
      data:this,
      child: widget.child,
    );
  }
}

class InheritedContainer extends InheritedWidget {
  final StateContainerState data;

  InheritedContainer({Key key,@required this.data, @required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify( InheritedContainer oldWidget) {
    return true;
  }
}