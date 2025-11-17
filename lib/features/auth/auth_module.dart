import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/core/services/auth_service.dart';

// Presentation
import 'presentation/pages/auth_landing_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/signup_page.dart';
import 'presentation/pages/otp_page.dart';
import 'presentation/bloc/login_bloc.dart';
import 'presentation/bloc/signup_bloc.dart';

// Domain
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/signup.dart';
import 'domain/usecases/login_with_google.dart';
import 'domain/usecases/login_with_facebook.dart';
import 'domain/usecases/login_with_biometrics.dart';
import 'domain/usecases/signup_with_firebase_token.dart';

// Data
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';

/// AuthModule holds public auth-related routes: login, signup
class AuthModule extends Module {
  @override
  void binds(Injector i) {
    // Data source
    i.addLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(authService: Modular.get<AuthService>()),
    );

    // Repository
    i.addLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: i.get<AuthRemoteDataSource>()),
    );

    // Use case
    i.addLazySingleton<Login>(() => Login(i.get<AuthRepository>()));
    i.addLazySingleton<Signup>(() => Signup(i.get<AuthRepository>()));
    i.addLazySingleton<LoginWithGoogle>(
      () => LoginWithGoogle(i.get<AuthRepository>()),
    );
    i.addLazySingleton<LoginWithFacebook>(
      () => LoginWithFacebook(i.get<AuthRepository>()),
    );
    i.addLazySingleton<LoginWithBiometrics>(
      () => LoginWithBiometrics(i.get<AuthRepository>()),
    );

    // Bloc
    i.add<LoginBloc>(
      () => LoginBloc(
        login: i.get<Login>(),
        loginWithGoogle: i.get<LoginWithGoogle>(),
        loginWithFacebook: i.get<LoginWithFacebook>(),
        loginWithBiometrics: i.get<LoginWithBiometrics>(),
      ),
    );
    i.add<SignupBloc>(
      () => SignupBloc(
        signup: i.get<Signup>(),
        phoneAuth: Modular.get(), // PhoneAuthService
      ),
    );
    i.addLazySingleton<SignupWithFirebaseToken>(
      () => SignupWithFirebaseToken(i.get<AuthRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    // /auth -> landing with login, signup, and social options
    r.child('/', child: (_) => const AuthLandingPage());
    // /auth/login
    r.child('/login', child: (_) => const LoginPage());
    // /auth/signup
    r.child('/signup', child: (_) => const SignupPage());
    // /auth/otp
    r.child(
      '/otp',
      child: (_) {
        final data = Modular.args.data;
        // Expecting a map with all signup fields + verificationId
        if (data is Map) {
          final map = Map<String, dynamic>.from(data as Map);
          final String verificationId = map['verificationId'] as String;
          final String fullName = map['fullName'] as String;
          final String email = map['email'] as String;
          final String mobile = map['mobile'] as String;
          final String dobIso = map['dob'] as String; // ISO8601 string
          final String password = map['password'] as String;
          final dob = DateTime.parse(dobIso);
          return OtpPage(
            verificationId: verificationId,
            fullName: fullName,
            email: email,
            mobile: mobile,
            dob: dob,
            password: password,
          );
        }
        // Fallback (should not happen)
        return OtpPage(
          verificationId: '',
          fullName: '',
          email: '',
          mobile: '',
          dob: DateTime(1970),
          password: '',
        );
      },
    );
  }
}
