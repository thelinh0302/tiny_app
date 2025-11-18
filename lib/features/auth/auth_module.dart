import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/core/services/auth_service.dart';

// Presentation
import 'presentation/pages/auth_landing_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/signup_page.dart';
import 'presentation/pages/otp_page.dart';
import 'presentation/pages/reset_password_request_page.dart';
import 'presentation/pages/reset_password_verify_page.dart';
import 'presentation/pages/reset_password_new_password_page.dart';
import 'presentation/bloc/login_bloc.dart';
import 'presentation/bloc/signup_bloc.dart';
import 'presentation/bloc/otp_bloc.dart';
import 'presentation/bloc/reset_password_request_bloc.dart';
import 'presentation/bloc/reset_password_verify_bloc.dart';
import 'presentation/bloc/reset_password_new_password_bloc.dart';

// Domain
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/signup.dart';
import 'domain/usecases/login_with_google.dart';
import 'domain/usecases/login_with_facebook.dart';
import 'domain/usecases/login_with_biometrics.dart';
import 'domain/usecases/signup_with_firebase_token.dart';
import 'domain/usecases/check_user_exists.dart';
import 'domain/usecases/reset_password_with_phone.dart';

// Data
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';

/// AuthModule holds public auth-related routes: login, signup, reset password
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

    // Use cases
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
    i.addLazySingleton<CheckUserExists>(
      () => CheckUserExists(i.get<AuthRepository>()),
    );
    i.addLazySingleton<ResetPasswordWithPhone>(
      () => ResetPasswordWithPhone(i.get<AuthRepository>()),
    );

    // Blocs
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
        checkUserExists: i.get<CheckUserExists>(),
      ),
    );

    i.addLazySingleton<SignupWithFirebaseToken>(
      () => SignupWithFirebaseToken(i.get<AuthRepository>()),
    );
    i.add<OtpBloc>(
      () => OtpBloc(
        phoneAuth: Modular.get(), // PhoneAuthService
        signupWithFirebaseToken: i.get<SignupWithFirebaseToken>(),
      ),
    );

    i.add<ResetPasswordRequestBloc>(
      () => ResetPasswordRequestBloc(
        phoneAuth: Modular.get(),
        checkUserExists: i.get<CheckUserExists>(),
      ),
    );
    i.add<ResetPasswordVerifyBloc>(
      () => ResetPasswordVerifyBloc(phoneAuth: Modular.get()),
    );
    i.add<ResetPasswordNewPasswordBloc>(
      () => ResetPasswordNewPasswordBloc(
        resetPasswordWithPhone: i.get<ResetPasswordWithPhone>(),
      ),
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
    // /auth/otp (signup verification)
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

    // /auth/reset-password/request
    r.child(
      '/reset-password/request',
      child: (_) => const ResetPasswordRequestPage(),
    );

    // /auth/reset-password/verify (OTP input)
    r.child(
      '/reset-password/verify',
      child: (_) {
        final data = Modular.args.data;
        if (data is Map) {
          final map = Map<String, dynamic>.from(data as Map);
          final String phone = map['phone'] as String;
          final String verificationId = map['verificationId'] as String;
          return ResetPasswordVerifyPage(
            phone: phone,
            verificationId: verificationId,
          );
        }
        return const ResetPasswordVerifyPage(phone: '', verificationId: '');
      },
    );

    // /auth/reset-password/new-password
    r.child(
      '/reset-password/new-password',
      child: (_) {
        final data = Modular.args.data;
        if (data is Map) {
          final map = Map<String, dynamic>.from(data as Map);
          final String phone = map['phone'] as String;
          final String firebaseIdToken = map['firebaseIdToken'] as String;
          return ResetPasswordNewPasswordPage(
            phone: phone,
            firebaseIdToken: firebaseIdToken,
          );
        }
        return const ResetPasswordNewPasswordPage(
          phone: '',
          firebaseIdToken: '',
        );
      },
    );
  }
}
