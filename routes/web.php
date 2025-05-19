<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

Route::get('/', function () {
    return view('home');
});
// Route::get('/', function () {
//     return view('home');
// });

Route::get('/portfolio/{firstname}/{lastname}', function($firstname, $lastname){
    return $firstname ."  ". $lastname;

});

Route::get('/About', function(){
    return view('about');
}
);
Route::get('/registration', function(){
    return view('members.registration');
}
);
Route::get('/login', function(){
    return view('members.login');
}
);

Route::post ("/formsubmitted", function (Request $request) {

    $request -> validate([
       'fullname' => 'required|min:3|max:30',
       'email' => 'required|email'
    ]);
    $fullname = $request->input("fullname");
    $email = $request -> input("email");

    // return "your full name is $fullname and Your email is $email";
    return view('about',
[
    'fullname' => $fullname,
    'email' =>$email,
]);

}) -> name('formsubmitted');


