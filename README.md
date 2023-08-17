# Internship Project & Crossfire Lab Inc

Geliştirdiğim uygulamada Ekşi Sözlük tarzı bir blog uygulaması yapılması amaçlanmıştır

<h1>Tech Stack</h1>
Mobile App Development - Flutter <br/> 
Backend - NodeJS & ExpressJS <br/>
Database : MongoDB <br/>

Kurulum Backend
npm i
npm start

Kurulum Frontend
flutter clean
flutter pub get
flutter run

base url = https://worldflow.azurewebsites.net/api/

Auth İşlemleri - auth/
/login post işlemi => verilen req.headers.username,req.headers.email, req.headers.password ile kullanıcı girişini sağlar eğer böyle bir hesap yoksa yeni bir hesap açar
/logout post işlemi => verilen req.headers.token ile giriş yapmış olan kullanıcının oturumunu keser
/checkSession get işlemi => verilen req.headers.token'a bakarak kullanıcının oturumu sona ermiş mi yoksa devam ediyor mu diye kontrol eder
/sendVerifyEmail post işlemi => verilen req.headers.email, req.headers.username ile ilgili kullanıcıya emailini doğrulama maili atar
/verifyEmail/:token get işlemi => verilen req.params.token ile bu tokene ait kullanıcının emailini doğrular
/sendResetPasswordEmail post işlemi => verilen req.headers.email, req.headers.password ile şifre değiştirme emaili gönderir
/resetPassword/:token get işlemi => verilen req.params.token ait kullanıcının şifresini değiştirme isteğini kabul eder

Comment İşlemleri - comment/
/create post işlemi => verilen req.headers.postid, req.body.content, req.headers.ownerid, req.headers.token ile ilgili posta yorum oluşturur
/getComment get işlemi => verilen req.headers.postid, req.headers.limit ile istenilen posta ait istenilen limitte yorumları verir
/interact post işlemi => verilen req.headers.postid, req.headers.commentid, req.headers.userid, req.headers.type,  req.headers.token ile istenilen yoruma like veya dislike atılır

Post İşlemleri - post/
/create post işlemi => verilen req.body.title, req.body.content, req.headers.ownerid, req.headers.token ile post yaratır
/getPostById get işlemi => verilen req.headers.postid ile postid'ye göre postu getirir
/getPostCount get işlemi => toplam post sayısını verir
/getPostsByPage get işlemi => req.headers.page, req.headers.limit ile sayfalama işlemi yapar ( verilen page sayısı kadar atlar ve limite göre postları verir )
/getRandomPostByCount get işlemi => verilen req.headers.count ile rastgele count kadar post verir
/getPostsByTitle get işlemi => verilen req.body.title, req.headers.limit ile başlığa göre postları getirir
/interaction post işlemi => verilen req.headers.postid, req.headers.ownerid, req.headers.type, req.headers.token ile posta like veya dislike atar

