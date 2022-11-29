import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/gps/gps_bloc.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          
          //print( state.toString() );

          return !state.isGpsEnabled 
          ? const _EnableGpsMessage()
          : const _AcessButton();
          
        },
      ),
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Debe habilitar el GPS',
        style: TextStyle( fontSize:  25, fontWeight: FontWeight.w300 ),
      ),
    );
  }
}

class _AcessButton extends StatelessWidget {
  const _AcessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Es necesario el acceso al GPS'),
          MaterialButton(
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            child: const Text('Solicitar Accesso', style: TextStyle( color: Colors.white ),),
            onPressed: ()async{
              
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              await gpsBloc.askGpsAccess();

            }
          )
        ],
      ),
    );
  }
}