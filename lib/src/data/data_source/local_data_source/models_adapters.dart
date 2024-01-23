import 'package:hive_flutter/hive_flutter.dart';

import '../../models/load.dart';
import '../../models/user.dart';
///
class UserAdapter extends TypeAdapter<MyUser> {
  @override
  int get typeId => 0;

  @override
  MyUser read(BinaryReader reader) {
    final String uid = reader.read();
    final String username = reader.read();
    final String email = reader.read();
    final String birdhdate = reader.read();
    final String tel = reader.read();
    final String image = reader.read();
    final List<dynamic> favoriteLoads = reader.read();

    return MyUser(
        uid: uid,
        username: username,
        email: email,
        birdhdate: birdhdate,
        tel: tel,
        favoriteLoads: favoriteLoads,
        image: image);
  }

  @override
  void write(BinaryWriter writer, MyUser obj) {
    writer.write(obj.uid);
    writer.write(obj.username);
    writer.write(obj.birdhdate);
    writer.write(obj.email);
    writer.write(obj.tel);
    writer.write(obj.image);
    writer.write(obj.favoriteLoads);
  }
}

class LoadAdapter extends TypeAdapter<Load> {
  @override
  int get typeId => 0;

  @override
  Load read(BinaryReader reader) {
    final String brokerUid = reader.read();
    final String brokerName = reader.read();
    final String loadRef = reader.read();
    final String loadDate = reader.read();
    final String pickUpDate = reader.read();
    final String brokerPhone = reader.read();
    final String dropDownDate = reader.read();
    final String truckType = reader.read();
    final String description = reader.read();
    final String origin = reader.read();
    final String desitnation = reader.read();
    final double originLat = reader.read();
    final double originLng = reader.read();
    final double destinationLat = reader.read();
    final double destinationLng = reader.read();
    final int weigth = reader.read();
    final int price = reader.read();

    return Load(
        brokerUid: brokerUid,
        loadRef: loadRef,
        brokerName: brokerName,
        brokerPhone: brokerPhone,
        loadDate: loadDate,
        pickUpDate: pickUpDate,
        dropDownDate: dropDownDate,
        truckType: truckType,
        price: price,
        weigth: weigth,
        description: description,
        origin: origin,
        desitnation: desitnation,
        originLat: originLat,
        originLng: originLng,
        destinationLat: destinationLat,
        destinationLng: destinationLng);
  }

  @override
  void write(BinaryWriter writer, Load obj) {
    writer.write(obj.brokerUid);
    writer.write(obj.loadRef);
    writer.write(obj.brokerName);
    writer.write(obj.brokerPhone);
    writer.write(obj.loadDate);
    writer.write(obj.pickUpDate);
    writer.write(obj.dropDownDate);
    writer.write(obj.truckType);
    writer.write(obj.price);
    writer.write(obj.weigth);
    writer.write(obj.description);
    writer.write(obj.origin);
    writer.write(obj.desitnation);
    writer.write(obj.originLat);
    writer.write(obj.originLng);
    writer.write(obj.destinationLat);
    writer.write(obj.destinationLng);
  }
}
