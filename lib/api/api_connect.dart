class API{
  static const HOST_PATH = "https://hayat778801.000webhostapp.com/clothes/backend";
  static const USER_ENDPOINT ="$HOST_PATH/user";
  static const ADMIN_ENDPOINT ="$HOST_PATH/admin";
  static const ITEMS_ENDPOINT ="$HOST_PATH/items";
  static const CLOTHES_ENDPOINT ="$HOST_PATH/clothes";
  static const CART_ENDPOINT ="$HOST_PATH/cart";
  static const FAV_ENDPOINT ="$HOST_PATH/favourite";
  //sign up users
  static const signUp = "$USER_ENDPOINT/signup.php";
  static const validate_email = "$USER_ENDPOINT/validate_email.php";
  static const login = "$USER_ENDPOINT/login.php";
  //sign in admin
  static const adminLogin = "$ADMIN_ENDPOINT/login.php";
  //upload items
  static const uploadItems = "$ITEMS_ENDPOINT/upload.php";
  static const searchItems = "$ITEMS_ENDPOINT/search.php";

  //Clothers
  static const getRatedClothes = "$CLOTHES_ENDPOINT/trending.php";
  static const getAllClothes = "$CLOTHES_ENDPOINT/all.php";

  //cart endpoint
  static const addToCard = "$CART_ENDPOINT/add.php";
  static const getCartList = "$CART_ENDPOINT/read.php";
  static const deleteItemFormCartList = "$CART_ENDPOINT/delete.php";
  static const  updateItemInCartList = "$CART_ENDPOINT/update.php";

  //favourite
  static const  addFavourite = "$FAV_ENDPOINT/add.php";
  static const  readFavourite = "$FAV_ENDPOINT/read.php";
  static const  deleteFavourite = "$FAV_ENDPOINT/delete.php";
  static const  validateFavourite = "$FAV_ENDPOINT/validate_favourite.php";
  // ignore: constant_identifier_names
  static const  path_images = "$ITEMS_ENDPOINT/image/dd/";



}