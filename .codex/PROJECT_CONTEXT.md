# Contexto para futuros trabajos

## Regla principal

Leer primero `docs/AUTHENTICATION_AND_BACKEND.md`. El proyecto ya tiene autenticacion nativa de Google, Facebook y base de Microsoft/AppAuth, Edge Functions de autenticacion social y paginas legales publicas en Supabase.

## No romper estos contratos

1. Android usa `com.manachynakusa.app`.
2. Facebook debe mantenerse en `LoginBehavior.nativeOnly`; el flujo nativo envia el `ClassicToken` a `facebook-native-auth`.
3. Microsoft usa `flutter_appauth` + `microsoft-native-auth`; necesita `MICROSOFT_CLIENT_ID` en Flutter por `--dart-define` y en Supabase Secrets.
4. Las funciones sociales usan secretos privados de Supabase. Nunca mover `SUPABASE_SERVICE_ROLE_KEY` a Flutter ni imprimir tokens.
5. `verifyOTP` para token hash debe recibir solo `tokenHash` y `OtpType.magiclink`; Supabase rechaza enviar tambien `email`.
6. El perfil se carga desde la tabla `users`; las funciones actualizan nombre y `avatar_url` tambien para usuarios existentes.
7. No cambiar las URLs publicas de politica y condiciones sin actualizar Meta Developers.
8. El panel admin usa la Edge Function `admin-dashboard`; no mover claves admin a Flutter. El acceso exige `public.users.role = 'admin'`.

## Flujo de depuracion de Facebook

1. Confirmar que aparece `status=LoginStatus.success`.
2. Confirmar `applicationId=810854808514091`.
3. Si falla la Edge Function, revisar `[Facebook backend]`.
4. Si aparece `Invalid OAuth access token signature`, revisar `FACEBOOK_APP_SECRET` en Supabase.
5. Si aparece `already been registered`, la funcion debe reutilizar el usuario existente, no crear otro.
6. Si aparece `Only the token_hash and type should be provided`, no enviar `email` a `verifyOTP`.

## Seguridad

- No solicitar ni pegar en el chat `FACEBOOK_APP_SECRET` o `SUPABASE_SERVICE_ROLE_KEY`.
- Si un secreto se comparte, regenerarlo y actualizarlo con `supabase secrets set`.
- Usar `.env.example` como plantilla. Los valores reales deben permanecer en `.env` local o en Supabase Secrets; `.env` está excluido de Git.
- No abrir RLS de usuarios, reservas o pagos para `anon` solo para solucionar un error de UI.

## Flujo de depuracion de Microsoft

1. El Client ID publico de Microsoft ya esta como valor por defecto en Flutter. `--dart-define=MICROSOFT_CLIENT_ID=<client-id>` solo hace falta si se cambia la app de Azure.
2. En Azure/Entra, registrar Redirect URI de app movil: `com.manachynakusa.app://oauthredirect`.
3. En Supabase, guardar el mismo Client ID: `supabase secrets set MICROSOFT_CLIENT_ID='<client-id>' --project-ref ikdcqxgecjzgjntejizu`.
4. Si el usuario no tiene sesion Microsoft guardada, Microsoft pedira correo y clave en su pantalla segura.
5. Si falla la Edge Function, revisar `[Microsoft backend]`.

## Comprobacion minima

```bash
flutter analyze --no-pub
flutter test
```

Para cambios de Edge Functions, desplegar la funcion correspondiente y verificar su URL HTTPS con `curl -I`.
