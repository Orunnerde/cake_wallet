#include <string.h>
#include <jni.h>
#include "../../ios/Classes/monero_api.h"
// #include "cstdlib"
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jstring JNICALL
Java_com_cakewallet_monero_MoneroApi_stringFromJNI(JNIEnv* env,
                                                  jobject thiz) {
    return env->NewStringUTF("Hello from JNI ! Compiled with ABI.");
}

JNIEXPORT void JNICALL
Java_com_cakewallet_monero_MoneroApi_setNodeAddressJNI(
        JNIEnv *env,
        jobject inst,
        jstring uri,
        jstring login,
        jstring password,
        jboolean use_ssl,
        jboolean is_light_wallet) {
    const char *_uri = env->GetStringUTFChars(uri, 0);
    const char *_login = "";
    const char *_password = "";
    char *error;

    if (login != NULL) {
        _login = env->GetStringUTFChars(login, 0);
    }

    if (password != NULL) {
        _password = env->GetStringUTFChars(password, 0);
    }
    char *__uri = (char*) _uri;
    char *__login = (char*) _login;
    char *__password = (char*) _password;
    bool inited = setup_node(__uri, __login, __password, false, false, error);

    //if (!inited) {
    //    env->ThrowNew(env->FindClass("java/lang/Exception"), error);
    //}

}

JNIEXPORT void JNICALL
Java_com_cakewallet_monero_MoneroApi_connectToNodeJNI(
        JNIEnv *env,
        jobject inst) {
    char *error;

    bool is_connected = connect_to_node(error);

    //if (!is_connected) {
    //    env->ThrowNew(env->FindClass("java/lang/Exception"), error);
    //}
}

#ifdef __cplusplus
}
#endif