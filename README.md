# Internship Project & Crossfire Lab Inc

Geliştirdiğim uygulamada Ekşi Sözlük tarzı bir blog uygulaması yapılması amaçlanmıştır

<h1>Tech Stack</h1>
Mobile App Development - Flutter <br/> 
Backend - NodeJS & ExpressJS <br/>
Database : MongoDB <br/>
Cloud : Azure <br/>

<br/>
<img src='https://github.com/Ozgur-Ulusoy/WorldFlow/assets/88507880/623b83c3-7fde-444e-93e5-21e4f8477991' width='500'>
<img src='https://github.com/Ozgur-Ulusoy/WorldFlow/assets/88507880/2df1fff6-7204-4723-9614-5324134dc1d8' width='500'>
<img src='https://github.com/Ozgur-Ulusoy/WorldFlow/assets/88507880/0e2af2f3-be67-4a09-8a11-c73950f2818c' width='500'>
<img src='https://github.com/Ozgur-Ulusoy/WorldFlow/assets/88507880/0ebe594c-5bf6-4e34-afb7-d7eefb95b40c' width='500'>
<br/>

# Kurulum
Backend
npm i
npm start

Frontend
flutter clean
flutter pub get
flutter run

<br/>

# Api Dokümantasyon

base url = https://worldflow.azurewebsites.net/api/

<h3>  Auth İşlemleri - auth/ </h3>
/login post işlemi => verilen req.headers.username,req.headers.email, req.headers.password ile kullanıcı girişini sağlar eğer böyle bir hesap yoksa yeni bir hesap açar
/logout post işlemi => verilen req.headers.token ile giriş yapmış olan kullanıcının oturumunu keser
/checkSession get işlemi => verilen req.headers.token'a bakarak kullanıcının oturumu sona ermiş mi yoksa devam ediyor mu diye kontrol eder
/sendVerifyEmail post işlemi => verilen req.headers.email, req.headers.username ile ilgili kullanıcıya emailini doğrulama maili atar
/verifyEmail/:token get işlemi => verilen req.params.token ile bu tokene ait kullanıcının emailini doğrular
/sendResetPasswordEmail post işlemi => verilen req.headers.email, req.headers.password ile şifre değiştirme emaili gönderir
/resetPassword/:token get işlemi => verilen req.params.token ait kullanıcının şifresini değiştirme isteğini kabul eder
<br/>

<h3> Comment İşlemleri - comment/ </h3>
/create post işlemi => verilen req.headers.postid, req.body.content, req.headers.ownerid, req.headers.token ile ilgili posta yorum oluşturur
/getComment get işlemi => verilen req.headers.postid, req.headers.limit ile istenilen posta ait istenilen limitte yorumları verir
/interact post işlemi => verilen req.headers.postid, req.headers.commentid, req.headers.userid, req.headers.type,  req.headers.token ile istenilen yoruma like veya dislike atılır
<br/>

<h3> Post İşlemleri - post/ </h3>
/create post işlemi => verilen req.body.title, req.body.content, req.headers.ownerid, req.headers.token ile post yaratır
/getPostById get işlemi => verilen req.headers.postid ile postid'ye göre postu getirir
/getPostCount get işlemi => toplam post sayısını verir
/getPostsByPage get işlemi => req.headers.page, req.headers.limit ile sayfalama işlemi yapar ( verilen page sayısı kadar atlar ve limite göre postları verir )
/getRandomPostByCount get işlemi => verilen req.headers.count ile rastgele count kadar post verir
/getPostsByTitle get işlemi => verilen req.body.title, req.headers.limit ile başlığa göre postları getirir
/interaction post işlemi => verilen req.headers.postid, req.headers.ownerid, req.headers.type, req.headers.token ile posta like veya dislike atar


