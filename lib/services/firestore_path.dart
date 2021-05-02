//db paths
class FirestorePath {
  /*static String restaurantUserRating(String restaurantId, String uid) =>
      'restaurants/$restaurantId/ratings/$uid';*/
  //all users
  static String userscollection() => 'users';
  //one user-> uid auth.
  static String user(String userid) => 'users/$userid';
  //all beacons
  static String beaconscollection() => 'beacons';
//one beacon-> uid
  static String beacon(String beaconid) => 'beacons/$beaconid';
  //TODO all retail stores

//TODO one retail store

}

//storage paths
class StoragePath {
  //profileimg
static String profileimg(String userid) => 'users/profile_img/$userid';
}