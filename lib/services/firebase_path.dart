//db paths
class FirestorePath {
  //all users
  static String userscollection() => 'users';
  //one user-> uid auth.
  static String user(String userid) => 'users/$userid';
  //all retail stores
  static String retailstores()=> 'retail_stores';
//one retail store
  static String blueads(String id)=> 'retail_stores/$id/blueads';
//one bluead
static String bluead (String id, String blueid) => 'retail_stores/$id/blueads/$blueid';
//bluead1ststore
static String onebluead(String blueid)=> '/retail_stores/rwOEANtIjZVD0FRjnE6o/$blueid';
//allblueads1stretail
static String blueadscollection() => '/retail_stores/rwOEANtIjZVD0FRjnE6o/blueads/';
}

//storage paths
class StoragePath {
  //profileimg
static String profileimg(String userid) => 'users/profile_img/$userid';
static String beaconimg(String zona) => 'retail_stores/ads_img/$zona';
}